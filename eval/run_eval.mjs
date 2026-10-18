#!/usr/bin/env node
/**
 * Khmer evaluation harness for the Khmer AI Assistant.
 *
 * Runs the dataset in `khmer_eval_dataset.jsonl` against an OpenAI-compatible
 * chat endpoint and writes, per item, the reply, its latency, token usage and
 * a set of automatic quality checks. Optionally, a second model ("judge")
 * scores each reply against a rubric.
 *
 * It never prints or stores the API key. It makes real requests and may cost
 * money — run it against a small slice first with `--limit`.
 *
 * Usage:
 *   node eval/run_eval.mjs \
 *     --base-url https://api.sea-lion.ai/v1 \
 *     --api-key "$SEA_LION_API_KEY" \
 *     --model aisingapore/Qwen-SEA-LION-v4.5-27B-IT \
 *     --label sea-lion-27b
 *
 * See eval/README.md for all options.
 */

import { readFile, mkdir, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const KHMER = /[\u1780-\u17FF]/;
const KHMER_GLOBAL = /[\u1780-\u17FF]/g;
const LATIN_LETTER = /[A-Za-z]/;
const LATIN_GLOBAL = /[A-Za-z]/g;

// ---------------------------------------------------------------------------
// Arguments
// ---------------------------------------------------------------------------

function parseArgs(argv) {
  const args = { concurrency: 2, limit: 0, timeoutMs: 60000, temperature: 0.3 };
  for (let i = 0; i < argv.length; i++) {
    const token = argv[i];
    if (!token.startsWith("--")) continue;
    const key = token.slice(2);
    const value = argv[i + 1] && !argv[i + 1].startsWith("--") ? argv[++i] : "true";
    if (key in args && typeof args[key] === "number") args[key] = Number(value);
    else args[key] = value;
  }
  return args;
}

const args = parseArgs(process.argv.slice(2));

const baseUrl = (args["base-url"] ?? process.env.EVAL_BASE_URL ?? "").replace(/\/+$/, "");
const apiKey = args["api-key"] ?? process.env.EVAL_API_KEY ?? "";
const model = args.model ?? process.env.EVAL_MODEL ?? "";
const datasetPath = args.dataset ?? join(HERE, "khmer_eval_dataset.jsonl");
const label = args.label ?? "run";
const mode = args.mode ?? "openai";
const proxyPath = args.path ?? "";
const judgeBaseUrl = args["judge-base-url"];
const judgeApiKey = args["judge-api-key"] ?? apiKey;
const judgeModel = args["judge-model"];

if (!baseUrl || (mode === "openai" && !model)) {
  console.error(
    "Missing --base-url" +
      (mode === "openai" ? " or --model" : "") +
      ". See the header of this file or eval/README.md.",
  );
  process.exit(2);
}

// ---------------------------------------------------------------------------
// Prompt building (mirrors backend/.../providers.ts — keep in sync)
// ---------------------------------------------------------------------------

function buildSystemPrompt(item) {
  const replyInKhmer = item.locale === "km";
  const languageRule = replyInKhmer
    ? "Reply in natural, everyday Khmer (ខ្មែរ) unless the user explicitly asks for another language."
    : "Reply in the language the user writes in.";
  const base = [
    "You are a helpful assistant for people in Cambodia.",
    languageRule,
    "Use correct Khmer spelling and grammar. Prefer clear, plain wording over formal or machine-translated phrasing.",
    "Understand Cambodian context where relevant.",
    "Never invent facts, names, numbers or sources. If unsure, say so.",
  ];
  const taskRules = {
    chat: [],
    translate: ["Output only the translation, nothing else."],
    improve_writing: ["Return only the resulting text."],
    summarize: ["Summarize only what is present in the text."],
    explain_english: ["Explain in simple Khmer for a learner."],
  };
  return [...base, ...(taskRules[item.task] ?? [])].join(" ");
}

function buildUserMessage(item) {
  const params = item.params ?? {};
  switch (item.task) {
    case "chat":
      return item.input;
    case "translate":
      return `Translate from ${params.source ?? "auto"} to ${params.target ?? "km"}.\n` +
        `Text:\n${item.input}`;
    case "improve_writing": {
      const action = params.action ?? "improve";
      const topicBased = action === "draft_message" || action === "draft_job_application";
      return topicBased
        ? `Write in ${params.target_language ?? "km"}. Action: ${action}. Tone: ${params.tone ?? "neutral"}. Topic: ${item.input}`
        : `Write in ${params.target_language ?? "km"}. Action: ${action}. Tone: ${params.tone ?? "neutral"}.\nText:\n${item.input}`;
    }
    case "summarize":
      return `Summarize in ${params.target_language ?? "km"}. Style: ${params.style ?? "short"}.\nText:\n${item.input}`;
    case "explain_english":
      return `Explain this English text in ${params.target_language ?? "km"}:\n${item.input}`;
    default:
      return item.input;
  }
}

function wantsKhmerOutput(item) {
  const params = item.params ?? {};
  if (item.locale === "en") return false;
  if (params.target === "en" || params.target_language === "en") return false;
  return true;
}

// ---------------------------------------------------------------------------
// Calling the model
// ---------------------------------------------------------------------------

/**
 * Calls the task-level proxy contract (`{task, locale, input|messages, params}`
 * -> `{text, model, usage}`). Used with `--mode proxy` against a deployed
 * backend, so no provider key is needed.
 */
async function callProxy(item, { base, key, path, timeoutMs }) {
  const body = item.task === "chat"
    ? {
      task: "chat",
      locale: item.locale,
      messages: [{ role: "user", content: item.input }],
    }
    : {
      task: item.task,
      locale: item.locale,
      input: item.input,
      params: item.params ?? {},
    };

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  const started = performance.now();
  try {
    const response = await fetch(`${base}${path}`, {
      method: "POST",
      signal: controller.signal,
      headers: {
        "Content-Type": "application/json",
        ...(key ? { Authorization: `Bearer ${key}` } : {}),
      },
      body: JSON.stringify(body),
    });
    const latencyMs = performance.now() - started;
    const parsed = await response.json().catch(() => null);
    if (!response.ok) {
      const code = parsed?.error?.code ?? `HTTP ${response.status}`;
      return { error: code, latencyMs, usage: null };
    }
    if (typeof parsed?.text !== "string") {
      return { error: "no text in response", latencyMs, usage: null };
    }
    return {
      text: parsed.text,
      model: parsed.model ?? null,
      latencyMs,
      usage: parsed.usage ?? null,
    };
  } catch (error) {
    return {
      error: error?.name === "AbortError" ? "timeout" : String(error?.message ?? error),
      latencyMs: performance.now() - started,
      usage: null,
    };
  } finally {
    clearTimeout(timer);
  }
}

async function callModel(messages, { model: m, base, key, timeoutMs, temperature }) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  const started = performance.now();
  try {
    const response = await fetch(`${base}/chat/completions`, {
      method: "POST",
      signal: controller.signal,
      headers: {
        "Content-Type": "application/json",
        ...(key ? { Authorization: `Bearer ${key}` } : {}),
      },
      body: JSON.stringify({
        model: m,
        messages,
        temperature,
        max_tokens: 1024,
        stream: false,
      }),
    });
    const latencyMs = performance.now() - started;
    const body = await response.json().catch(() => null);
    if (!response.ok) {
      return { error: `HTTP ${response.status}`, latencyMs, usage: null };
    }
    const text = body?.choices?.[0]?.message?.content;
    if (typeof text !== "string") {
      return { error: "no text in response", latencyMs, usage: null };
    }
    return {
      text,
      latencyMs,
      usage: {
        input_tokens: body?.usage?.prompt_tokens ?? null,
        output_tokens: body?.usage?.completion_tokens ?? null,
      },
    };
  } catch (error) {
    return {
      error: error?.name === "AbortError" ? "timeout" : String(error?.message ?? error),
      latencyMs: performance.now() - started,
      usage: null,
    };
  } finally {
    clearTimeout(timer);
  }
}

