# AI model evaluation — Khmer AI Assistant

Status: **licenses and options verified; a hosted model is live behind the
proxy, but the final model choice still awaits a full Khmer evaluation run.**
Last updated: 2026-10-17.

This document verifies the candidate models, their licenses and commercial-use
terms, and describes the evaluation that decides which model is used. A hosted
model is deployed at `api.chanpenh.store` and has been scored on all 36 Khmer
items (see §6); the missing piece is the same run against a Qwen baseline, plus
one end-to-end turn from the app. Until then, treat the current model as a
working default, not a final choice.

Everything below was checked against the official model cards and license
texts on the date above. Model repositories, pricing and hosted availability
change often — re-verify before integrating (see "Open items").

---

## 1. What we are choosing between

| Role | Candidate | Base | Params | Context | License | Verified |
| --- | --- | --- | --- | --- | --- | --- |
| General chat (SEA) | `aisingapore/Llama-SEA-LION-v3-8B-IT` | Llama 3.1 8B | 8B | 128k | Llama 3.1 Community License | model card |
| General chat (SEA) | `aisingapore/Gemma-SEA-LION-v3-9B-IT` | Gemma 2 9B | 9B | 8k | Gemma Community License | model card |
| General chat (Khmer) | `aisingapore/SEA-LION-v1-7B-IT` | from scratch | 7B | 2k | MIT | model card |
| General chat (baseline) | `Qwen/Qwen2.5-7B-Instruct` | — | 7B | 128k | Apache-2.0 | license file |
| General chat (baseline) | `Qwen/Qwen3-8B` | — | 8B | 32k (128k w/ YaRN) | Apache-2.0 | license file |
| Khmer fine-tune | `sengtha/Qwen3-0.6B-khm-ft3` | Qwen3 0.6B | 0.6B | — | Apache-2.0 | model card |
| Khmer fine-tune | `kimleang123/fine-tuned-KQA-qwen2-7B-QLoRA` | Qwen2 7B | 7B | — | **unstated / gated** | model card |
| Khmer fine-tune | `CADT-IDRI/qwen-khmer-text-sum-adapters` | Qwen2.5 7B | 7B (LoRA) | 8k | Apache-2.0 (inherit) | model card |
| Translation | `xiaomi-research/GemmaX2-28-9B-v0.2` | Gemma 2 9B | 9B | 8k | Gemma Terms | model card + LICENSE |
| Translation | `xiaomi-research/GemmaX2-28-2B-v0.2` | Gemma 2 2B | 2B | 8k | Gemma Terms | model card |
| Translation | `xiaomi-research/MiLMMT-46-4B-v1.0` / `-12B-v1.0` | Gemma 3 4B/12B | 4B/12B | 8k | Gemma Terms | model card |

### Why these and not others

* **SEA-LION v2 8B** is Llama 3 based and supports only English, Indonesian,
  Thai, Vietnamese and Tamil — **no Khmer**. Excluded.
* **Apertus-SEA-LION-v4-8B-IT** is MIT but lists Indonesian, Vietnamese, Thai,
  Filipino, Tamil, Burmese and Malay — **no Khmer**. Excluded for now.
* Vision/ASR Khmer models (e.g. Qwen3-ASR) are out of scope for this MVP.

---

## 2. Critical finding: instruction tuning vs. Khmer

SEA-LION v3 gives the model Khmer coverage through **continued pre-training**,
not necessarily through instruction tuning:

* `Llama-SEA-LION-v3-8B-IT` — instruction tuning was done on English plus
  **Indonesian, Javanese, Sundanese, Tamil, Thai and Vietnamese**. Khmer is in
  the supported-language list but was **not** in the instruction mix.
* `Gemma-SEA-LION-v3-9B-IT` — instruction tuning on English plus
  **Indonesian, Thai and Vietnamese**. Khmer again supported but not
  instruction-tuned.

Consequence: these models may *understand* Khmer well while *answering*
inconsistently — code-switching to English, mixing scripts, or producing
stilted Khmer. This is exactly the gap the Khmer evaluation set is designed to
measure, and it is why the final decision is made on measured Khmer output, not
on SEA-HELM or English benchmark scores.

The SEA-LION v1-7B-IT (MIT) has Khmer in its instruction data but is older and
weaker overall. SEA-LION's newer hosted API additionally exposes
`Qwen-SEA-LION-v4.5-27B-IT`, which is worth adding to the evaluation as a
stronger SEA option.

---

