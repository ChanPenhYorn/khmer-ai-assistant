/**
 * Provider profiles and prompt construction for the Khmer AI Assistant proxy.
 *
 * This is the ONLY place that knows about models, vendors and prompt shape.
 * The Flutter client speaks task-level requests (`chat`, `translate`, …);
 * everything a model sees is built here.
 *
 * This module is runtime-neutral: it never calls a provider. Host adapters
 * (Supabase Edge Function, Cloudflare Worker) read the config, build messages
 * here, and invoke their own provider binding.
 *
 * Secret values come from the environment and are never logged.
 */

import { type EnvReader, readInt } from "./env.ts";

export type AiTask =
  | "chat"
  | "translate"
  | "improve_writing"
  | "summarize"
  | "explain_english";

export interface ChatMessage {
  role: "system" | "user" | "assistant";
  content: string;
}

/** Client -> proxy request body. Mirrors `AiRequestDto` in the Flutter app. */
export interface AssistantRequest {
  task: AiTask;
  locale: string;
  messages?: Array<{ role: "user" | "assistant"; content: string }>;
  input?: string;
  params?: Record<string, unknown>;
}

export interface ProviderProfile {
  baseUrl: string;
  apiKey: string;
  model: string;
  /** Present for transparency in logs/usage; optional. */
  name: string;
}

export interface ProxyConfig {
  chat: ProviderProfile | null;
  translation: ProviderProfile | null;
  maxInputChars: number;
  maxOutputTokens: number;
  requestTimeoutMs: number;
  allowedOrigins: string[];
  /** Force a specific model for the Workers AI binding. Empty = per task. */
  workersAi: boolean;
}

const DEFAULT_MAX_OUTPUT_TOKENS = 1024;

function readProfile(env: EnvReader, prefix: string): ProviderProfile | null {
  const baseUrl = env.get(`${prefix}_BASE_URL`)?.trim();
  const apiKey = env.get(`${prefix}_API_KEY`)?.trim() ?? "";
  const model = env.get(`${prefix}_MODEL`)?.trim() ?? "";
  if (!baseUrl || !model) return null;
  return {
    baseUrl: baseUrl.replace(/\/+$/, ""),
    apiKey,
    model,
    name: `${prefix.toLowerCase()}:${model}`,
  };
}

export function loadConfig(env: EnvReader): ProxyConfig {
  const chat = readProfile(env, "AI_CHAT");
  const translation = readProfile(env, "AI_TRANSLATION");
  return {
    chat,
    // A dedicated translation model is optional; fall back to the chat model.
    translation: translation ?? chat,
    maxInputChars: readInt(env, "AI_MAX_INPUT_CHARS", 6000),
    maxOutputTokens: readInt(env, "AI_MAX_OUTPUT_TOKENS", DEFAULT_MAX_OUTPUT_TOKENS),
    requestTimeoutMs: readInt(env, "AI_REQUEST_TIMEOUT_MS", 45000),
    allowedOrigins: (env.get("AI_ALLOWED_ORIGINS") ?? "")
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean),
    // When `AI_WORKERS_AI=true` (default on the Worker), the model id lives in
    // AI_CHAT_MODEL even without a base URL, and calls go through the binding.
    workersAi: (env.get("AI_WORKERS_AI") ?? "false").trim() === "true",
  };
}

/** Picks the upstream profile for a task. */
export function resolveProfile(
  config: ProxyConfig,
  task: AiTask,
): ProviderProfile | null {
  if (task === "translate") return config.translation ?? config.chat;
  return config.chat;
}

/**
 * Reads the Workers AI model id for a task. Unlike [resolveProfile] it does not
 * require a base URL, because the binding has no endpoint.
 */
export function resolveWorkersAiModel(
  env: EnvReader,
  task: AiTask,
): string | null {
  const prefix = task === "translate" && env.get("AI_TRANSLATION_MODEL")
    ? "AI_TRANSLATION"
    : "AI_CHAT";
  return env.get(`${prefix}_MODEL`)?.trim() || null;
}

const KHMER_LOCALE = "km";

/**
 * System instruction. Kept server-side so it can be tuned without an app
 * release. Instructs the model to answer in natural Khmer and never to
 * fabricate facts or claim access to live data.
 */
