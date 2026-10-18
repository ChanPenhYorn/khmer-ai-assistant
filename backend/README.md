# Backend — AI proxy

The operator-owned backend the Flutter app talks to. It holds the model
selection, builds prompts, applies limits, verifies the caller, and streams
replies back. The app never sees a vendor key or a model name.

**Status: deployed and verified with live requests.**

| Host | Endpoint | Provider path | Note |
| --- | --- | --- | --- |
| **Cloudflare Worker** (primary) | `https://api.chanpenh.store` | Workers AI binding — no key | `backend/cloudflare/` |
| Supabase Edge Function (alternative) | `https://<ref>.supabase.co/functions/v1/assistant` | HTTP + server-side key | `backend/supabase/` |

Both hosts run the **same** logic from `backend/shared/`. See
`../docs/ai/provider-integration.md` for the live-verification record.

```
backend/
  shared/                          runtime-neutral core, shared by both hosts
    env.ts                         EnvReader + binding adapters
    providers.ts                   config, task→model routing, prompt building, limits
    openai_client.ts               OpenAI-compatible HTTP client (Supabase host)
    auth.ts                        JWT (JWKS) + shared-token verification, Web Crypto
    rate_limit.ts                  in-memory sliding-window backstop
    http.ts                        CORS, JSON responses, error envelope
    providers_test.ts              deno tests for the pure logic
  cloudflare/
    wrangler.toml                  [ai] binding, custom domain, vars
    src/index.ts                   Worker: auth, rate limit, Workers AI call, SSE
    README.md                      deploy, config, auth options
  supabase/
    config.toml
    functions/assistant/index.ts   Deno entry: imports ../shared
  .env.example                     every variable, placeholders only
```

## How a request flows

```
app  POST {baseUrl}{assistantPath}
     │  { task, locale, messages | input, params }
     ▼
shared/providers.ts   validate → enforceInputLimit → resolveProfile/model
     │                buildMessages (system prompt + task rules)
     ▼
host adapter          Cloudflare: env.AI.run(model, { messages, stream })
     │                Supabase:   fetch {baseUrl}/chat/completions
     ▼
SSE back to app       data: {"delta":"…"} … then {text, model, usage}, then [DONE]
```

## Contract

Request (`POST` to the assistant path):

```json
{ "task": "translate", "locale": "km", "input": "Good morning",
  "params": { "source": "en", "target": "km" } }
```

Tasks: `chat`, `translate`, `improve_writing`, `summarize`, `explain_english`.

Streaming (client sends `Accept: text/event-stream`):

```
data: {"delta":"សូម"}
data: {"delta":"អរុណ"}
data: {"text":"សូមអរុណសួស្តី","model":"…","usage":{"input_tokens":12,"output_tokens":5}}
data: [DONE]
```

Non-streaming (`Accept: application/json`):

```json
{ "text": "សូមអរុណសួស្តី", "model": "…",
  "usage": { "input_tokens": 12, "output_tokens": 5 } }
```

Errors, any status:

```json
{ "error": { "code": "rate_limited", "message": "too many requests" } }
```

Codes: `unauthorized`, `rate_limited`, `quota_exceeded`, `input_too_large`,
`invalid_request`, `provider_error`, `server_error`. The client maps these in
`lib/core/network/dio_failure_mapper.dart`.

## Configuration

Variable names are identical on both hosts, so a config can move between them.
Non-secret values live in `wrangler.toml` (`[vars]`) on Cloudflare or in the
Supabase function secrets; secrets go through `wrangler secret put` /
`supabase secrets set`.

| Variable | Required | Purpose |
| --- | --- | --- |
| `AI_WORKERS_AI` | Cloudflare only | `true` = call via the Workers AI binding. |
| `AI_CHAT_BASE_URL` / `AI_CHAT_API_KEY` / `AI_CHAT_MODEL` | HTTP hosts | Chat, writing, summarise, explain. |
| `AI_TRANSLATION_MODEL` (or `AI_TRANSLATION_*`) | no | Dedicated translation model; falls back to chat. |
| `AI_MAX_INPUT_CHARS` | no | Server-side input cap (default 6000). |
| `AI_MAX_OUTPUT_TOKENS` | no | Output ceiling (default 1024). |
| `AI_REQUEST_TIMEOUT_MS` | no | Upstream timeout (default 45000). |
| `AI_ALLOWED_ORIGINS` | no | CORS allow-list; empty = `*`. |
| `AI_CLIENT_TOKEN` | no | Shared dev token. Not for production. |
| `AUTH_JWKS_URL` / `AUTH_ISSUER` / `AUTH_AUDIENCE` | no | Verify a JWT (Cloudflare Access or Supabase). |
| `SUPABASE_URL` | no | Shortcut: derives the Supabase JWKS URL and issuer. |

Do **not** set `SUPABASE_SECRET_KEY` (the `sb_secret_...` key) on either host.
It is not needed and must never be shipped to the client.

## Run locally

Cloudflare (uses the real Workers AI binding, no key):

```sh
cd backend/cloudflare
npx wrangler dev            # http://localhost:8787
```

Supabase / plain Deno (HTTP provider, needs a key):

```sh
cd backend/supabase/functions/assistant
export AI_CHAT_BASE_URL=https://api.sea-lion.ai/v1
export AI_CHAT_API_KEY=...
export AI_CHAT_MODEL=...
deno run --allow-net --allow-env index.ts   # http://localhost:8000
```

Then:

```sh
curl -s http://localhost:8787 \
  -H 'Content-Type: application/json' \
  -d '{"task":"translate","locale":"km","input":"Good morning","params":{"source":"en","target":"km"}}'
```

## Tests

Pure logic only; never touches a provider.

```sh
cd backend/shared
deno check ../supabase/functions/assistant/index.ts
deno test --allow-env --allow-net
```

## Deploy

Cloudflare (primary):

```sh
cd backend/cloudflare
npx wrangler deploy
```

Publishes to `khmer-ai-assistant.<account>.workers.dev` and, when the
`chanpenh.store` zone is in the same account, attaches `api.chanpenh.store`.

Supabase (alternative):

```sh
supabase functions deploy assistant --no-verify-jwt
```

Then point the app at the endpoint — see `../README.md` and
`../docs/ai/provider-integration.md`.

## Security notes

* Secrets come from the environment only; nothing is logged with request content.
* The Cloudflare host needs **no provider key at all** — the Workers AI binding
  is authorized by the account, not by a string the app or repo could leak.
* JWT verification uses the provider JWKS and never a service-role / secret key.
* Auth is required whenever a JWKS URL or shared token is set. With neither, the
  endpoint is open and only the rate limiter guards it — set up Cloudflare
  Access before a public launch.
* The rate limiter in `shared/rate_limit.ts` is per-isolate and resets on deploy.
  Replace it with a durable store (D1/KV/Durable Object, or a Supabase table)
  keyed by the verified user id before trusting it for quotas.