## 3. License and commercial-use verification

Summary of what the license texts actually say. This is a plain-language
reading, not legal advice.

### Llama 3.1 Community License — `Llama-SEA-LION-v3-8B-IT`
* Commercial use: **allowed** below the scale gate.
* Scale gate: if the product has **> 700 million MAU** you must request a
  separate license from Meta. Irrelevant at MVP scale.
* Attribution: must provide a copy of the agreement and **prominently display
  "Built with Llama"** on the product website / UI / docs.
* Derivatives: if you fine-tune, any distributed derivative model name must
  **start with "Llama"**.
* Must retain the Notice file with the Meta copyright line.
* Must comply with the Llama 3.1 Acceptable Use Policy.

### Gemma Community License / Gemma Terms — `Gemma-SEA-LION-v3-9B-IT`, `GemmaX2-28-*`, `MiLMMT-46-*`
* Commercial use: **allowed** subject to the Gemma Prohibited Use Policy.
* Redistribution: must pass the Gemma terms to recipients and keep the
  attribution notices (GemmaX2 files carry `Copyright (C) 2024 Xiaomi
  Corporation. Licensed under the Gemma terms`).
* Google reserves the right to restrict use; there is a usage-restriction
  policy you must follow.

### Apache-2.0 — Qwen base models, `sengtha/Qwen3-0.6B-khm-ft3`, CADT adapters
* Commercial use: **allowed**, with attribution and no endorsement claims.
* Qwen states all its open-weight models are Apache-2.0. Note the 3B and 72B
  Qwen2.5 sizes are the exception in that family; 7B/8B are Apache-2.0.

### MIT — `SEA-LION-v1-7B-IT`
* Permissive; commercial use allowed.

### Unstated / gated — `kimleang123/*` Khmer fine-tunes
* The model card declares `License: [More Information Needed]` and the
  repository is **gated** (terms must be accepted).
* Research provenance is solid (ViLa Lab, ITC, peer-reviewed), but an
  **unstated license is a commercial blocker**. Do not ship these without
  written permission from the authors.

**Licensing conclusion:** every SEA-LION/Qwen candidate is commercially
usable. The Llama-based one carries attribution and naming duties; the
Gemma-based ones carry Gemma policy duties; the community Khmer fine-tunes are
mostly research artefacts of unclear or thin licensing and should be treated as
reference points for evaluation, not as shipping options, until clarified.

---

## 4. Inference requirements and cost

### Self-hosting (explicitly deferred, see §7)

Rough FP16/BF16 footprints for full-precision serving:

| Size | Weights | Practical serving |
| --- | --- | --- |
| 2–4B | ~4–9 GB | 1× 16–24 GB GPU (A10G/L4/4090) |
| 7–9B | ~14–18 GB | 1× 24 GB GPU (A10G/4090/L4 quantized) |
| 12B | ~24 GB | 1× 40–48 GB GPU or 2× 24 GB |
| 27B | ~54 GB | 2× 40–48 GB GPU |

### Hosted inference (the MVP route)

Verified hosted options for the candidates:

* **SEA-LION API** — `https://api.sea-lion.ai/v1`, OpenAI-compatible, API key
  from the SEA-LION Playground. Free trial keys are rate limited to **10
  requests/minute**. Serves SEA-LION family models (e.g.
  `aisingapore/Qwen-SEA-LION-v4.5-27B-IT`, `aisingapore/Llama-SEA-LION-v3.5-70B-R`)
  and a `SEA-Guard` safety model. Use for evaluation and early MVP; move to a
  paid endpoint for production volume.
* **Cloudflare Workers AI** — hosts `@cf/aisingapore/gemma-sea-lion-v4-27b-it`,
  listed at **$0.351 / M input tokens and $0.555 / M output tokens**,
  128k context. **Currently deployed** behind the proxy (`api.chanpenh.store`,
  Workers AI binding, no provider key). The reply rate is per the account's
  Workers AI allowance.
* **Amazon Bedrock Custom Model Import** — supports importing
  `Llama-SEA-LION-v3-8B-IT` (Llama architecture only). Billed per model copy
  per minute plus storage; suits predictable sustained traffic, not spiky MVP.
* **Together AI** — serverless catalogue includes `Qwen2.5 7B Instruct Turbo`
  at **$0.30 / M input and $0.30 / M output**, and `Qwen3 8B`. Generic Qwen
  baselines are therefore cheap and easy to A/B against SEA-LION.
