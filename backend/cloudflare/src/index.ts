/**
 * Khmer AI Assistant — AI proxy (Cloudflare Worker).
 *
 * PRIMARY HOST. Runs on Cloudflare's edge and calls a model through the
 * Workers AI binding, so there is no provider API key to store or leak. Prompt
 * construction, limits, auth and the wire contract are shared with the
 * Supabase variant in `backend/shared/`.
 *
 * Deploy with `wrangler deploy` (see README.md). Custom domain:
 * `api.chanpenh.store`.
 */

import {
  authenticate,
  authRequired,
  loadAuthConfig,
  type Caller,
} from "../../shared/auth.ts";
import {
  corsHeaders,
  errorResponse,
  jsonResponse,
  logRequest,
} from "../../shared/http.ts";
import { createRateLimiter } from "../../shared/rate_limit.ts";
import { objectEnv } from "../../shared/env.ts";
import {
  type AssistantRequest,
  buildMessages,
  type ChatMessage,
  enforceInputLimit,
  InputError,
  loadConfig,
  resolveWorkersAiModel,
  type Usage,
  TASKS,
} from "../../shared/providers.ts";

interface AiBinding {
  run(
    model: string,
    inputs: Record<string, unknown>,
    options?: { signal?: AbortSignal },
  ): Promise<unknown>;
}

interface Env {
  AI: AiBinding;
  [key: string]: unknown;
}

const limiter = createRateLimiter(60_000, 20);

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const config = loadConfig(objectEnv(env));
    const authConfig = loadAuthConfig(objectEnv(env));
    const cors = corsHeaders(config.allowedOrigins, request.headers.get("origin"));

    if (request.method === "OPTIONS") {
      return new Response(null, { status: 204, headers: cors });
    }
    if (request.method === "GET") {
      // Health probe: confirms the host is up without spending model units.
      return jsonResponse(
        { status: "ok", mode: "workers-ai", workersAi: Boolean(env.AI) },
        200,
        cors,
      );
    }
    if (request.method !== "POST") {
      return errorResponse("invalid_request", "POST only", cors);
    }
    if (!env.AI) {
      return errorResponse("server_error", "Workers AI binding is not configured", cors);
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

    let model: string | null;
    let messages: ChatMessage[];
    try {
      enforceInputLimit(body, config.maxInputChars);
      model = resolveWorkersAiModel(objectEnv(env), body.task);
      if (!model) {
        return errorResponse("server_error", "no model configured (AI_CHAT_MODEL)", cors);
      }
      messages = buildMessages(body);
    } catch (error) {
      if (error instanceof InputError) return errorResponse(error.code, error.message, cors);
      return errorResponse("server_error", "failed to build request", cors);
    }

    const wantsStream = (request.headers.get("accept") ?? "").includes("text/event-stream");
    return wantsStream
      ? streamResponse(env.AI, model, messages, config.maxOutputTokens, cors)
      : completeResponse(env.AI, model, messages, config.maxOutputTokens, cors);
  },
};

async function completeResponse(
  ai: AiBinding,
  model: string,
  messages: ChatMessage[],
  maxTokens: number,
  cors: Record<string, string>,
): Promise<Response> {
  const started = Date.now();
  try {
    const output = await ai.run(model, {
      messages,
      max_tokens: maxTokens,
      stream: false,
    });
    const text = readResponseText(output);
    if (!text) {
      logRequest("complete", model, messages.length, Date.now() - started, 502);
      return errorResponse("provider_error", "model returned an empty reply", cors);
    }
    logRequest("complete", model, messages.length, Date.now() - started, 200);
    return jsonResponse({ text, model, usage: readUsage(output) }, 200, cors);
  } catch (error) {
    logRequest("complete", model, messages.length, Date.now() - started, 500);
    return errorResponse("provider_error", describe(error), cors);
  }
}

