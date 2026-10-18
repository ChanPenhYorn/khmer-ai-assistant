/**
 * Runtime-neutral environment access.
 *
 * The same provider logic runs on Deno (Supabase Edge Functions) and on
 * Cloudflare Workers (workerd). Deno exposes `Deno.env` with a `get()` method;
 * Workers expose a plain binding object. Both are adapted to [EnvReader].
 */

export interface EnvReader {
  get(name: string): string | undefined;
}

/** Adapts a plain Workers-style bindings object to an [EnvReader]. */
export function objectEnv(source: Record<string, unknown>): EnvReader {
  return {
    get(name: string): string | undefined {
      const value = source[name];
      return typeof value === "string" ? value : undefined;
    },
  };
}

export function readInt(
  env: EnvReader,
  name: string,
  fallback: number,
): number {
  const raw = env.get(name);
  if (!raw) return fallback;
  const parsed = Number.parseInt(raw, 10);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : fallback;
}