* **GemmaX2 / MiLMMT** — no general serverless listing found. Expect to use
  Hugging Face Inference Endpoints, a dedicated GPU, or self-hosting. This is
  the main cost driver if a specialised translator is adopted.

### Cost model for the MVP

Assume ~800 input tokens and ~400 output tokens per chat turn (Khmer costs a
little more because the script tokenises less efficiently than Latin text).

| Endpoint | Input $/M | Output $/M | Cost per 1k turns (approx.) |
| --- | --- | --- | --- |
| Qwen2.5-7B (Together) | 0.30 | 0.30 | ~$0.36 |
| gemma-sea-lion-v4-27b (Cloudflare) | 0.351 | 0.555 | ~$0.50 |
| SEA-LION API free tier | 0 | 0 | $0, capped at 10 RPM |

Self-hosting a 7–9B model on a dedicated A10G/L4 class GPU costs roughly
$0.40–$1.20 per GPU-hour depending on provider; that only beats hosted pricing
above roughly tens of thousands of turns per month and adds deployment and
maintenance cost. **The MVP should use a hosted endpoint.**

These are list prices at the evaluation date and must be re-checked at billing
time.

---

## 5. Comparison dimensions

Decided weighting for the MVP (a consumer Khmer assistant):

| Dimension | Weight | Why |
| --- | --- | --- |
| Natural Khmer conversation | 25% | The product's core promise |
| Khmer spelling & grammar | 15% | Visible quality signal to users |
| English → Khmer translation | 15% | High-frequency user task |
| Khmer → English translation | 10% | Needed for forms, study, work |
| Writing assistance | 15% | Emails, posts, job applications |
| Latency | 10% | Older phones, mobile networks |
| Inference cost | 10% | Keeps the free tier viable |

The evaluation set in `eval/khmer_eval_dataset.jsonl` maps 1:1 onto these
dimensions. Reference-based metrics are only used for translation items;
generation and writing items are scored with a rubric (and optionally an LLM
judge). **No model is selected on English benchmarks.**

---

## 6. Recommendation

**Deployed default (not yet final):** `@cf/aisingapore/gemma-sea-lion-v4-27b-it`
on Cloudflare Workers AI, behind `api.chanpenh.store`. Chosen to unblock the
MVP because it needs no provider key, runs on Cloudflare next to the proxy, and
is a SEA-LION model with Khmer coverage. It is a *default to operate against
while evaluating*, not the evaluated winner.

**Full evaluation run (2026-10-17).** All 36 dataset items, against the live
deployment via `--mode proxy`, `--concurrency 2`. Automatic checks only (no LLM
judge was configured):

| Dimension | n | Lang ok | Non-empty | Not echo | Ref-sim | Avg latency ms |
| --- | --- | --- | --- | --- | --- | --- |
| Natural Khmer conversation | 11 | 82% | 100% | 100% | — | 5054 |
| Khmer spelling & grammar | 5 | 80% | 100% | 100% | — | 1438 |
| English → Khmer translation | 6 | 100% | 100% | 100% | 0.76 | 791 |
| Khmer → English translation | 5 | 100% | 100% | 100% | 0.89 | 628 |
| Writing assistance | 9 | 56% | 100% | 100% | — | 3809 |

Interpretation (read the raw Khmer, not just the scores):

* **Translation is strong.** en→km and km→en pass every automatic check with
  high reference similarity; en→km output read as natural Khmer (the first
  reference item matched exactly). This is the clearest win.
* **The main defect is script-mixing, not wrong Khmer.** Every "lang ok"
  failure is a Khmer answer that appends **Latin transliteration and/or an
  English gloss**, e.g. a thank-you note ending with
  `(Arkun dael haey ban chouy nak! …)` plus `(Translation: …)`. The Khmer itself
  is fluent. This hits `writing_assistance` (56%) and 2 of 11 chat items hardest.
* **Over-asking.** Some chat replies open with a clarifying question and never
  commit to an answer, which reads as hedging rather than helpfulness.
* **Latency** is ~5 s for long chat/writing replies, <1 s for translation.

Both defects are addressable at the proxy (prompt hardening: "reply in Khmer
only, never add romanization or translations unless asked"; answer-first
instruction) without changing models — and worth fixing before the model
comparison, so the baseline is not unfairly penalised.

**Still owed:** the same run against a Qwen baseline through its own
OpenAI-compatible endpoint, with both summaries recorded here. The deployed
model remains a working default until that comparison lands.