function streamResponse(
  ai: AiBinding,
  model: string,
  messages: ChatMessage[],
  maxTokens: number,
  cors: Record<string, string>,
): Response {
  const encoder = new TextEncoder();
  const stream = new ReadableStream<Uint8Array>({
    async start(controller) {
      const send = (payload: string) =>
        controller.enqueue(encoder.encode(`data: ${payload}\n\n`));
      try {
        const output = await ai.run(model, {
          messages,
          max_tokens: maxTokens,
          stream: true,
        });
        const body = readStreamBody(output);
        if (!body) {
          send(JSON.stringify({ error: { code: "provider_error", message: "no stream" } }));
          return;
        }

        const decoder = new TextDecoder();
        const reader = body.getReader();
        let buffer = "";
        let full = "";
        let usage: Usage | undefined;

        while (true) {
          const { done, value } = await reader.read();
          if (done) break;
          buffer += decoder.decode(value, { stream: true });
          let newline: number;
          while ((newline = buffer.indexOf("\n")) !== -1) {
            const line = buffer.slice(0, newline).trim();
            buffer = buffer.slice(newline + 1);
            if (!line.startsWith("data:")) continue;
            const payload = line.slice(5).trim();
            if (payload === "" || payload === "[DONE]") continue;
            let frame: unknown;
            try {
              frame = JSON.parse(payload);
            } catch {
              continue;
            }
            const delta = readResponseText(frame);
            if (delta) {
              full += delta;
              send(JSON.stringify({ delta }));
            }
            const frameUsage = readUsage(frame);
            if (frameUsage) usage = frameUsage;
          }
        }

        if (full.trim().length === 0) {
          send(JSON.stringify({ error: { code: "provider_error", message: "empty stream" } }));
          return;
        }
        send(JSON.stringify({ text: full, model, usage }));
        send("[DONE]");
      } catch (error) {
        send(JSON.stringify({ error: { code: "provider_error", message: describe(error) } }));
      } finally {
        await controller.close();
      }
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

/**
 * Extracts text from the shapes the binding returns. Recent Workers AI chat
 * models answer in OpenAI format; older ones use `{ response }`.
 */
function readResponseText(output: unknown): string {
  if (typeof output === "string") return output;
  if (output && typeof output === "object") {
    const record = output as Record<string, unknown>;
    if (typeof record.response === "string") return record.response;

    const choices = record.choices;
    if (Array.isArray(choices) && choices.length > 0) {
      const choice = choices[0] as {
        message?: { content?: unknown };
        delta?: { content?: unknown };
        text?: unknown;
      };
      if (typeof choice.message?.content === "string") return choice.message.content;
      if (typeof choice.delta?.content === "string") return choice.delta.content;
      if (typeof choice.text === "string") return choice.text;
    }

    const result = record.result as Record<string, unknown> | undefined;
    if (result && typeof result.response === "string") return result.response;
  }
  return "";
}

function readStreamBody(output: unknown): ReadableStream<Uint8Array> | null {
  if (output instanceof ReadableStream) return output as ReadableStream<Uint8Array>;
  if (output && typeof output === "object") {
    const maybe = (output as { body?: unknown }).body;
    if (maybe instanceof ReadableStream) return maybe as ReadableStream<Uint8Array>;
  }
  return null;
}

function readUsage(output: unknown): Usage | undefined {
  if (!output || typeof output !== "object") return undefined;
  const usage = (output as { usage?: Record<string, unknown> }).usage;
  if (!usage) return undefined;
  const input = Number(usage.prompt_tokens ?? 0);
  const outputTokens = Number(usage.completion_tokens ?? 0);
  return {
    input_tokens: Number.isFinite(input) ? input : 0,
    output_tokens: Number.isFinite(outputTokens) ? outputTokens : 0,
  };
}

function describe(error: unknown): string {
  const message = error instanceof Error ? error.message : String(error);
  // Keep provider errors short and free of request content.
  return message.slice(0, 200);
}