export function buildSystemPrompt(
  request: AssistantRequest,
  replyInKhmer: boolean,
): string {
  const languageRule = replyInKhmer
    ? "Reply in natural, everyday Khmer (ខ្មែរ) unless the user explicitly asks for another language."
    : "Reply in the language the user writes in. Answer in Khmer when the user writes Khmer.";

  const base = [
    "You are a helpful assistant for people in Cambodia.",
    languageRule,
    "Use correct Khmer spelling and grammar. Prefer clear, plain wording over formal or machine-translated phrasing.",
    "Understand Cambodian context (schools, jobs, travel, money, everyday tasks) where relevant.",
    "Never invent facts, names, numbers or sources. If you are unsure, say so.",
    "Do not claim to access private, live, or real-time information you do not have.",
    "Ask a short clarifying question when the request is ambiguous.",
  ];

  const taskRules: Record<AiTask, string[]> = {
    chat: [],
    translate: [
      "Translate the text the user provides. Preserve meaning and tone. Do not add explanations or extra content.",
      "Output only the translation.",
    ],
    improve_writing: [
      "Apply the requested writing action to the user's text. Keep the original meaning.",
      "Return only the resulting text unless asked for suggestions.",
    ],
    summarize: [
      "Summarize the user's text in the requested style. Do not add information that is not present.",
    ],
    explain_english: [
      "Explain the English text in simple Khmer so a learner can understand it. Give a short explanation and, if useful, example usage.",
    ],
  };

  return [...base, ...taskRules[request.task]].join(" ");
}

/**
 * Builds the model message list. Throws a coded [InputError] for malformed
 * client input; the caller maps it to an HTTP response.
 */
export function buildMessages(request: AssistantRequest): ChatMessage[] {
  const replyInKhmer = request.locale === KHMER_LOCALE;
  const system = buildSystemPrompt(request, replyInKhmer);
  const params = request.params ?? {};

  switch (request.task) {
    case "chat": {
      const turns = request.messages ?? [];
      if (turns.length === 0) {
        throw new InputError("invalid_request", "chat requires messages");
      }
      return [
        { role: "system", content: system },
        ...turns.map((m) => ({ role: m.role, content: m.content })),
      ];
    }
    case "translate": {
      const text = requireInput(request);
      const source = String(params.source ?? "auto");
      const target = String(params.target ?? "km");
      return [
        { role: "system", content: system },
        {
          role: "user",
          content: `Translate from ${source} to ${target}.\nText:\n${text}`,
        },
      ];
    }
    case "improve_writing": {
      const text = String(request.input ?? "").trim();
      const action = String(params.action ?? "improve");
      const tone = String(params.tone ?? "neutral");
      const targetLanguage = String(params.target_language ?? "km");
      const topicBased =
        action === "draft_message" || action === "draft_job_application";
      if (!topicBased && text.length === 0) {
        throw new InputError("invalid_request", "writing action requires input");
      }
      const instruction = topicBased
        ? `Write in ${targetLanguage}. Action: ${action}. Tone: ${tone}. Topic: ${text}`
        : `Write in ${targetLanguage}. Action: ${action}. Tone: ${tone}.\nText:\n${text}`;
      return [
        { role: "system", content: system },
        { role: "user", content: instruction },
      ];
    }
    case "summarize": {
      const text = requireInput(request);
      const style = String(params.style ?? "short");
      const targetLanguage = String(params.target_language ?? "km");
      return [
        { role: "system", content: system },
        {
          role: "user",
          content: `Summarize in ${targetLanguage}. Style: ${style}.\nText:\n${text}`,
        },
      ];
    }
    case "explain_english": {
      const text = requireInput(request);
      const targetLanguage = String(params.target_language ?? "km");
      return [
        { role: "system", content: system },
        {
          role: "user",
          content: `Explain this English text in ${targetLanguage}:\n${text}`,
        },
      ];
    }
  }
}

function requireInput(request: AssistantRequest): string {
  const text = (request.input ?? "").trim();
  if (!text) {
    throw new InputError("invalid_request", `${request.task} requires input`);
  }
  return text;
}

/** Typed error carrying a wire `code` the client understands. */
export class InputError extends Error {
  constructor(
    readonly code: string,
    message: string,
  ) {
    super(message);
    this.name = "InputError";
  }
}

/** Rough input size guard applied before any provider call. */
export function enforceInputLimit(
  request: AssistantRequest,
  maxChars: number,
): void {
  const size = request.task === "chat"
    ? (request.messages ?? []).reduce((n, m) => n + m.content.length, 0)
    : (request.input ?? "").length;
  if (size > maxChars) {
    throw new InputError(
      "input_too_large",
      `input is ${size} characters, limit is ${maxChars}`,
    );
  }
}

export const TASKS: ReadonlySet<string> = new Set<AiTask>([
  "chat",
  "translate",
  "improve_writing",
  "summarize",
  "explain_english",
]);

export const STATUS_BY_CODE: Readonly<Record<string, number>> = {
  invalid_request: 400,
  unauthorized: 401,
  input_too_large: 413,
  quota_exceeded: 429,
  rate_limited: 429,
  provider_error: 502,
  server_error: 500,
};

export interface Usage {
  input_tokens: number;
  output_tokens: number;
}
