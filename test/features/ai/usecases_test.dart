import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/errors/app_failure.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_language.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_message.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_reply.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_stream_event.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_task_options.dart';
import 'package:khmer_ai_assistant/features/ai/domain/repositories/ai_repository.dart';
import 'package:khmer_ai_assistant/features/ai/domain/usecases/explain_english.dart';
import 'package:khmer_ai_assistant/features/ai/domain/usecases/improve_writing.dart';
import 'package:khmer_ai_assistant/features/ai/domain/usecases/send_message.dart';
import 'package:khmer_ai_assistant/features/ai/domain/usecases/summarize_text.dart';
import 'package:khmer_ai_assistant/features/ai/domain/usecases/translate_text.dart';

/// Repository stub: records the call and returns a canned reply.
class _StubAiRepository implements AiRepository {
  int calls = 0;
  Object? lastArguments;

  @override
  Stream<AiStreamEvent> streamMessage({
    required List<AiMessage> conversation,
    required String locale,
  }) {
    calls++;
    lastArguments = (conversation, locale);
    return Stream.value(const AiStreamCompleted(AiReply(text: 'ok')));
  }

  @override
  Future<AiReply> translate({
    required String text,
    required AiLanguage source,
    required AiLanguage target,
  }) async {
    calls++;
    lastArguments = (text, source, target);
    return const AiReply(text: 'translated');
  }

  @override
  Future<AiReply> improveWriting({
    required String text,
    required WritingAction action,
    required WritingTone tone,
    required AiLanguage targetLanguage,
  }) async {
    calls++;
    lastArguments = (text, action, tone, targetLanguage);
    return const AiReply(text: 'improved');
  }

  @override
  Future<AiReply> summarize({
    required String text,
    required SummaryStyle style,
    required AiLanguage outputLanguage,
  }) async {
    calls++;
    lastArguments = (text, style, outputLanguage);
    return const AiReply(text: 'summary');
  }

  @override
  Future<AiReply> explainEnglish({
    required String text,
    required AiLanguage explanationLanguage,
  }) async {
    calls++;
    lastArguments = (text, explanationLanguage);
    return const AiReply(text: 'explained');
  }
}

void main() {
  late _StubAiRepository repository;

  setUp(() => repository = _StubAiRepository());

  group('SendMessage', () {
    final useCase = SendMessage(
      repository: _StubAiRepository(),
      maxInputCharacters: 100,
    );

    test('rejects an empty conversation without calling the backend', () async {
      final stub = _StubAiRepository();
      final send = SendMessage(repository: stub, maxInputCharacters: 100);

      final events = await send(conversation: const [], locale: 'km').toList();

      expect(events.single, isA<AiStreamFailed>());
      expect(
        (events.single as AiStreamFailed).failure.kind,
        FailureKind.invalidInput,
      );
      expect(stub.calls, 0);
    });

    test('rejects whitespace-only user input', () async {
      final stub = _StubAiRepository();
      final send = SendMessage(repository: stub, maxInputCharacters: 100);

      final events = await send(
        conversation: const [AiMessage.user('   ')],
        locale: 'km',
      ).toList();

      expect(events.single, isA<AiStreamFailed>());
      expect(stub.calls, 0);
    });

    test('rejects input over the configured limit', () async {
      final stub = _StubAiRepository();
      final send = SendMessage(repository: stub, maxInputCharacters: 5);

      final events = await send(
        conversation: const [AiMessage.user('far too long')],
        locale: 'km',
      ).toList();

      expect(
        (events.single as AiStreamFailed).failure.kind,
        FailureKind.inputTooLarge,
      );
      expect(stub.calls, 0);
    });

    test('passes a valid conversation through', () async {
      final events = await useCase(
        conversation: const [AiMessage.user('hello')],
        locale: 'en',
      ).toList();

      expect(events.single, isA<AiStreamCompleted>());
    });
  });

  group('TranslateText', () {
    test('rejects identical source and target', () async {
      final stub = _StubAiRepository();
      final translate = TranslateText(
        repository: stub,
        maxInputCharacters: 100,
      );

      await expectLater(
        translate(
          text: 'hello',
          source: AiLanguage.english,
          target: AiLanguage.english,
        ),
        throwsA(isA<InvalidInputFailure>()),
      );
      expect(stub.calls, 0);
    });

    test('allows auto source with the same visible target', () async {
      final stub = _StubAiRepository();
      final translate = TranslateText(
        repository: stub,
        maxInputCharacters: 100,
      );

      final reply = await translate(
        text: 'hello',
        source: AiLanguage.auto,
        target: AiLanguage.english,
      );

      expect(reply.text, 'translated');
      expect(stub.calls, 1);
    });

    test('rejects empty input', () async {
      final stub = _StubAiRepository();
      final translate = TranslateText(
        repository: stub,
        maxInputCharacters: 100,
      );

      await expectLater(
        translate(
          text: '   ',
          source: AiLanguage.english,
          target: AiLanguage.khmer,
        ),
        throwsA(isA<InvalidInputFailure>()),
      );
      expect(stub.calls, 0);
    });
  });

  group('SummarizeText', () {
    test('rejects text that is too short to summarize', () async {
      final stub = _StubAiRepository();
      final summarize = SummarizeText(
        repository: stub,
        maxInputCharacters: 1000,
      );

      await expectLater(
        summarize(
          text: 'too short',
          style: SummaryStyle.short,
          outputLanguage: AiLanguage.khmer,
        ),
        throwsA(isA<InvalidInputFailure>()),
      );
      expect(stub.calls, 0);
    });

    test('accepts text at the minimum length', () async {
      final stub = _StubAiRepository();
      final summarize = SummarizeText(
        repository: stub,
        maxInputCharacters: 1000,
      );

      final reply = await summarize(
        text: 'a' * SummarizeText.minimumCharacters,
        style: SummaryStyle.bullets,
        outputLanguage: AiLanguage.khmer,
      );

      expect(reply.text, 'summary');
    });
  });

  group('ImproveWriting', () {
    test('forwards parameters after validation', () async {
      final stub = _StubAiRepository();
      final improve = ImproveWriting(repository: stub, maxInputCharacters: 100);

      await improve(
        text: 'hello',
        action: WritingAction.shorten,
        tone: WritingTone.casual,
        targetLanguage: AiLanguage.khmer,
      );

      expect(stub.calls, 1);
    });

    test('rejects oversized input before calling the backend', () async {
      final stub = _StubAiRepository();
      final improve = ImproveWriting(repository: stub, maxInputCharacters: 3);

      await expectLater(
        improve(
          text: 'hello',
          action: WritingAction.improve,
          tone: WritingTone.neutral,
          targetLanguage: AiLanguage.khmer,
        ),
        throwsA(isA<InputTooLargeFailure>()),
      );
      expect(stub.calls, 0);
    });
  });

  group('ExplainEnglish', () {
    test('rejects empty input', () async {
      final stub = _StubAiRepository();
      final explain = ExplainEnglish(repository: stub, maxInputCharacters: 50);

      await expectLater(
        explain(text: '', explanationLanguage: AiLanguage.khmer),
        throwsA(isA<InvalidInputFailure>()),
      );
      expect(stub.calls, 0);
    });

    test('returns the explanation', () async {
      final reply = await repository.explainEnglish(
        text: 'nevertheless',
        explanationLanguage: AiLanguage.khmer,
      );
      expect(reply.text, 'explained');
    });
  });
}
