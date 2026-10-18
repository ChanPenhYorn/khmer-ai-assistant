/**
 * OpenAI-compatible HTTP client over `fetch`.
 *
 * Used by hosts that reach a provider over HTTP with a bearer key (SEA-LION,
 * Together, Cloudflare REST, self-hosted vLLM). The Cloudflare Worker instead
 * uses the Workers AI binding and does not import this file.
 *
 * The key is sent upstream but never logged or echoed.
 */

import {
  type ChatMessage,
  type ProviderProfile,
  type ProxyConfig,
  type Usage,
  InputError,
} from "./providers.ts";

export interface UpstreamResult {
  text: string;
  model: string;
  usage?: Usage;
}

/** Runs a non-streaming completion. */
export async function complete(
  profile: ProviderProfile,
  messages: ChatMessage[],
  config: ProxyConfig,
  signal: AbortSignal,
): Promise<UpstreamResult> {
  const response = await fetch(`${profile.baseUrl}/chat/completions`, {
    method: "POST",
    signal,
    headers: upstreamHeaders(profile),
    body: JSON.stringify({
      model: profile.model,
      messages,
      max_tokens: config.maxOutputTokens,
      stream: false,
    }),
  });

  if (!response.ok) throw await upstreamError(response);

  const json = await response.json();
  const text = json?.choices?.[0]?.message?.content;
  if (typeof text !== "string" || text.trim().length === 0) {
    throw new InputError("provider_error", "upstream returned an empty reply");
  }
  return { text, model: profile.model, usage: readUsage(json) };
}

/**
 * Streams text deltas from an OpenAI-compatible endpoint.
 * Yields plain strings; the caller wraps them in the client's SSE envelope.
 */
export async function* streamDeltas(
  profile: ProviderProfile,
  messages: ChatMessage[],
  config: ProxyConfig,
  signal: AbortSignal,
): AsyncGenerator<string, UpstreamResult, void> {
  const response = await fetch(`${profile.baseUrl}/chat/completions`, {
    method: "POST",
    signal,
    headers: { ...upstreamHeaders(profile), Accept: "text/event-stream" },
    body: JSON.stringify({
      model: profile.model,
      messages,
      max_tokens: config.maxOutputTokens,
      stream: true,
    }),
  });

  if (!response.ok) throw await upstreamError(response);
  if (!response.body) {
    throw new InputError("provider_error", "upstream returned no stream");
  }

  const decoder = new TextDecoder();
  const reader = response.body.getReader();
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
      const delta = readDelta(frame);
      if (delta) {
        full += delta;
        yield delta;
      }
      const frameUsage = readUsage(frame);
      if (frameUsage) usage = frameUsage;
    }
  }

  if (full.trim().length === 0) {
    throw new InputError("provider_error", "upstream stream was empty");
  }
  return { text: full, model: profile.model, usage };
}

function upstreamHeaders(profile: ProviderProfile): Record<string, string> {
  const headers: Record<string, string> = {
    "Content-Type": "application/json",
  };
  if (profile.apiKey) headers["Authorization"] = `Bearer ${profile.apiKey}`;
  return headers;
}

function readDelta(frame: unknown): string | null {
  const choices = (frame as { choices?: unknown }).choices;
  if (!Array.isArray(choices) || choices.length === 0) return null;
  const delta = (choices[0] as { delta?: { content?: unknown } }).delta;
  return typeof delta?.content === "string" ? delta.content : null;
}

function readUsage(frame: unknown): Usage | undefined {
  const usage = (frame as { usage?: Record<string, unknown> }).usage;
  if (!usage) return undefined;
  const input = Number(usage.prompt_tokens ?? usage.input_tokens ?? 0);
  const output = Number(usage.completion_tokens ?? usage.output_tokens ?? 0);
  if (!Number.isFinite(input) && !Number.isFinite(output)) return undefined;
  return {
    input_tokens: Number.isFinite(input) ? input : 0,
    output_tokens: Number.isFinite(output) ? output : 0,
  };
}

async function upstreamError(response: Response): Promise<InputError> {
  const status = response.status;
  if (status === 401 || status === 403) {
    return new InputError("unauthorized", "upstream rejected credentials");
  }
  if (status === 429) return new InputError("rate_limited", "upstream rate limit");
  if (status === 413) {
    return new InputError("input_too_large", "upstream rejected payload size");
  }
  if (status >= 500) {
    return new InputError("provider_error", `upstream error ${status}`);
  }
  // Do not echo the body: it may contain sensitive data.
  return new InputError("provider_error", `upstream returned ${status}`);
}
