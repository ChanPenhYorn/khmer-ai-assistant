import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/core/errors/app_failure.dart';
import 'package:khmer_ai_assistant/core/errors/failure_messages.dart';
import 'package:khmer_ai_assistant/core/utils/input_validator.dart';

void main() {
  group('InputValidator', () {
    test('accepts valid input', () {
      expect(InputValidator.validate(text: 'hello', maxCharacters: 10), isNull);
    });

    test('rejects empty input when required', () {
      final failure = InputValidator.validate(text: '   ', maxCharacters: 10);
      expect(failure, isA<InvalidInputFailure>());
    });

    test('allows empty input when not required', () {
      expect(
        InputValidator.validate(
          text: '',
          maxCharacters: 10,
          requireNonEmpty: false,
        ),
        isNull,
      );
    });

    test('rejects oversized input', () {
      final failure = InputValidator.validate(
        text: 'a' * 11,
        maxCharacters: 10,
      );
      expect(failure, isA<InputTooLargeFailure>());
      expect(failure!.kind, FailureKind.inputTooLarge);
    });

    test('measures length after trimming', () {
      expect(InputValidator.validate(text: '  ab  ', maxCharacters: 2), isNull);
    });
  });

  group('AppFailure', () {
    test('only a network failure is safe to retry', () {
      // A timeout or a 5xx may mean the provider already generated an answer,
      // so retrying those would duplicate work and spend quota twice.
      expect(const NetworkFailure().isSafeToRetry, isTrue);
      expect(const TimeoutFailure().isSafeToRetry, isFalse);
      expect(const ServerFailure().isSafeToRetry, isFalse);
      expect(const RateLimitedFailure().isSafeToRetry, isFalse);
      expect(const ProviderFailure().isSafeToRetry, isFalse);
    });

    test('toString never contains user content', () {
      const failure = ProviderFailure(
        technicalMessage: 'upstream 500',
        statusCode: 500,
      );
      expect(failure.toString(), contains('provider'));
      expect(failure.toString(), contains('500'));
    });

    test('toAppFailure passes failures through and wraps unknown errors', () {
      const failure = TimeoutFailure();
      expect(toAppFailure(failure), same(failure));
      expect(toAppFailure(StateError('boom')), isA<UnknownFailure>());
    });
  });
}
