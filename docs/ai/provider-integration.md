# AI provider integration

How the Khmer AI Assistant talks to a model, and how to configure a real
provider. Read alongside `model-evaluation.md` (which model) and
`backend/README.md` (the server contract).

**Integration status: the backend is deployed and answers live requests.** The
Cloudflare Worker at `https://api.chanpenh.store` returns real Khmer replies
from a hosted model (recorded in §5). Remaining before calling it *finished*:
one end-to-end turn from the Flutter app on a device, and a full evaluation run
comparing candidates (§6).

---

## 1. The boundary (why vendor details never leak)

```
Flutter app
  presentation  → screens, widgets            (no HTTP, no model names)
  domain        → AiRepository, use cases     (no vendor types)
  data          → AiDataSource                (only knows an endpoint URL)
        │  POST {baseUrl}{assistantPath}   JSON in, JSON or SSE out
        ▼
Operator-owned backend
  Cloudflare Worker (primary): Workers AI binding, no provider key
  Supabase Edge Function (alt): HTTP + server-side key
  prompts, model selection, limits, auth
        │  binding / HTTP
        ▼
Hosted model endpoint (Workers AI, SEA-LION API, Qwen host, ...)
```

Concrete pieces that already exist in the app:

* `lib/features/ai/domain/repositories/ai_repository.dart` — the domain
  contract (`translate`, `improveWriting`, `summarize`, `explainEnglish`,
  `streamMessage`). No model or vendor appears here.
* `lib/features/ai/data/datasources/ai_data_source.dart` — the transport
  contract. Implemented by `RemoteAiDataSource` (real endpoint) and
  `MockAiDataSource` (offline dev/demo).
* `lib/core/config/ai_config.dart` — all provider configuration for the
  client, read from `--dart-define`, with the deployed backend baked in as the
  default. **No secret lives here.**
* `lib/features/ai/presentation/providers/ai_providers.dart` — selects the
  data source once, at startup. There is no silent fallback to the sample
  source: if a build clears the base URL without enabling demo mode, it reports
  a misconfiguration instead of pretending.

Swapping models is a **server-side** change. The Flutter binary does not need
to be rebuilt when the operator changes which model answers.

### Adding a new provider the right way

