import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/errors/app_failure.dart';
import 'package:khmer_ai_assistant/features/ai/data/datasources/sse_parser.dart';
import 'package:khmer_ai_assistant/features/ai/domain/entities/ai_stream_event.dart';

void main() {
  group('AiSseParser.readDataLine', () {
    test('reads a data field and trims the value', () {
      final parser = AiSseParser();
      expect(parser.readDataLine('data: {"delta":"hi"}'), '{"delta":"hi"}');
    });

    test('ignores comments, event fields and blank lines', () {
      final parser = AiSseParser();
      expect(parser.readDataLine(': keep-alive'), isNull);
      expect(parser.readDataLine('event: message'), isNull);
      expect(parser.readDataLine(''), isNull);
      expect(parser.readDataLine('data:'), isNull);
    });

    test('passes the [DONE] sentinel through for the caller to handle', () {
      final parser = AiSseParser();
      expect(parser.readDataLine('data: [DONE]'), '[DONE]');
    });
  });

  group('AiSseParser.parsePayload', () {
    test('decodes a delta frame', () {
      final parser = AiSseParser();
      final event = parser.parsePayload('{"delta":"សួស្តី"}');
      expect(event, isA<AiStreamDelta>());
      expect((event as AiStreamDelta).text, 'សួស្តី');
    });

    test('recognises "text" as a delta when there is no usage', () {
      final parser = AiSseParser();
      final event = parser.parsePayload('{"text":"ជំរាបសួរ"}');
      expect(event, isA<AiStreamDelta>());
    });

    test(
      'treats a terminal envelope as completion, not as a duplicate delta',
      () {
        final parser = AiSseParser();
        final event = parser.parsePayload(
          jsonEncode({
            'text': 'ចម្លើយពេញលេញ',
            'model': 'provider/model',
            'usage': {'input_tokens': 12, 'output_tokens': 34},
          }),
        );

        expect(event, isA<AiStreamCompleted>());
        final reply = (event as AiStreamCompleted).reply;
        expect(reply.text, 'ចម្លើយពេញលេញ');
        expect(reply.model, 'provider/model');
        expect(reply.usage.inputTokens, 12);
        expect(reply.usage.outputTokens, 34);
      },
    );

    test('maps a mid-stream error frame to a failure', () {
      final parser = AiSseParser();
      final event = parser.parsePayload(
        '{"error":{"code":"rate_limited","message":"slow down"}}',
      );
      expect(event, isA<AiStreamFailed>());
      expect((event as AiStreamFailed).failure.kind, FailureKind.rateLimited);
    });

    test('ignores junk and unknown shapes instead of throwing', () {
      final parser = AiSseParser();
      expect(parser.parsePayload('not json'), isNull);
      expect(parser.parsePayload('[1,2,3]'), isNull);
      expect(parser.parsePayload('{"unrelated":true}'), isNull);
    });
  });

  group('failureFromServerCode', () {
    test('maps each documented server code', () {
      expect(
        failureFromServerCode('unauthorized').kind,
        FailureKind.unauthorized,
      );
      expect(
        failureFromServerCode('quota_exceeded').kind,
        FailureKind.quotaExceeded,
      );
      expect(
        failureFromServerCode('input_too_large').kind,
        FailureKind.inputTooLarge,
      );
      expect(failureFromServerCode('nonsense').kind, FailureKind.provider);
    });
  });
}
