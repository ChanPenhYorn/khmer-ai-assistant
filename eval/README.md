# Khmer evaluation harness

Decides which model answers Khmer users best, on the product's real
dimensions — not on English leaderboards.

* `khmer_eval_dataset.jsonl` — the dataset (one JSON object per line).
* `run_eval.mjs` — runs it against an OpenAI-compatible chat endpoint, or
  against the deployed proxy's task contract. Records latency, tokens and
  automatic checks, and writes a summary.
* `results/` — output (git-ignored).

Two modes:

* `--mode openai` (default) — speak OpenAI `/chat/completions` directly to a
  provider you hold a key for.
* `--mode proxy` — speak the backend's task contract to a deployed proxy
  (`{task, locale, input|messages, params}` → `{text, model, usage}`). Use this
  to score the live Cloudflare Worker without any provider key.

## Dataset

36 realistic items across five dimensions:

| Dimension | Items | What it measures |
| --- | --- | --- |
| `natural_khmer_conversation` | 11 | Natural Khmer answers to everyday Cambodian prompts (incl. mixed Khmer-English) |
| `khmer_spelling_grammar` | 5 | Khmer spelling, word spacing, tone, summarising a Khmer notice |
| `en_to_km_translation` | 6 | English → Khmer (with reference translations) |
| `km_to_en_translation` | 5 | Khmer → English (with reference translations) |
| `writing_assistance` | 9 | Improve / professionalise / shorten / expand / draft, plus idiom explanation |

Each line:

```json
{
  "id": "translate_en_km_001",
  "dimension": "en_to_km_translation",
  "task": "translate",
  "locale": "km",
  "params": { "source": "en", "target": "km" },
  "input": "Please submit your documents before Friday.",
  "reference": "សូមដាក់ឯកសាររបស់អ្នកមុនថ្ងៃសុក្រ។",
  "notes": "Everyday instruction."
}
```

`reference` is present for translation items only; it feeds an approximate
character-similarity score. No reference is used to score open-ended chat or
writing, which are judged by rubric instead.

## Running

Against a hosted OpenAI-compatible provider:

```sh
node eval/run_eval.mjs \
  --base-url https://api.sea-lion.ai/v1 \
  --api-key "$SEA_LION_API_KEY" \
  --model aisingapore/Qwen-SEA-LION-v4.5-27B-IT \
  --label sea-lion-27b
```

Against the deployed proxy (no provider key):

```sh
node eval/run_eval.mjs \
  --mode proxy \
  --base-url https://api.chanpenh.store \
  --label workers-ai-gemma-sea-lion-v4-27b
```

Options:

| Flag | Meaning | Default |
| --- | --- | --- |
| `--mode` | `openai` or `proxy`. | `openai` |
| `--base-url` | Provider base (no trailing slash), or proxy origin in proxy mode. Env: `EVAL_BASE_URL`. | required |
| `--path` | Path appended in proxy mode. | empty |
| `--api-key` | Provider key, or proxy auth token. Env: `EVAL_API_KEY`. | — |
| `--model` | Model id. Env: `EVAL_MODEL`. | required in `openai` mode |
| `--label` | Name used in the output filenames. | `run` |
| `--dataset` | Path to a JSONL dataset. | bundled file |
| `--limit` | Only the first N items (use for a smoke test). | all |
| `--concurrency` | Parallel requests. Respect the provider's rate limit. | `2` |
| `--timeout-ms` | Per-request timeout. | `60000` |
| `--temperature` | Sampling temperature. | `0.3` |
| `--out` | Output directory. | `eval/results` |
| `--price-in` / `--price-out` | USD per 1M tokens, for the cost estimate. | `0` |
| `--judge-base-url` / `--judge-model` / `--judge-api-key` | Optional LLM judge. | off |

The free SEA-LION API allows ~10 requests/minute; use `--concurrency 1` and a
small `--limit` there.

A smoke test against 3 items:

```sh
node eval/run_eval.mjs --base-url "$BASE" --api-key "$KEY" \
  --model "$MODEL" --limit 3 --label smoke --concurrency 1
```

## Reading the output

`results/<stamp>_<label>.jsonl` — every request/response with checks.
`results/<stamp>_<label>.summary.md` — a per-dimension table.

Automatic checks per item:

* **Lang ok** — Khmer output has ≥60% Khmer-script letters (or ≤20% for
  English/latin outputs).
* **Non-empty**, **Not echo** — guards against empty or copy-the-input replies.
* **Ref-sim** — character similarity to the `reference`, translation items only.
* **Avg latency ms**, **Est. cost USD**.

Neither the automatic checks nor the judge decide alone. **Read the raw Khmer
in the JSONL before choosing a model** — a 95% "lang ok" score with stiff or
wrong Khmer is still a bad product.

## Recording a decision

After running at least SEA-LION and a Qwen baseline:

1. Note the exact HF/endpoint model revisions tested.
2. Copy the summaries into `docs/ai/model-evaluation.md` §6 and pick a winner
   per the weighted dimensions in §5.
3. Note any model that failed (timeouts, refusals, wrong script).

## Notes

* Costs real money and hits a real provider. Do not run in CI.
* The prompt builder mirrors `backend/shared/providers.ts`. If that changes,
  update both. In `--mode proxy` the server builds the prompt, so the mirror is
  not used.
* No key is printed. Keep keys in the environment, never in a committed file.
