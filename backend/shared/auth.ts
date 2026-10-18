/**
 * Caller authentication for the assistant proxy.
 *
 * Two mechanisms, in priority order:
 *  1. A bearer JWT verified locally against a JWKS (asymmetric RS256/ES256).
 *     Works with Supabase JWTs or Cloudflare Access JWTs — the issuer and
 *     audience are configurable.
 *  2. A shared client token (`AI_CLIENT_TOKEN`) for local development only.
 *
 * Verification uses Web Crypto, so there is no third-party import and only one
 * network dependency: fetching the public JWKS (cached for 10 minutes).
 *
 * No service-role / secret key is ever involved. The client presents an
 * end-user token, never a provider or admin key.
 */

import { type EnvReader } from "./env.ts";

interface Jwk {
  kty: string;
  kid?: string;
  alg?: string;
  use?: string;
  n?: string;
  e?: string;
  crv?: string;
  x?: string;
  y?: string;
}

interface Jwks {
  keys: Jwk[];
}

export interface AuthConfig {
  jwksUrl: string | null;
  issuer: string | null;
  audience: string;
  sharedToken: string | null;
}

export interface Caller {
  /** Stable identity used for rate limiting / quotas. */
  id: string;
  /** Present when the caller presented a verified JWT. */
  userId?: string;
}

/**
 * Resolves auth configuration from the environment.
 *
 * Supabase: set `SUPABASE_URL` (and optionally `SUPABASE_JWKS_URL`).
 * Cloudflare Access: set `AUTH_JWKS_URL`, `AUTH_ISSUER` and `AUTH_AUDIENCE`.
 */
export function loadAuthConfig(env: EnvReader): AuthConfig {
  const supabaseUrl =
    (env.get("SUPABASE_URL") ?? "").trim().replace(/\/+$/, "") || null;

  const jwksUrl =
    (env.get("AUTH_JWKS_URL") ?? "").trim() ||
    (env.get("SUPABASE_JWKS_URL") ?? "").trim() ||
    (supabaseUrl ? `${supabaseUrl}/auth/v1/.well-known/jwks.json` : "") ||
    null;

  const issuer =
    (env.get("AUTH_ISSUER") ?? "").trim() ||
    (supabaseUrl ? `${supabaseUrl}/auth/v1` : "") ||
    null;

  const audience =
    (env.get("AUTH_AUDIENCE") ?? "").trim() ||
    (env.get("SUPABASE_JWT_AUDIENCE") ?? "").trim() ||
    "authenticated";

  return { jwksUrl, issuer, audience, sharedToken: env.get("AI_CLIENT_TOKEN")?.trim() || null };
}

/** `true` when at least one authentication mechanism is configured. */
export function authRequired(config: AuthConfig): boolean {
  return config.jwksUrl !== null || config.sharedToken !== null;
}

/**
 * Resolves the caller, or returns `null` when authentication is required but
 * the request is not authenticated. Never throws on malformed tokens.
 */
export async function authenticate(
  request: Request,
  config: AuthConfig,
): Promise<Caller | null> {
  const header = request.headers.get("authorization") ?? "";
  const match = header.match(/^Bearer\s+(.+)$/i);
  if (!match) return null;
  const token = match[1].trim();

  if (config.sharedToken && token === config.sharedToken) {
    return { id: "shared-token" };
  }

  if (config.jwksUrl) {
    const verified = await verifyJwt(token, config);
    if (verified) return { id: `user:${verified.sub}`, userId: verified.sub };
  }

  return null;
}

let cachedJwks: { url: string; keys: Jwk[]; fetchedAt: number } | null = null;
const JWKS_TTL_MS = 10 * 60 * 1000;

async function fetchJwks(url: string): Promise<Jwk[]> {
  const now = Date.now();
  if (cachedJwks && cachedJwks.url === url && now - cachedJwks.fetchedAt < JWKS_TTL_MS) {
    return cachedJwks.keys;
  }
  const response = await fetch(url, { headers: { Accept: "application/json" } });
  if (!response.ok) throw new Error(`jwks fetch failed: ${response.status}`);
  const body = (await response.json()) as Jwks;
  const keys = Array.isArray(body.keys) ? body.keys : [];
  cachedJwks = { url, keys, fetchedAt: now };
  return keys;
}

interface JwtClaims {
  sub: string;
  exp?: number;
  iss?: string;
  aud?: string | string[];
}

async function verifyJwt(token: string, config: AuthConfig): Promise<JwtClaims | null> {
  const parts = token.split(".");
  if (parts.length !== 3) return null;
  const [encodedHeader, encodedPayload, encodedSignature] = parts;

  let header: { alg?: string; kid?: string };
  let claims: JwtClaims;
  try {
    header = JSON.parse(decodeBase64UrlToString(encodedHeader));
    claims = JSON.parse(decodeBase64UrlToString(encodedPayload));
  } catch {
    return null;
  }

  const alg = header.alg ?? "";
  if (alg !== "RS256" && alg !== "ES256") return null;

  if (typeof claims.sub !== "string" || claims.sub.length === 0) return null;
  if (typeof claims.exp === "number" && claims.exp * 1000 < Date.now()) return null;
  if (config.issuer && claims.iss !== config.issuer) return null;
  if (!audienceMatches(claims.aud, config.audience)) return null;

  let keys: Jwk[];
  try {
    keys = await fetchJwks(config.jwksUrl!);
  } catch {
    return null;
  }
  const jwk = keys.find((k) => k.kid && k.kid === header.kid) ??
    keys.find((k) => k.alg === alg);
  if (!jwk) return null;

  try {
    const key = await importJwk(jwk, alg);
    const signed = new TextEncoder().encode(`${encodedHeader}.${encodedPayload}`);
    const signature = decodeBase64Url(encodedSignature);
    const ok = await crypto.subtle.verify(
      alg === "ES256" ? { name: "ECDSA", hash: "SHA-256" } : { name: "RSASSA-PKCS1-v1_5" },
      key,
      signature,
      signed,
    );
    return ok ? claims : null;
  } catch {
    return null;
  }
}

function audienceMatches(audience: string | string[] | undefined, expected: string): boolean {
  if (Array.isArray(audience)) return audience.includes(expected);
  return audience === expected;
}

async function importJwk(jwk: Jwk, alg: string): Promise<CryptoKey> {
  if (alg === "ES256") {
    return await crypto.subtle.importKey(
      "jwk",
      { kty: jwk.kty, crv: jwk.crv ?? "P-256", x: jwk.x!, y: jwk.y!, ext: true },
      { name: "ECDSA", namedCurve: "P-256" },
      false,
      ["verify"],
    );
  }
  return await crypto.subtle.importKey(
    "jwk",
    { kty: jwk.kty, n: jwk.n!, e: jwk.e!, ext: true },
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["verify"],
  );
}

function decodeBase64Url(input: string): Uint8Array<ArrayBuffer> {
  const normalized = input.replace(/-/g, "+").replace(/_/g, "/");
  const padded = normalized + "=".repeat((4 - (normalized.length % 4)) % 4);
  const binary = atob(padded);
  const bytes = new Uint8Array(new ArrayBuffer(binary.length));
  for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
  return bytes;
}

function decodeBase64UrlToString(input: string): string {
  return new TextDecoder().decode(decodeBase64Url(input));
}
