/**
 * Khmer AI Assistant — AI proxy (Supabase Edge Function, Deno).
 *
 * ALTERNATIVE HOST. The primary deployment target is the Cloudflare Worker in
 * `backend/cloudflare/` (no provider key required, custom domain). This variant
 * is kept for teams already on Supabase and reaches the provider over HTTP with
 * a server-side key.
 *
 * Contract, error codes and prompt logic are shared in `backend/shared/` and
 * documented in `backend/README.md`.
 */

import {
  authenticate,
  authRequired,
  loadAuthConfig,
  type Caller,
} from "../../../shared/auth.ts";
import {
  corsHeaders,
  errorResponse,
  jsonResponse,
  logRequest,
} from "../../../shared/http.ts";
import { complete, streamDeltas } from "../../../shared/openai_client.ts";
import { createRateLimiter } from "../../../shared/rate_limit.ts";
import {
  type AssistantRequest,
  buildMessages,
  type ChatMessage,
  enforceInputLimit,
  InputError,
  loadConfig,
  type ProviderProfile,
  resolveProfile,
  STATUS_BY_CODE,
  TASKS,
} from "../../../shared/providers.ts";

const config = loadConfig(Deno.env);
const authConfig = loadAuthConfig(Deno.env);
const limiter = createRateLimiter(60_000, 20);

Deno.serve(async (request: Request): Promise<Response> => {
  const cors = corsHeaders(config.allowedOrigins, request.headers.get("origin"));

  if (request.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: cors });
  }
  if (request.method !== "POST") {
    return errorResponse("invalid_request", "POST only", cors);
  }

  let caller: Caller | null = null;
  if (authRequired(authConfig)) {
    caller = await authenticate(request, authConfig);
    if (!caller) {
      return errorResponse("unauthorized", "missing or invalid token", cors);
    }
  }
  if (limiter.limited(caller?.id ?? "anonymous")) {
    return errorResponse("rate_limited", "too many requests", cors);
  }

  let body: AssistantRequest;
  try {
    body = await request.json();
  } catch {
    return errorResponse("invalid_request", "body is not JSON", cors);
  }
  if (!body || typeof body.task !== "string" || !TASKS.has(body.task)) {
    return errorResponse("invalid_request", "unknown task", cors);
  }
  if (typeof body.locale !== "string") body.locale = "km";

  let profile: ProviderProfile | null;
  let messages: ChatMessage[];
  try {
    enforceInputLimit(body, config.maxInputChars);
    profile = resolveProfile(config, body.task);
    if (!profile) {
      return errorResponse("server_error", "no AI provider configured on the server", cors);
    }
    messages = buildMessages(body);
  } catch (error) {
    if (error instanceof InputError) return errorResponse(error.code, error.message, cors);
    return errorResponse("server_error", "failed to build request", cors);
  }

  const wantsStream = (request.headers.get("accept") ?? "").includes("text/event-stream");
  return wantsStream
    ? streamResponse(profile, messages, cors)
    : completeResponse(profile, messages, cors);
});

async function completeResponse(
  profile: ProviderProfile,
  messages: ChatMessage[],
  cors: Record<string, string>,
): Promise<Response> {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), config.requestTimeoutMs);
  const started = Date.now();
  try {
    const result = await complete(profile, messages, config, controller.signal);
    logRequest("complete", profile.name, messages.length, Date.now() - started, 200);
    return jsonResponse({ text: result.text, model: result.model, usage: result.usage }, 200, cors);
  } catch (error) {
    const code = error instanceof InputError ? error.code : "server_error";
    logRequest("complete", profile.name, messages.length, Date.now() - started, STATUS_BY_CODE[code] ?? 500);
    return errorResponse(code, error instanceof InputError ? error.message : "provider request failed", cors);
  } finally {
    clearTimeout(timer);
  }
}

function streamResponse(
  profile: ProviderProfile,
  messages: ChatMessage[],
  cors: Record<string, string>,
): Response {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), config.requestTimeoutMs);
  const encoder = new TextEncoder();

  const stream = new ReadableStream<Uint8Array>({
    async start(streamController) {
      const send = (payload: string) =>
        streamController.enqueue(encoder.encode(`data: ${payload}\n\n`));
      try {
        const generator = streamDeltas(profile, messages, config, controller.signal);
        let step = await generator.next();
        while (!step.done) {
          send(JSON.stringify({ delta: step.value }));
          step = await generator.next();
        }
        send(JSON.stringify({ text: step.value.text, model: step.value.model, usage: step.value.usage }));
        send("[DONE]");
      } catch (error) {
        const code = error instanceof InputError ? error.code : "server_error";
        send(JSON.stringify({ error: { code, message: "generation failed" } }));
      } finally {
        clearTimeout(timer);
        await streamController.close();
      }
    },
    cancel() {
      controller.abort();
    },
  });

  return new Response(stream, {
    status: 200,
    headers: {
      "Content-Type": "text/event-stream; charset=utf-8",
      "Cache-Control": "no-cache",
      ...cors,
    },
  });
}
