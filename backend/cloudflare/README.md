# Cloudflare Worker — AI proxy (primary backend)

Runs the Khmer AI Assistant's AI proxy on Cloudflare's edge at
**`https://api.chanpenh.store`**, calling a model through the **Workers AI
binding** — so there is no provider API key to store, rotate, or leak.

Prompt construction, limits, auth and the wire contract are shared with the
Supabase variant in `../shared/`. See `../README.md` for the full contract.

```
backend/cloudflare/
  wrangler.toml     worker config, [ai] binding, custom domain, vars
  src/index.ts      fetch handler: auth, rate limit, Workers AI call, SSE
  .dev.vars.example local secrets template (optional)
```

## Why Workers AI

* No API key in the app, the repo, or the Worker's vars.
* Model price is per-token and there is a free daily allowance; see
  `../../docs/ai/model-evaluation.md`.
* Same-region execution: the Worker and the model are both on Cloudflare.

Trade-off: model choice is limited to the Workers AI catalogue. To use a
different host (Together, SEA-LION API, self-hosted), switch this Worker to the
HTTP path in `../shared/openai_client.ts` and set `AI_CHAT_BASE_URL` +
`AI_CHAT_API_KEY` (a Worker secret) instead of the binding.

## Deploy

```sh
cd backend/cloudflare
npx wrangler deploy
```

That publishes to `khmer-ai-assistant.<account>.workers.dev` and, if the
`chanpenh.store` zone is in the same account, attaches `api.chanpenh.store`.

Check it:

```sh
curl -s https://api.chanpenh.store          # health: {"status":"ok",...}
curl -s https://api.chanpenh.store \
  -H 'Content-Type: application/json' \
  -d '{"task":"translate","locale":"km","input":"Good morning",
       "params":{"source":"en","target":"km"}}'
```

Local development:

```sh
cd backend/cloudflare
npx wrangler dev
```

## Configuration

Non-secret values live in `wrangler.toml` under `[vars]`. The Worker reads the
same variable names as the Supabase host:

| Variable | Meaning | Default |
| --- | --- | --- |
| `AI_WORKERS_AI` | Use the binding instead of HTTP. | `true` |
| `AI_CHAT_MODEL` | Workers AI model id. | `@cf/aisingapore/gemma-sea-lion-v4-27b-it` |
| `AI_TRANSLATION_MODEL` | Optional separate translation model. | unset |
| `AI_MAX_INPUT_CHARS` / `AI_MAX_OUTPUT_TOKENS` | Server-side caps. | `6000` / `1024` |
| `AI_ALLOWED_ORIGINS` | CORS allow-list; empty = `*`. | empty |
| `AI_CLIENT_TOKEN` | Shared dev token (secret). | unset |
| `AUTH_JWKS_URL` / `AUTH_ISSUER` / `AUTH_AUDIENCE` | Verify a JWT (e.g. Cloudflare Access). | unset |

### Authentication options

1. **Open (default).** No auth; the per-isolate rate limiter is the only guard.
   Fine to start; not fine for a public launch.
2. **Cloudflare Access.** Put the Worker behind an Access application, set
   `AUTH_JWKS_URL=https://<team>.cloudflareaccess.com/cdn-cgi/access/certs`,
   `AUTH_ISSUER=https://<team>.cloudflareaccess.com`, and
   `AUTH_AUDIENCE=<application AUD tag>`. The app sends the Access JWT.
3. **Supabase JWT.** Set `SUPABASE_URL`; the Worker verifies it against the
   project JWKS.

Secrets (options 2/3):

```sh
npx wrangler secret put AI_CLIENT_TOKEN
```

## Limits and quotas

`../shared/rate_limit.ts` is an in-memory backstop, per isolate. For durable
per-user quotas add a **Durable Object** or **KV** counter keyed by the verified
user id and switch the limiter call to it. Also enable a Cloudflare rate-limit
rule on the route as a cheap first line of defence.

## Model note

`@cf/aisingapore/gemma-sea-lion-v4-27b-it` is the SEA-LION family on Workers AI.
Confirm Khmer quality with the evaluation harness (`../../eval/README.md`)
before shipping, and revisit if a stronger Khmer model lands on Workers AI.
