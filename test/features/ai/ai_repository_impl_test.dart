import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/errors/app_failure.dart';
import 'package:khmer_ai_assistant/features/ai/data/datasources/ai_data_source.dart';
import 'package:khmer_ai_assistant/features/ai/data/dto/ai_request_dto.dart';
import 'package:khmer_ai_assistant/features/ai/data/repositories/ai_repository_impl.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_language.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_message.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_reply.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_stream_event.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_task.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_task_options.dart';

import '../../helpers/fake_ai_data_source.dart';

/// Records requests and fails the first [failuresBeforeSuccess] calls.
class _FlakyDataSource implements AiDataSource {
  _FlakyDataSource({required this.failure, this.failuresBeforeSuccess = 0});

  final AppFailure failure;
  int failuresBeforeSuccess;
  int completeCalls = 0;
  final List<AiRequestDto> requests = <AiRequestDto>[];

  @override
  Future<AiReply> complete(AiRequestDto request) async {
    completeCalls++;
    requests.add(request);
    if (failuresBeforeSuccess > 0) {
      failuresBeforeSuccess--;
      throw failure;
    }
    return const AiReply(text: 'ok');
  }

  @override
  Stream<AiStreamEvent> stream(AiRequestDto request) =>
      const Stream<AiStreamEvent>.empty();
}

/// Starts [stream] and lets the lazy `async*` body run up to its first event.
Future<StreamSubscription<AiStreamEvent>> startStream(
  Stream<AiStreamEvent> stream,
) async {
  final subscription = stream.listen(null);
  await Future<void>.delayed(Duration.zero);
  return subscription;
}

void main() {
  late FakeAiDataSource fake;
  late AiRepositoryImpl repository;

  setUp(() {
    fake = FakeAiDataSource();
    repository = AiRepositoryImpl(
      dataSource: fake,
      retryBackoff: Duration.zero,
    );
  });

  group('request shape', () {
    test('chat sends the conversation and the wire task', () async {
      // `async*` bodies are lazy: nothing is sent until the stream is listened
      // to, which is exactly what the chat controller does.
      final subscription = await startStream(
        repository.streamMessage(
          conversation: const [
            AiMessage.user('hello'),
            AiMessage.assistant('hi'),
          ],
          locale: 'km',
        ),
      );
      addTearDown(subscription.cancel);

      final request = fake.requests.single;
      expect(request.task, AiTask.chat);
      expect(request.locale, 'km');
      expect(request.messages.length, 2);
      expect(request.messages.first.role, AiRole.user);
      expect(request.input, isNull);
    });

    test('translate resolves auto detection locally, without a round trip', () {
      repository.translate(
        text: 'សូមស្វាគមន៍',
        source: AiLanguage.auto,
        target: AiLanguage.english,
      );

      final request = fake.requests.single;
      expect(request.params['source'], 'km');
      expect(request.params['target'], 'en');
    });

    test('translate detects English input', () {
      repository.translate(
        text: 'Good morning',
        source: AiLanguage.auto,
        target: AiLanguage.khmer,
      );
      expect(fake.requests.single.params['source'], 'en');
    });

    test('translate trims the input', () {
      repository.translate(
        text: '  hello  ',
        source: AiLanguage.english,
        target: AiLanguage.khmer,
      );
      expect(fake.requests.single.input, 'hello');
    });

    test('writing sends the action, tone and target language', () {
      repository.improveWriting(
        text: 'hello',
        action: WritingAction.professional,
        tone: WritingTone.friendly,
        targetLanguage: AiLanguage.english,
      );

      final params = fake.requests.single.params;
      expect(params['action'], 'professional');
      expect(params['tone'], 'friendly');
      expect(params['target_language'], 'en');
    });

    test('summarize sends the style', () {
      repository.summarize(
        text: 'long text',
        style: SummaryStyle.bullets,
        outputLanguage: AiLanguage.khmer,
      );
      expect(fake.requests.single.params['style'], 'bullets');
    });

    test('explainEnglish sends the task', () {
      repository.explainEnglish(
        text: 'nevertheless',
        explanationLanguage: AiLanguage.khmer,
      );
      expect(fake.requests.single.task, AiTask.explainEnglish);
    });
  });

  group('retry policy', () {
    test('retries a network failure once', () async {
      final flaky = _FlakyDataSource(
        failure: const NetworkFailure(),
        failuresBeforeSuccess: 1,
      );
      final repo = AiRepositoryImpl(
        dataSource: flaky,
        retryBackoff: Duration.zero,
      );

      final reply = await repo.translate(
        text: 'hi',
        source: AiLanguage.english,
        target: AiLanguage.khmer,
      );

      expect(reply.text, 'ok');
      expect(flaky.completeCalls, 2);
    });

    test('gives up after the configured number of attempts', () async {
      final flaky = _FlakyDataSource(
        failure: const NetworkFailure(),
        failuresBeforeSuccess: 5,
      );
      final repo = AiRepositoryImpl(
        dataSource: flaky,
        retryBackoff: Duration.zero,
      );

      await expectLater(
        repo.translate(
          text: 'hi',
          source: AiLanguage.english,
          target: AiLanguage.khmer,
        ),
        throwsA(isA<NetworkFailure>()),
      );
      expect(flaky.completeCalls, 2);
    });

    test('never retries a provider failure', () async {
      final flaky = _FlakyDataSource(
        failure: const ProviderFailure(),
        failuresBeforeSuccess: 1,
      );
      final repo = AiRepositoryImpl(
        dataSource: flaky,
        retryBackoff: Duration.zero,
      );

      await expectLater(
        repo.translate(
          text: 'hi',
          source: AiLanguage.english,
          target: AiLanguage.khmer,
        ),
        throwsA(isA<ProviderFailure>()),
      );
      expect(flaky.completeCalls, 1);
    });

    test('never retries a timeout, which may already have generated', () async {
      final flaky = _FlakyDataSource(
        failure: const TimeoutFailure(),
        failuresBeforeSuccess: 1,
      );
      final repo = AiRepositoryImpl(
        dataSource: flaky,
        retryBackoff: Duration.zero,
      );

      await expectLater(
        repo.translate(
          text: 'hi',
          source: AiLanguage.english,
          target: AiLanguage.khmer,
        ),
        throwsA(isA<TimeoutFailure>()),
      );
      expect(flaky.completeCalls, 1);
    });

    test('chat streaming is never retried automatically', () async {
      final subscription = await startStream(
        repository.streamMessage(
          conversation: const [AiMessage.user('hi')],
          locale: 'en',
        ),
      );
      addTearDown(subscription.cancel);

      expect(fake.streamCalls, 1);
    });
  });
}
