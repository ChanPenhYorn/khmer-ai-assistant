import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/features/ai/data/datasources/ai_mock_data_source.dart';
import 'package:khmer_ai_assistant/features/ai/data/dto/ai_request_dto.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_message.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_stream_event.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_task.dart';

void main() {
  // Zero delay keeps the tests fast; the production default is 40ms.
  final source = MockAiDataSource(chunkDelay: Duration.zero);

  group('MockAiDataSource', () {
    test('streams deltas and then a completion', () async {
      final events = await source
          .stream(
            const AiRequestDto(
              task: AiTask.chat,
              locale: 'km',
              messages: [AiMessage.user('សូមស្វាគមន៍')],
            ),
          )
          .toList();

      expect(events, isNotEmpty);
      expect(events.last, isA<AiStreamCompleted>());
      expect(
        events.whereType<AiStreamDelta>().length,
        greaterThan(1),
        reason: 'the demo source should exercise the streaming UI',
      );
    });

    test('reassembled deltas equal the completed text', () async {
      final events = await source
          .stream(
            const AiRequestDto(
              task: AiTask.summarize,
              locale: 'en',
              input: 'some long text to summarize',
            ),
          )
          .toList();

      final joined = events
          .whereType<AiStreamDelta>()
          .map((e) => e.text)
          .join();
      final completed = events.whereType<AiStreamCompleted>().single;
      expect(joined, completed.reply.text);
    });

    test(
      'Khmer replies say they are a demo and are not a real answer',
      () async {
        final reply = await source.complete(
          const AiRequestDto(
            task: AiTask.chat,
            locale: 'km',
            messages: [AiMessage.user('សំណួរ')],
          ),
        );

        expect(reply.text, contains('Demo mode'));
        expect(reply.text, contains('មិនមែនចម្លើយពី AI ពិតប្រាកដ'));
        expect(reply.text, contains('AI_BASE_URL'));
      },
    );

    test('never reports usage numbers it does not have', () async {
      final reply = await source.complete(
        const AiRequestDto(
          task: AiTask.translate,
          locale: 'en',
          input: 'hello',
        ),
      );

      expect(reply.usage.isEmpty, isTrue);
      expect(reply.usage.remainingRequests, isNull);
    });

    test('echoes the user input so the UI can be verified', () async {
      final reply = await source.complete(
        const AiRequestDto(
          task: AiTask.translate,
          locale: 'en',
          input: 'good morning',
        ),
      );
      expect(reply.text, contains('good morning'));
    });
  });
}
