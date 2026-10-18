import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/errors/app_failure.dart';
import 'package:khmer_ai_assistant/features/ai/data/dto/ai_response_dto.dart';

void main() {
  group('AiResponseDto.parse', () {
    test('reads text, model, detection and usage', () {
      final reply = AiResponseDto.parse({
        'text': 'សូមស្វាគមន៍',
        'model': 'provider/model',
        'detected_language': 'km',
        'usage': {
          'input_tokens': 12,
          'output_tokens': 34,
          'remaining_requests': 8,
        },
      });

      expect(reply.text, 'សូមស្វាគមន៍');
      expect(reply.model, 'provider/model');
      expect(reply.detectedLanguage, 'km');
      expect(reply.usage.inputTokens, 12);
      expect(reply.usage.outputTokens, 34);
      expect(reply.usage.remainingRequests, 8);
      expect(reply.usage.isEmpty, isFalse);
    });

    test('tolerates missing optional fields', () {
      final reply = AiResponseDto.parse({'text': 'ok'});
      expect(reply.text, 'ok');
      expect(reply.model, isNull);
      expect(reply.detectedLanguage, isNull);
      expect(reply.usage.isEmpty, isTrue);
    });

    test('accepts numeric strings for usage counters', () {
      final reply = AiResponseDto.parse({
        'text': 'ok',
        'usage': {'remaining_requests': '5'},
      });
      expect(reply.usage.remainingRequests, 5);
    });

    test('rejects a body without text', () {
      expect(
        () => AiResponseDto.parse({'model': 'x'}),
        throwsA(isA<InvalidResponseFailure>()),
      );
    });

    test('rejects blank text rather than showing an empty answer', () {
      expect(
        () => AiResponseDto.parse({'text': '   '}),
        throwsA(isA<InvalidResponseFailure>()),
      );
    });

    test('rejects a non-object body', () {
      expect(
        () => AiResponseDto.parse('not json'),
        throwsA(isA<InvalidResponseFailure>()),
      );
      expect(
        () => AiResponseDto.parse(null),
        throwsA(isA<InvalidResponseFailure>()),
      );
    });
  });
}
