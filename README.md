# Khmer AI Assistant

A Khmer-first AI assistant for everyday Cambodian users: chat, Khmer↔English
translation, writing help, summarization and English learning — with a
natural-Khmer interface (Khmer and English locales, light and dark themes).

Built with Flutter, Riverpod, go_router and a clean-architecture split
(feature-first). The app never talks to an AI vendor directly: it calls an
operator-owned endpoint, so provider API keys stay server-side.

## Status

* App: chat, translation, writing, summarization, history, settings — built
  and covered by tests.
* AI boundary: domain/data provider abstraction, wire contract, remote data
  source and offline mock are in place.
* Backend: proxy **deployed and answering live requests** at
  `https://api.chanpenh.store` (Cloudflare Worker, Workers AI binding).
* Model choice: a working default is live; the final pick awaits the full Khmer
  evaluation in [`docs/ai/model-evaluation.md`](docs/ai/model-evaluation.md) §6.
* Wire contract: verified end-to-end against the deployed backend —
  `test/live/live_backend_test.dart` drives the real data source over real HTTP
  and SSE (no doubles). Skipped by default; see **Quality checks** below.
* Not yet done: one end-to-end turn tapped through on a device, and the full
  evaluation run. See
  [`docs/ai/provider-integration.md`](docs/ai/provider-integration.md).

## Quick start

```sh
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs   # if providers changed
flutter gen-l10n                                                  # if ARB files changed
flutter run                                                # connected to the live backend
flutter run --dart-define=AI_USE_MOCK=true                 # offline demo mode
```

`build_runner` and `gen-l10n` write into the tree (`.g.dart`, `.freezed.dart`,
`lib/app/localization/generated/`), so run them after changing providers or ARB
files and commit the result.

The deployed backend (`https://api.chanpenh.store`) is the default, so a plain
`flutter run` answers from the real model. Demo mode answers from a built-in
sample source and shows a persistent **Demo mode** banner. It never reports
fake usage numbers and is never enabled silently.

### Point at a different backend

```sh
flutter run --dart-define=AI_BASE_URL=https://staging.example.test
```

The Supabase alternative uses
`--dart-define=AI_BASE_URL=https://<project-ref>.supabase.co/functions/v1`
with `--dart-define=AI_ASSISTANT_PATH=/assistant`.

See [`backend/README.md`](backend/README.md) to stand the proxy up and
[`docs/ai/provider-integration.md`](docs/ai/provider-integration.md) for the
configuration and verification checklist.

## Configuration (`--dart-define`)

No value here is a secret; all of them end up inside the binary.

| Define | Meaning | Default |
| --- | --- | --- |
| `AI_BASE_URL` | Operator's AI proxy base URL. | `https://api.chanpenh.store` |
| `AI_ASSISTANT_PATH` | Path appended to the base URL. | `/v1/assistant` |
| `AI_REQUEST_TIMEOUT_SECONDS` | Per-request timeout. | `45` |
| `AI_MAX_INPUT_CHARS` | Local input cap. | `6000` |
| `AI_USE_MOCK` | Use the sample data source. Dev/demo only. | `false` |
| `AI_ENABLE_STREAMING` | Ask the backend for a streamed reply. | `true` |

Definitions are compile-time: after changing one, stop and re-run — a hot reload
keeps the old build.

## Quality checks

```sh
dart format lib test
flutter analyze
flutter test
```

The transport half of one real end-to-end turn — the app's own Dio client,
`RemoteAiDataSource`, SSE parser and response DTOs against a running backend.
Needs the network and spends provider credits, so it is skipped unless an
endpoint is passed in:

```sh
flutter test test/live --dart-define=LIVE_AI_BASE_URL=https://api.chanpenh.store
```

Model evaluation (costs money, hits a real provider — not for CI):

```sh
# against a hosted OpenAI-compatible provider
node eval/run_eval.mjs --base-url "$BASE" --api-key "$KEY" \
  --model "$MODEL" --label sea-lion --concurrency 1 --limit 5

# against the deployed proxy (no provider key)
node eval/run_eval.mjs --mode proxy \
  --base-url https://api.chanpenh.store --label workers-ai
```

Backend checks:

```sh
cd backend/shared
deno check ../supabase/functions/assistant/index.ts
deno test --allow-env --allow-net
```

Deploy the proxy:

```sh
cd backend/cloudflare && npx wrangler deploy
```

## Architecture

```
lib/
  app/            routing, theme, localization
  core/           config, errors, network, storage, widgets
  features/
    ai/           domain contracts, data sources (remote + mock), providers
    chat/         chat UI + controllers
    translation/ writing/ summarization/ english/
    settings/
```

* Presentation depends on domain, never on concrete data implementations.
* Domain and presentation contain no vendor types, model names or HTTP.
* Failures are typed (`AppFailure`) and mapped to localized messages.
* Providers are injected with Riverpod and overridden in tests.

## Khmer UX

Khmer is the primary language; English is secondary. All UI strings live in
ARB files under `lib/app/localization/arb/`. The app bundles Noto Sans Khmer
(see `assets/fonts/`). The assistant answers in natural Khmer when the user
writes Khmer.

## Privacy

Conversations may be sensitive. Local history can be deleted from Settings.
Text sent to a model goes through the operator's backend, not directly from the
device. Do not put provider keys or the Supabase secret key in the app.

## Documentation

* [`docs/ai/model-evaluation.md`](docs/ai/model-evaluation.md) — model choice, licenses, cost
* [`docs/ai/provider-integration.md`](docs/ai/provider-integration.md) — how to wire a provider
* [`backend/README.md`](backend/README.md) — proxy contract and deployment
* [`eval/README.md`](eval/README.md) — Khmer evaluation harness
