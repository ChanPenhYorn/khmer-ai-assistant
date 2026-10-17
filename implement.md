# Project: Khmer AI Assistant — Production-Ready Flutter MVP

## 1. Your Role

Act as a senior Flutter engineer, mobile architect, product designer, and pragmatic technical lead.

Build a polished, maintainable, production-oriented **Khmer AI Assistant** for users in Cambodia.

You are working inside my existing repository. First inspect the project structure, existing code, dependency versions, configuration, and established conventions. Follow the repository's rules and instructions, including `AGENTS.md`, `CLAUDE.md`, `.claude/rules.md`, or equivalent files if present.

Do not blindly replace existing code, configurations, or architecture.

If the repository is empty, establish the architecture described below.

**Execution rules:**
1. Inspect before editing.
2. Create an implementation plan with milestones and acceptance criteria.
3. Identify architectural decisions, required dependencies, and risks.
4. Implement incrementally, keeping the application buildable.
5. Run formatting, static analysis, and tests.
6. Fix problems introduced by your changes.
7. Report what was implemented, commands executed, test results, and remaining limitations.

Do not stop after producing a plan unless a blocking decision requires my input. Make sensible, reversible decisions independently.

## 2. Product Vision

Build a Khmer-first AI assistant that helps Cambodian users:

- Ask questions and receive natural Khmer answers.
- Translate between Khmer and English.
- Write and improve messages, emails, documents, and social posts.
- Improve grammar, spelling, and writing clarity.
- Explain difficult topics in simple Khmer.
- Summarize text and documents.
- Generate CV content and prepare for job interviews.
- Learn English through Khmer explanations.

The app should feel like a real local consumer product, not a generic chatbot with a translated interface.

Target users include students, employees, job seekers, small-business owners, and everyday smartphone users in Cambodia.

Prioritize useful daily workflows, fast interactions, clear Khmer typography, accessibility, and low operating costs.

## 3. Technology Stack

Use the following stack unless the existing project has a justified equivalent:

- Flutter stable and Dart with sound null safety.
- Riverpod using the repository's established version and code-generation conventions.
- `flutter_riverpod` and `riverpod_annotation` / `riverpod_generator` when compatible.
- `go_router` for navigation.
- `freezed` and `json_serializable` for immutable models and serialization, where appropriate.
- Dio for HTTP networking.
- `flutter_secure_storage` for sensitive client-side values that must be stored securely.
- SharedPreferences for non-sensitive preferences.
- A suitable local database only when conversation persistence or offline requirements justify it.
- Supabase for optional authentication, PostgreSQL storage, and Edge Functions when a backend is needed.
- Flutter localization using ARB files and generated localization classes.
- A consistent design system with reusable components and centralized theme configuration.

Do not add packages merely for fashion. Check compatibility, maintenance status, and whether Flutter already provides the functionality.

Do not upgrade unrelated dependencies or perform large refactors without justification.

## 4. Architecture: Clean Architecture + Feature-First

Organize the project by feature and architectural responsibility.

Suggested structure:

lib/
  app/
    app.dart
    router/
    theme/
    localization/
  core/
    config/
    constants/
    errors/
    network/
    result/
    utils/
    widgets/
  features/
    chat/
      data/
        datasources/
        dto/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        providers/
        screens/
        widgets/
    translation/
      data/
      domain/
      presentation/
    writing/
      data/
      domain/
      presentation/
    summarization/
      data/
      domain/
      presentation/
    history/
      data/
      domain/
      presentation/
    settings/
      presentation/

Adjust the structure as the project evolves. Avoid empty folders and unnecessary abstraction.

### Dependency rules

- Presentation depends on domain, not concrete data implementations.
- Domain contains entities, repository contracts, and use cases.
- Data implements repository contracts and maps external responses into domain entities.
- Widgets must not perform HTTP requests or contain business logic.
- Providers coordinate application state and dependencies; they must not become giant service classes.
- Use cases should represent meaningful business operations, not create a class for every trivial expression.
- Inject dependencies through Riverpod providers.
- Keep navigation, configuration, error handling, and networking centralized where appropriate.
- Avoid service locators, global mutable state, and direct dependencies on concrete AI vendors in domain code.
- Do not expose Dio responses or provider-specific API DTOs to presentation widgets.

