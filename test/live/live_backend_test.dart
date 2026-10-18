import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/config/ai_config.dart';
import 'package:khmer_ai_assistant/core/config/app_providers.dart';
import 'package:khmer_ai_assistant/core/network/dio_providers.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_language.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_message.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_stream_event.dart';
import 'package:khmer_ai_assistant/features/ai/presentation/providers/ai_providers.dart';

import '../helpers/fake_auth_token_store.dart';

/// End-to-end check of the client's wire contract against a running backend.
///
/// Skipped unless an endpoint is passed in, because it needs the network and
/// spends real provider credits:
///
/// ```sh
/// flutter test test/live \
///   --dart-define=LIVE_AI_BASE_URL=https://api.chanpenh.store
/// ```
///
/// This is the transport half of "one end-to-end turn"; the UI half is a
/// manual device run. See `docs/ai/provider-integration.md`.
const String liveBaseUrl = String.fromEnvironment('LIVE_AI_BASE_URL');
const String liveAssistantPath = String.fromEnvironment(
  'LIVE_AI_ASSISTANT_PATH',
  defaultValue: '/v1/assistant',
);

void main() {
  // Deliberately no `TestWidgetsFlutterBinding`: it replaces `HttpClient` with
  // a stub that answers every request with status 400.
  final skipReason = liveBaseUrl.isEmpty
      ? 'LIVE_AI_BASE_URL is not set; skipping the live backend check'
      : null;

  late ProviderContainer container;

  setUpAll(() {
    container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        aiConfigProvider.overrideWithValue(
          const AiConfig(
            baseUrl: liveBaseUrl,
            assistantPath: liveAssistantPath,
            requestTimeout: Duration(seconds: 90),
            maxInputCharacters: 6000,
            useMockDataSource: false,
            streamingEnabled: true,
          ),
        ),
        // The real store needs a platform keychain, which the test VM has not.
        authTokenStoreProvider.overrideWithValue(FakeAuthTokenStore()),
      ],
    );
  });

  tearDownAll(() => container.dispose());

  test(
    'translate: plain request returns a real reply and real usage',
    () async {
      final reply = await container
          .read(aiRepositoryProvider)
          .translate(
            text: 'សូមស្វាគមន៍មកកាន់កម្ពុជា',
            source: AiLanguage.khmer,
            target: AiLanguage.english,
          );

      expect(reply.text.trim(), isNotEmpty);
      // A model name only ever comes from the server; the client has none.
      expect(reply.model, isNotNull);
      expect(reply.text, contains(RegExp('[A-Za-z]')));
    },
    skip: skipReason,
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'chat: the stream arrives as deltas and ends with the full envelope',
    () async {
      final events = await container
          .read(aiRepositoryProvider)
          .streamMessage(
            conversation: const [
              AiMessage.user('តើការប្រាក់គឺជាអ្វី? ឆ្លើយខ្លីៗ។'),
            ],
            locale: 'km',
          )
          .toList();

      final failures = events.whereType<AiStreamFailed>().toList();
      expect(failures, isEmpty, reason: 'the backend reported an error frame');

      final deltas = events.whereType<AiStreamDelta>().toList();
      final completed = events.whereType<AiStreamCompleted>().toList();
      expect(
        deltas.length,
        greaterThan(1),
        reason: 'the answer must stream, not arrive in one frame',
      );
      expect(completed, hasLength(1));

      final streamed = deltas.map((event) => event.text).join();
      expect(streamed, completed.single.reply.text);
      expect(streamed, contains(RegExp('[\\u1780-\\u17FF]'))); // Khmer script
    },
    skip: skipReason,
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
