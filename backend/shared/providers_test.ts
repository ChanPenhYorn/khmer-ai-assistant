import { assertEquals, assertThrows } from "jsr:@std/assert@1";
import {
  buildMessages,
  enforceInputLimit,
  InputError,
  type AssistantRequest,
} from "./providers.ts";
import { objectEnv } from "./env.ts";

Deno.test("buildMessages: chat keeps history and adds a system prompt", () => {
  const request: AssistantRequest = {
    task: "chat",
    locale: "km",
    messages: [
      { role: "user", content: "សួស្តី" },
      { role: "assistant", content: "ជំរាបសួរ" },
    ],
  };
  const messages = buildMessages(request);
  assertEquals(messages[0].role, "system");
  assertEquals(messages.length, 3);
  assertEquals(messages[2].content, "ជំរាបសួរ");
});

Deno.test("buildMessages: chat with no turns is rejected", () => {
  assertThrows(
    () => buildMessages({ task: "chat", locale: "km", messages: [] }),
    InputError,
  );
});

Deno.test("buildMessages: translation carries source and target", () => {
  const messages = buildMessages({
    task: "translate",
    locale: "km",
    input: "Good morning",
    params: { source: "en", target: "km" },
  });
  assertEquals(messages.length, 2);
  const last = messages[messages.length - 1].content;
  assertEquals(last.includes("en"), true);
  assertEquals(last.includes("km"), true);
  assertEquals(last.includes("Good morning"), true);
});

Deno.test("buildMessages: topic-based writing does not require input", () => {
  const messages = buildMessages({
    task: "improve_writing",
    locale: "km",
    params: { action: "draft_job_application", tone: "professional" },
  });
  assertEquals(messages.length, 2);
});

Deno.test("buildMessages: non-topic writing requires input", () => {
  assertThrows(
    () =>
      buildMessages({
        task: "improve_writing",
        locale: "km",
        params: { action: "fix_grammar" },
      }),
    InputError,
  );
});

Deno.test("enforceInputLimit: rejects oversized input with a coded error", () => {
  const error = assertThrows(
    () => enforceInputLimit({ task: "summarize", locale: "km", input: "x".repeat(50) }, 10),
    InputError,
  );
  assertEquals((error as InputError).code, "input_too_large");
});

Deno.test("enforceInputLimit: counts every chat message", () => {
  enforceInputLimit(
    {
      task: "chat",
      locale: "km",
      messages: [
        { role: "user", content: "12345" },
        { role: "user", content: "67890" },
      ],
    },
    10,
  );
});

Deno.test("objectEnv: reads only string bindings", () => {
  const env = objectEnv({ A: "value", B: 42, C: undefined });
  assertEquals(env.get("A"), "value");
  assertEquals(env.get("B"), undefined);
  assertEquals(env.get("C"), undefined);
  assertEquals(env.get("MISSING"), undefined);
});