Use immutable state and typed error handling. Keep code readable and avoid overengineering.

## 5. AI Provider Architecture

Implement an AI abstraction that allows changing AI providers without changing chat UI or domain logic.

Define a domain-level contract such as:

- `AiRepository`
- `SendMessage`
- `TranslateText`
- `ImproveWriting`
- `SummarizeText`

Create appropriate entities and typed results.

In the data layer, implement an AI data source that communicates with a configurable backend endpoint.

The backend should call the selected model provider. Keep vendor-specific request formats, model names, and response parsing in the data layer or backend.

Support configuration for:
- Base endpoint.
- Model/provider selection on the server.
- Request timeout.
- Maximum input size.
- Output token limit.
- Optional streaming.
- Usage limits.
- Retry policy for safe transient failures.

Do not hardcode a model name throughout the codebase.

Do not assume a free API exists or will remain free. Verify the provider's current documentation, pricing, supported languages, context limits, rate limits, and commercial-use terms before integrating it.

If provider selection is unresolved, define the abstraction and a configurable endpoint, implement a mock data source for development, and document how to connect a real provider.

### Critical security rules

- Never put a production AI API key or Supabase service-role key in Flutter source code, assets, environment files bundled into the app, or client-side configuration.
- A key embedded in a mobile application must be treated as extractable.
- Put vendor secrets in server-side environment variables or a secrets manager.
- Use server-side authentication, input validation, request limits, and per-user usage quotas when exposing a public AI endpoint.
- Apply request timeouts, bounded retries, and sensible maximum payload sizes.
- Do not log secrets, authentication tokens, private conversations, or sensitive user input.
- Never claim an API call succeeded if it failed.
- Never silently fall back to mock responses in production.

For local development, document the required environment variables and provide a safe example environment file containing placeholders only.

## 6. Core MVP Features

### A. Home screen

Create a welcoming, Khmer-first home screen with:

- Product branding: Khmer AI Assistant.
- A short welcome message in natural Khmer.
- A prominent ask-anything input.
- Quick-action cards for Chat, Translate, Writing Assistant, Summarize, and English Learning.
- Suggested prompts users can tap to begin.
- A clear indication of free usage or remaining quota when real quota data is available.
- Loading, error, empty, and offline states where applicable.

Keep the home screen focused. Do not overcrowd it with too many cards, banners, or promotional elements.

### B. AI chat

Implement:

- User and assistant message bubbles.
- A composer with multiline input.
- Send button and keyboard submission behavior.
- Sending, loading, failure, and retry states.
- Scroll behavior that respects the user's current position.
- Copy message action.
- Regenerate response when supported.
- Stop generation when streaming is implemented and supported.
- Markdown rendering for assistant responses, including headings, lists, links, and code blocks.
- Safe handling of long responses and code.
- Conversation creation and titles.
- Conversation history and deletion.
- A clear new-chat action.
- Empty-state suggestions.
- Friendly network error messages.

If streaming is supported by the selected provider, implement it cleanly without coupling the UI to vendor-specific streaming formats. Otherwise use normal request/response behavior.

Avoid duplicated messages, multiple concurrent submissions, and stale asynchronous updates after a screen is disposed.

### C. Khmer-English translation

Implement a focused translation screen with:

- Source and target language selection.
- Khmer and English as the primary options.
- Text input and translated output.
- Swap languages.
- Copy output.
- Clear input.
- Loading and retry states.
- Optional automatic language detection when reliably supported.

Preserve the meaning and tone of the original text. Do not promise perfect translation.

### D. Writing assistant

Provide preset actions:

- Improve writing.
- Fix grammar and spelling.
- Make it more professional.
- Make it friendly and natural.
- Shorten text.
- Expand text.
- Draft a message.
- Draft a job application email.

Allow the user to select a target language and tone where relevant.

Present generated text in an editable or copyable output area. Clearly distinguish generated content from text the user has not yet approved.

### E. Summarization

Implement a simple text summarization workflow:

- Paste or enter text.
- Select a summary style, such as short, detailed, or bullet points.
- Generate a summary.
- Copy the result.
- Validate input length and show helpful errors.

Do not implement expensive document upload and OCR workflows unless they are necessary for the initial MVP.

### F. Conversation history

Support:

- Listing previous conversations.
- Opening a conversation.
- Renaming where practical.
- Deleting with confirmation.
- Persisting messages locally or remotely according to the selected storage design.

If cloud synchronization is not ready, implement local persistence and keep the repository abstraction ready for a future backend. Clearly document the limitations.

Do not collect analytics or upload conversations without appropriate disclosure and consent.

### G. Settings

Include:

- Khmer and English interface language.
- Light and dark themes.
- AI usage information where available.
- Privacy information.
- App version.
- Clear local chat history.
- Optional account settings if authentication is implemented.

## 7. Localization and Khmer UX

Khmer is the primary language. English is the secondary language.

- Use proper Khmer Unicode strings.
- Use Flutter localization with ARB resources rather than scattered inline strings.
- Ensure Khmer text does not overflow, clip, or become unreadable.
- Use an appropriate Khmer font, such as Noto Sans Khmer, after checking licensing and font asset requirements.
- Support Android and iOS keyboard behavior for Khmer and English input.
- Handle text scaling, multiline labels, long words, and mixed Khmer-English content.
- Respect platform safe areas and accessibility settings.
- Avoid machine-translated or awkwardly formal Khmer copy.
- Never hardcode localized UI text in widgets.
- Use logical spacing and responsive constraints rather than fixed screen assumptions.

The AI should generally answer in natural Khmer when the user writes in Khmer, and in the user's chosen language when requested. Users must be able to ask questions in English or mixed Khmer-English.

Use a configurable system instruction on the backend to guide the model to:
- Understand Cambodian context where relevant.
- Prefer clear, natural Khmer.
- Avoid fabricating facts.
- Explain uncertainty.
- Ask for clarification when necessary.
- Avoid claiming access to private or live information it does not have.

## 8. UI/UX Design Direction

Design a modern, premium-feeling, friendly interface suitable for Cambodian users.

Visual direction:
- Clean, calm, minimal.
- A clear typography hierarchy.
- Comfortable spacing.
- Rounded cards and restrained shadows.
- High-contrast text.
- Subtle accent colors.
- Smooth but restrained animations.
- Consistent icons.
- Polished light and dark themes.

Avoid:
- Copying ChatGPT's exact visual design or branding.
- Excessive gradients and glowing effects.
- Too many colorful cards.
- Oversized empty areas.
- Tiny Khmer text.
- Hardcoded heights that clip dynamic content.
- Decorative animations that slow down older phones.
- Fake functionality, fake usage statistics, and nonfunctional buttons.

Build reusable components such as:
- `AppButton`
- `AppTextField`
- `AppLoadingIndicator`
- `AppErrorView`
- `EmptyStateView`
- `ChatMessageBubble`
- `ChatComposer`
- `FeatureCard`
- `CopyAction`
- `LanguageSelector`

Use semantic widgets and accessible labels. Ensure buttons have meaningful tap targets and that keyboard focus and screen resizing work properly.

## 9. State Management

Use Riverpod consistently.

- Use `ConsumerWidget` or `ConsumerStatefulWidget` where appropriate.
- Use generated providers only when compatible with the existing setup.
- Keep network and business state out of widget-local state unless it is purely presentational.
- Use `AsyncValue` or an equivalent typed state representation.
- Handle loading, success, empty, and error states.
- Dispose of controllers and subscriptions appropriately.
- Prevent duplicate requests.
- Keep dependencies testable and overrideable.
- Use family providers or equivalent parameterized dependencies where appropriate.
- Avoid excessive provider dependencies and unnecessary rebuilds.

For chat, design state transitions explicitly, including message submission, streaming if supported, failure, retry, and cancellation.

## 10. Error Handling and Reliability

Create a consistent error model for:
- Network unavailable.
- Request timeout.
- Unauthorized requests.
- Rate limits.
- AI provider errors.
- Invalid responses.
- Input too large.
- Usage quota exceeded.
- Unexpected server errors.

Translate technical failures into user-friendly localized messages.

Do not expose raw stack traces or internal backend errors to end users.

Use bounded retries only when safe. Avoid retrying a potentially completed AI generation blindly, as this can result in duplicate charges.

Handle empty responses and malformed payloads safely.

## 11. Privacy and Data Protection

Treat conversations as potentially sensitive.