Recommended direction once it does:

1. **Default chat / general model for the MVP:** the SEA-LION family. Either
   the Cloudflare-hosted `gemma-sea-lion-v4-27b-it` (already deployed, no key)
   or the hosted SEA-LION API serving `Qwen-SEA-LION-v4.5-27B-IT` /
   `Llama-SEA-LION-v3-8B-IT`. SEA-LION is the only family here trained
   specifically for Southeast Asia including Khmer. The Cloudflare route keeps
   the MVP free of both GPU operations and key management.
2. **Baseline to beat:** `Qwen3-8B` / `Qwen2.5-7B-Instruct` (Apache-2.0), cheap
   and widely hosted. If a general Qwen matches SEA-LION on the Khmer set, its
   license and hosting options are simpler.
3. **Translation:** start on the chosen chat model. Adopt
   **`GemmaX2-28-9B-v0.2` (or the newer `MiLMMT-46-12B-v1.0`)** as a dedicated
   translation model only if the evaluation shows a clear quality gap — it
   then runs as a separate, server-side profile behind the same endpoint, and
   its hosting cost must be justified separately.
4. **Khmer community fine-tunes:** use as evaluation reference only. Not
   shipping candidates until licensing is resolved.

The final pick is the model that wins the Khmer set on the weighted score, at
acceptable latency and cost — not the one with the best English leaderboard.

---

## 7. Why we are not self-hosting yet

Choosing to run weights ourselves requires all of: a GPU host, autoscaling,
model update and safety-patch process, prompt/version management, monitoring,
and someone on call when inference degrades. None of that is in the MVP's
critical path. If sustained volume later justifies it, the decision gate is:

* monthly hosted spend exceeds the equivalent dedicated-GPU run-rate, **and**
* the team can own GPU operations, **and**
* a licence review confirms redistribution/serving terms for the chosen model.

Until then the client only knows an endpoint URL — so switching from hosted to
self-hosted changes nothing in the Flutter app.

---

## 8. Open items to re-verify before integration

* [ ] Confirm current **availability and price** of the chosen model on the
      chosen host (list prices above are point-in-time).
* [ ] Confirm the **hosted SEA-LION API** terms of service, data-retention
      policy, and free-tier rate limits for production use.
* [ ] Confirm the **Workers AI** data-handling and retention terms for the
      deployed default, and the account's daily allowance.
* [ ] Re-read the **Gemma terms** if GemmaX2/MiLMMT is adopted, including the
      prohibited-use policy and redistribution duties.
* [ ] Add the **"Built with Llama"** attribution if a Llama-based model ships.
* [ ] Resolve the **license** of any `kimleang123` checkpoint before any use
      beyond internal benchmarking.
* [ ] Record **exact model revisions** (HF commit hashes) used in the winning
      evaluation run.
* [x] Complete **one live request** end-to-end through the proxy and record it
      (`provider-integration.md` §5 and §6 above).
* [ ] Run the **full 36-item evaluation** against a Qwen baseline and record
      both summaries in §6. (The deployed model's own run is recorded; the
      baseline comparison is what is outstanding.)
* [ ] Harden the **prompt** against script-mixing (no romanization/gloss) and
      re-run, before the comparison decides a winner.
* [ ] Confirm **one end-to-end turn from the Flutter app** on a device
      (`AI_BASE_URL=https://api.chanpenh.store`).

---

## 9. Sources

* SEA-LION model docs and cards: `docs.sea-lion.ai`, `huggingface.co/aisingapore/*`
* SEA-LION API guide: `docs.sea-lion.ai/guides/inferencing/api`
* Cloudflare Workers AI model page: `@cf/aisingapore/gemma-sea-lion-v4-27b-it`
* Amazon Bedrock Custom Model Import guide (SEA-LION blog)
* GemmaX2 / MiLMMT: `huggingface.co/xiaomi-research/*`, `github.com/xiaomi-research/gemmax`
* GemmaX2 paper (NAACL 2025) and MiLMMT papers
* Qwen licenses: `huggingface.co/Qwen/Qwen2.5-7B-Instruct`, `Qwen/Qwen3-8B`
* Llama 3.1 Community License: `dev.meta.ai/llama/llama3_1/license`
* Khmer fine-tunes: `huggingface.co/sengtha/*`, `huggingface.co/kimleang123/*`,
  `huggingface.co/CADT-IDRI/*`
* Together AI serverless pricing: `together.ai/pricing`