1. Add or adjust the model/profile in the backend (`backend/shared/providers.ts`
   for the task map, or the host's config).
2. Keep request/response formats and vendor names inside the backend.
3. If the wire contract must change, update `AiRequestDto` /
   `AiResponseDto` in the **data layer only**, plus the tests.
4. Never surface a model name, vendor name or API key in domain or
   presentation code.

---

## 2. Client configuration (`--dart-define`)

None of these are secrets — every value ends up inside the shipped binary.

| Define | Meaning | Default |
| --- | --- | --- |
| `AI_BASE_URL` | Base URL of the operator's AI proxy. | `https://api.chanpenh.store` |
| `AI_ASSISTANT_PATH` | Path appended to the base URL. | `/v1/assistant` |
| `AI_REQUEST_TIMEOUT_SECONDS` | Per-request timeout. | `45` |
| `AI_MAX_INPUT_CHARS` | Local input cap before a request is sent. | `6000` |
| `AI_USE_MOCK` | Use the built-in sample data source. Dev/demo only. | `false` |
| `AI_ENABLE_STREAMING` | Ask the backend for a streamed reply. | `true` |

The deployed backend is baked in as the default, so a plain `flutter run`
connects. Override only when pointing somewhere else:

```sh
flutter run                                              # deployed backend
flutter run --dart-define=AI_BASE_URL=https://staging.example.test
flutter run --dart-define=AI_USE_MOCK=true                # offline demo
```

The Worker accepts a `POST` on any path, so `/v1/assistant` works as-is. The
Supabase alternative uses `AI_BASE_URL=https://<ref>.supabase.co/functions/v1`
with `AI_ASSISTANT_PATH=/assistant`.

`--dart-define` values are compile-time: after changing one, **stop and re-run**
— a hot reload keeps the old build.

Example demo run with no backend at all:

```sh
flutter run --dart-define=AI_USE_MOCK=true
```

Demo mode shows a persistent **Demo mode** banner in the UI. Mock replies
always state that they are samples and never report usage numbers. There is no
way to reach mock replies in a production build unless the flag is set
explicitly.

### Optional client auth

If the backend requires a bearer token, the app stores it in
`flutter_secure_storage` (`SecureAuthTokenStore`) and attaches it as
`Authorization: Bearer …`. The token is **never** a provider API key — it is a
short-lived operator-issued token (a Supabase JWT or a Cloudflare Access JWT).
Provider keys stay server-side; on Cloudflare there is no provider key at all.

---

## 3. Server configuration

Variables have the same names on both hosts. See `backend/.env.example`,
`backend/cloudflare/README.md` and `backend/README.md`. Summary:

| Variable | Purpose |
| --- | --- |
| `AI_WORKERS_AI` | Cloudflare: `true` routes calls through the Workers AI binding. |
| `AI_CHAT_BASE_URL` / `AI_CHAT_API_KEY` / `AI_CHAT_MODEL` | HTTP hosts: chat + writing + summarize + explain. |
| `AI_TRANSLATION_BASE_URL` / `AI_TRANSLATION_API_KEY` / `AI_TRANSLATION_MODEL` | Optional dedicated translation model (e.g. GemmaX2). Falls back to the chat model when unset. |
| `AI_MAX_INPUT_CHARS` | Server-side input cap (authoritative). |
| `AI_MAX_OUTPUT_TOKENS` | Output token ceiling. |
| `AI_REQUEST_TIMEOUT_MS` | Upstream timeout. |
| `AI_ALLOWED_ORIGINS` | CORS allow-list. |
| `AI_CLIENT_TOKEN` | Optional shared token the app must present. |
| `AUTH_JWKS_URL` / `AUTH_ISSUER` / `AUTH_AUDIENCE` | Verify a bearer JWT (Cloudflare Access or Supabase). |

The server-side checks are authoritative; client-side limits are only for fast
feedback.

The Cloudflare host needs **no provider key**: the Workers AI binding is
authorized by the Cloudflare account. Switching to a key-based provider means
setting `AI_WORKERS_AI=false` plus `AI_CHAT_BASE_URL` / `AI_CHAT_API_KEY`
(a `wrangler secret`).

---

## 4. Error contract

The backend always returns errors as:

```json
{ "error": { "code": "rate_limited", "message": "…" } }
```

Recognised codes (client mapping in
`lib/core/network/dio_failure_mapper.dart`):
`unauthorized`, `rate_limited`, `quota_exceeded`, `input_too_large`,
`invalid_request`, `provider_error`, `server_error`.

The client maps these to typed failures and localized messages. Raw provider
errors, stack traces and secrets are never shown to users and never logged
with content.

---

## 5. What is mocked vs. real today

| Piece | State |
| --- | --- |
| Domain/data provider abstraction | **real**, tested |
| Wire contract (JSON in/out, SSE) | **real**, tested against a fake |
| `RemoteAiDataSource` | implemented, unit-tested with a mocked Dio |
| `MockAiDataSource` | real, used only when `AI_USE_MOCK=true` |
| Cloudflare Worker (`api.chanpenh.store`) | **deployed** |
| Live model request (non-stream + stream) | **done** — see below |
| Full 36-item Khmer run on the deployed model | **done** — see `model-evaluation.md` §6 |
| End-to-end turn from the Flutter app | transport **done** (live test, below); device tap-through **not yet** |
| Full evaluation vs. a Qwen baseline | **not yet** |

### Live request record (2026-10-17)

Host: `https://api.chanpenh.store` (Cloudflare Worker, Workers AI binding).
Model: `@cf/aisingapore/gemma-sea-lion-v4-27b-it`.

Health:

```json
{"status":"ok","mode":"workers-ai","workersAi":true}
```

Non-streaming translation (`en` → `km`), input
`"Please submit your documents before Friday."`:

```json
{"text":"សូមដាក់ឯកសាររបស់អ្នកមុនថ្ងៃសុក្រ។","model":"@cf/aisingapore/gemma-sea-lion-v4-27b-it",
 "usage":{"input_tokens":169,"output_tokens":14}}
```

Streaming chat emitted `data: {"delta": …}` frames in order, then a terminal
`{text, model, usage}` envelope, then `data: [DONE]`.

Observed quality note: replies are fluent Khmer but the model often appends
Latin transliteration and an English gloss (e.g. `(Khnhom chmueh AI …)`). That
is a prompt/decoding concern to weigh in the evaluation, not a transport bug.

### Live record: the app's own client against the live backend (2026-10-18)

`test/live/live_backend_test.dart` runs the app's real `Dio` client,
`RemoteAiDataSource`, `AiSseParser` and response DTOs against the deployed
worker. It asserts:

* a non-streaming translation returns non-empty Latin text, a model name that
  only the server can supply, and non-empty `usage`;
* a streaming chat turn emits **more than one** `delta` frame, ends with exactly
  one terminal envelope, and the concatenated deltas equal that envelope's text
  — so the parser is not silently dropping or duplicating chunks.

```sh
flutter test test/live --dart-define=LIVE_AI_BASE_URL=https://api.chanpenh.store
```

Result: 2 passed. This closes the transport half of "one end-to-end turn"; what
remains is the same turn tapped through in the UI on a device (§6 step 4).

---

## 6. Verification checklist

1. ~~Deploy the backend or run it locally.~~ **Done** — Cloudflare Worker live.
2. Put a real provider key in the server environment. **Not needed** on
   Cloudflare (binding-based); required only on the Supabase/HTTP path.
3. ~~Send one request with `curl`, confirm a non-empty Khmer reply and HTTP
   200.~~ **Done** — recorded in §5.
4. Point the app at the endpoint (`AI_BASE_URL=…`) and confirm one chat turn
   and one translation succeed. **Transport verified** by the live test in §5;
   the on-device UI tap-through is **remaining**.
5. Run the evaluation harness against the same model. **Full 36-item run done**
   via `--mode proxy`; results in `model-evaluation.md` §6. The Qwen baseline
   comparison is still required before the model choice is final.
6. Update the status line here and in `model-evaluation.md` as steps land.

If any step fails, report exactly which step failed and why. Never claim a
provider works because the code compiles.