- Request only the permissions needed.
- Do not require an account unless the feature needs it.
- Make data retention behavior explicit.
- Provide a way to delete local history.
- If cloud history is implemented, enforce user-level authorization in the backend and database policies.
- Do not put service-role credentials in the client.
- Do not include conversation contents in crash logs or analytics by default.
- Clearly explain when text is sent to an external AI provider.
- Avoid sending personal information to analytics services.
- Use secure transport and follow platform security best practices.

Do not market the app as fully private or end-to-end encrypted unless the implementation actually provides those guarantees.

## 12. Testing Requirements

Write meaningful tests for the architecture and core workflows.

### Unit tests
- Domain use cases.
- Repository implementations using mocked data sources.
- Response parsing and mapping.
- Error conversion.
- Input validation.
- Usage-limit handling.

### Provider tests
- Initial loading state.
- Successful response.
- API failure.
- Duplicate submission prevention.
- Retry behavior.
- State updates after deletion or cancellation.

### Widget tests
- Home screen.
- Chat composer and send flow.
- Loading, error, and empty states.
- Translation interaction.
- Language switching.
- Long Khmer text rendering where practical.

Use mocks or fakes for AI API calls. Tests must not consume paid API credits or require production secrets.

## 13. Performance and Cost Controls

- Avoid unnecessary network calls.
- Keep response sizes bounded.
- Use pagination for history when needed.
- Cache only where caching is appropriate and safe.
- Avoid excessive polling.
- Support graceful handling of slow networks.
- Limit free usage on the backend rather than trusting a client-side counter.
- Expose configuration for per-user quotas, daily limits, and model output limits.
- Never assume a free API has unlimited capacity.
- Track AI cost using server-side usage metadata where the provider supports it.
- Do not introduce advertising SDKs or analytics until there is a clear product need and privacy policy.

## 14. Build and Delivery Standards

Before finishing:

1. Run `dart format` on changed Dart files.
2. Run `flutter analyze`.
3. Run relevant unit and widget tests.
4. Resolve errors introduced by your changes.
5. Verify localization generation if applicable.
6. Verify the app builds for the available target platform when practical.
7. Confirm that secrets are not committed.
8. Check dependency injection and repository boundaries.
9. Remove dead code, placeholder production features, and debug output.
10. Update the README with setup and run instructions.

Do not claim commands passed unless they were actually executed successfully. If a command cannot run because the environment lacks Flutter, dependencies, credentials, or network access, report the exact limitation.

## 15. Milestones

Implement in this order:

**Milestone 1 — Inspect and plan**
- Inspect repository and existing rules.
- Establish the architecture and implementation plan.
- Identify required dependencies and configuration.

**Milestone 2 — App foundation**
- Theme, localization, routing, reusable widgets, configuration, and error model.

**Milestone 3 — Functional AI chat**
- Domain contracts, data source, repository, Riverpod state, mock development mode, and chat UI.

**Milestone 4 — Useful assistant tools**
- Translation, writing assistant, and summarization built on reusable domain abstractions.

**Milestone 5 — Persistence and settings**
- Conversation history, preferences, deletion, and settings.

**Milestone 6 — Verification and polish**
- Tests, analysis, accessibility, Khmer typography, performance, and documentation.

Prioritize a complete, working vertical slice over a large number of unfinished screens. If time is constrained, finish and test the chat workflow before expanding features.

## 16. Definition of Done

The MVP is ready for review when:

- The project follows Clean Architecture consistently.
- Riverpod manages dependencies and application state.
- Khmer and English interfaces work.
- Users can submit a prompt and receive a real AI response when a provider is configured.
- Loading, failures, retries, and empty states work.
- Translation, writing assistance, and summarization use the same AI abstraction.
- Conversation history and settings behave as documented.
- API secrets remain outside the mobile client.
- No important UI action is a dead button.
- Core business logic is covered by automated tests.
- Formatting and static analysis have been run.
- Setup and environment configuration are documented.
- All mock-only features and incomplete integrations are explicitly identified.

## Final instruction

Start by inspecting the repository and its project rules. Then present the plan and immediately begin implementation.

Make pragmatic decisions independently, but do not invent credentials, API capabilities, successful test results, or production integrations.

Deliver a working, maintainable Khmer AI Assistant MVP—not just a UI mockup.