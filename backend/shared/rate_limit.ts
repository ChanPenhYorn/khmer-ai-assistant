/**
 * Small in-memory sliding-window limiter, one bucket per identity.
 *
 * This is per-isolate / per-instance and resets on deploy. It is a backstop
 * against obvious abuse, NOT durable quota enforcement. Replace it with a
 * store-backed check (D1/KV/Durable Object on Cloudflare, a Supabase table on
 * Deno) before relying on it for per-user allowances.
 */
export interface RateLimiter {
  /** Records a hit and returns `true` when the identity is over the limit. */
  limited(identity: string): boolean;
}

export function createRateLimiter(
  windowMs: number,
  maxRequestsPerWindow: number,
): RateLimiter {
  const buckets = new Map<string, number[]>();
  return {
    limited(identity: string): boolean {
      const now = Date.now();
      const recent = (buckets.get(identity) ?? []).filter(
        (t) => now - t < windowMs,
      );
      recent.push(now);
      buckets.set(identity, recent);
      return recent.length > maxRequestsPerWindow;
    },
  };
}
