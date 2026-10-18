/** Shared HTTP helpers: CORS, JSON responses and the error envelope. */

import { STATUS_BY_CODE } from "./providers.ts";

export function corsHeaders(
  allowedOrigins: string[],
  origin: string | null,
): Record<string, string> {
  const allowOrigin = allowedOrigins.length === 0
    ? "*"
    : origin && allowedOrigins.includes(origin)
    ? origin
    : allowedOrigins[0];
  return {
    "Access-Control-Allow-Origin": allowOrigin,
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "authorization, content-type, accept",
    "Vary": "Origin",
  };
}

export function jsonResponse(
  body: unknown,
  status: number,
  cors: Record<string, string>,
): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...cors },
  });
}

export function errorResponse(
  code: string,
  message: string,
  cors: Record<string, string>,
): Response {
  const status = STATUS_BY_CODE[code] ?? 500;
  return jsonResponse({ error: { code, message } }, status, cors);
}

/** Diagnostics only: never includes content, keys or tokens. */
export function logRequest(
  mode: string,
  model: string,
  messageCount: number,
  ms: number,
  status: number,
): void {
  console.log(
    `[assistant] ${mode} model=${model} messages=${messageCount} ms=${ms} status=${status}`,
  );
}