// ---------------------------------------------------------------------------
// Automatic checks
// ---------------------------------------------------------------------------

function ratio(text, regex) {
  const matches = text.match(regex);
  return matches ? matches.length : 0;
}

function levenshtein(a, b) {
  if (a === b) return 0;
  if (a.length === 0) return b.length;
  if (b.length === 0) return a.length;
  let prev = Array.from({ length: b.length + 1 }, (_, i) => i);
  for (let i = 1; i <= a.length; i++) {
    const curr = [i];
    for (let j = 1; j <= b.length; j++) {
      const cost = a[i - 1] === b[j - 1] ? 0 : 1;
      curr[j] = Math.min(curr[j - 1] + 1, prev[j] + 1, prev[j - 1] + cost);
    }
    prev = curr;
  }
  return prev[b.length];
}

function similarity(a, b) {
  const max = Math.max(a.length, b.length);
  if (max === 0) return 1;
  return 1 - levenshtein(a, b) / max;
}

function normalize(text) {
  return text
    .toLowerCase()
    .replace(/\s+/g, " ")
    .replace(/[។៕,.:;!?"'()\-…]/g, "")
    .trim();
}

const REFUSAL = /(as an ai|i cannot|i can't|i am unable|មិនអាចជួយ|ខ្ញុំមិនអាច)/i;

function scoreReply(item, reply) {
  const text = reply.text ?? "";
  const khmerChars = ratio(text, KHMER_GLOBAL);
  const latinChars = ratio(text, LATIN_GLOBAL);
  const letters = khmerChars + latinChars;
  const khmerShare = letters === 0 ? 0 : khmerChars / letters;
  const expectedKhmer = wantsKhmerOutput(item);

  const checks = {
    nonEmpty: text.trim().length > 0,
    noRefusal: !REFUSAL.test(text),
    khmerShare,
    latinShare: letters === 0 ? 0 : latinChars / letters,
  };

  if (expectedKhmer) {
    checks.languageOk = khmerShare >= 0.6 && text.length >= 4;
  } else {
    checks.languageOk = letters === 0 ? true : khmerShare <= 0.2;
  }

  // Translation: did it actually transform the input, and how close is it to
  // the reference (when one is supplied)?
  if (item.task === "translate") {
    checks.notEcho = normalize(text) !== normalize(item.input);
    if (item.reference) {
      checks.referenceSimilarity = similarity(normalize(text), normalize(item.reference));
    }
  }

  // Chat answers should not simply restate the question back.
  if (item.task === "chat") {
    checks.notEcho = normalize(text) !== normalize(item.input);
  }

  return checks;
}

// ---------------------------------------------------------------------------
// Optional LLM judge
// ---------------------------------------------------------------------------

const RUBRIC = [
  "Rule exactly on the reply for the given task.",
  "Score 1-5 on: correctness, natural Khmer (or target language), and helpfulness.",
  "5 = fluent, accurate, genuinely useful. 1 = wrong, unnatural, or unusable.",
  "Return ONLY compact JSON: {\"score\": <1-5>, \"reason\": \"<short>\"}.",
].join(" ");

async function judgeReply(item, reply) {
  const prompt =
    `Task: ${item.task}\n` +
    `Target language: ${item.locale}\n` +
    `Notes: ${item.notes ?? "-"}\n\n` +
    `Prompt:\n${item.input}\n\n` +
    `Reply:\n${reply.text ?? ""}`;
  const result = await callModel(
    [
      { role: "system", content: RUBRIC },
      { role: "user", content: prompt },
    ],
    {
      model: judgeModel,
      base: judgeBaseUrl,
      key: judgeApiKey,
      timeoutMs: Number(args.timeoutMs),
      temperature: 0,
    },
  );
  if (result.error || !result.text) return { score: null, reason: result.error ?? "no judge text" };
  try {
    const match = result.text.match(/\{[\s\S]*\}/);
    const parsed = JSON.parse(match ? match[0] : result.text);
    return { score: Number(parsed.score) || null, reason: String(parsed.reason ?? "") };
  } catch {
    return { score: null, reason: "unparseable judge output" };
  }
}

// ---------------------------------------------------------------------------
// Driver
// ---------------------------------------------------------------------------

async function loadDataset() {
  const raw = await readFile(datasetPath, "utf8");
  const items = [];
  for (const line of raw.split("\n")) {
    const trimmed = line.trim();
    if (!trimmed) continue;
    try {
      items.push(JSON.parse(trimmed));
    } catch (error) {
      console.error(`Skipping malformed dataset line: ${error.message}`);
    }
  }
  return Number(args.limit) > 0 ? items.slice(0, Number(args.limit)) : items;
}

async function runItem(item) {
  let reply;
  if (mode === "proxy") {
    reply = await callProxy(item, {
      base: baseUrl,
      key: apiKey,
      path: proxyPath,
      timeoutMs: Number(args.timeoutMs),
    });
  } else {
    const messages = [
      { role: "system", content: buildSystemPrompt(item) },
      { role: "user", content: buildUserMessage(item) },
    ];
    reply = await callModel(messages, {
      model,
      base: baseUrl,
      key: apiKey,
      timeoutMs: Number(args.timeoutMs),
      temperature: Number(args.temperature),
    });
  }
  const record = {
    id: item.id,
    dimension: item.dimension,
    task: item.task,
    locale: item.locale,
    input: item.input,
    ...reply,
    checks: reply.error ? { nonEmpty: false } : scoreReply(item, reply),
  };
  if (judgeModel && !reply.error) {
    record.judge = await judgeReply(item, reply);
  }
  return record;
}

async function pool(items, size, worker) {
  const results = new Array(items.length);
  let cursor = 0;
  const runners = Array.from({ length: Math.max(1, size) }, async () => {
    while (cursor < items.length) {
      const index = cursor++;
      results[index] = await worker(items[index]);
      process.stdout.write(".");
    }
  });
  await Promise.all(runners);
  return results;
}

function summarize(records, labelName) {
  const byDimension = new Map();
  for (const record of records) {
    const bucket = byDimension.get(record.dimension) ?? [];
    bucket.push(record);
    byDimension.set(record.dimension, bucket);
  }

  const priceIn = Number(args["price-in"] ?? 0);
  const priceOut = Number(args["price-out"] ?? 0);

  const lines = [`# Khmer evaluation — ${labelName}`, ""];
  const resolvedModel = model || records.find((r) => r.model)?.model || "(reported per response)";
  lines.push(`Model: \`${resolvedModel}\``);
  lines.push(`Mode: ${mode}`);
  lines.push(`Base URL: \`${baseUrl}\``);
  lines.push(`Items: ${records.length}`);
  lines.push("");
  lines.push("| Dimension | n | Lang ok | Non-empty | Not echo | Ref-sim | Avg latency ms | Est. cost USD |");
  lines.push("| --- | --- | --- | --- | --- | --- | --- | --- |");

  let totalCost = 0;
  for (const [dimension, bucket] of byDimension) {
    const n = bucket.length;
    const pct = (pred) => Math.round((bucket.filter(pred).length / n) * 100) + "%";
    const refSims = bucket
      .map((r) => r.checks?.referenceSimilarity)
      .filter((v) => typeof v === "number");
    const refSim = refSims.length
      ? (refSims.reduce((a, b) => a + b, 0) / refSims.length).toFixed(2)
      : "-";
    const latencies = bucket.map((r) => r.latencyMs ?? 0);
    const avgLatency = Math.round(latencies.reduce((a, b) => a + b, 0) / n);
    const cost = bucket.reduce((sum, r) => {
      const input = r.usage?.input_tokens ?? 0;
      const output = r.usage?.output_tokens ?? 0;
      return sum + (input * priceIn + output * priceOut) / 1_000_000;
    }, 0);
    totalCost += cost;
    lines.push(
      `| ${dimension} | ${n} | ${pct((r) => r.checks?.languageOk)} | ` +
        `${pct((r) => r.checks?.nonEmpty)} | ${pct((r) => r.checks?.notEcho !== false)} | ` +
        `${refSim} | ${avgLatency} | ${cost.toFixed(4)} |`,
    );
  }

  const judgeScores = records
    .map((r) => r.judge?.score)
    .filter((v) => typeof v === "number" && v > 0);
  if (judgeScores.length) {
    const avg = (judgeScores.reduce((a, b) => a + b, 0) / judgeScores.length).toFixed(2);
    lines.push("", `LLM judge average: **${avg} / 5** over ${judgeScores.length} items.`);
  }

  lines.push("", `Estimated total cost: **$${totalCost.toFixed(4)}** (list prices supplied, approximate).`);
  lines.push("", "Automatic checks are signals, not verdicts. Read samples before deciding.");
  return lines.join("\n");
}

async function main() {
  const items = await loadDataset();
  if (items.length === 0) {
    console.error("Dataset is empty.");
    process.exit(2);
  }
  console.log(
    `Evaluating ${items.length} items [${mode}] -> ${baseUrl}` +
      (model ? ` / ${model}` : "") +
      (judgeModel ? ` (judge: ${judgeModel})` : ""),
  );

  const records = await pool(items, Number(args.concurrency), runItem);
  console.log("");

  const outDir = args.out ?? join(HERE, "results");
  await mkdir(outDir, { recursive: true });
  const stamp = new Date().toISOString().replace(/[:.]/g, "-");
  const slug = `${stamp}_${label}`.replace(/[^A-Za-z0-9_-]/g, "_");
  const jsonlPath = join(outDir, `${slug}.jsonl`);
  const mdPath = join(outDir, `${slug}.summary.md`);

  await writeFile(jsonlPath, records.map((r) => JSON.stringify(r)).join("\n") + "\n");
  const summary = summarize(records, label);
  await writeFile(mdPath, summary + "\n");

  console.log(summary);
  console.log(`\nWrote ${jsonlPath}\nWrote ${mdPath}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
