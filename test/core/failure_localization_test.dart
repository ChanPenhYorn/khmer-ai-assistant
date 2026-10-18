import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/app/localization/generated/app_localizations.dart';
import 'package:khmer_ai_assistant/core/errors/app_failure.dart';
import 'package:khmer_ai_assistant/core/errors/failure_messages.dart';

/// Every failure kind needs a message in every shipped language, otherwise the
/// UI would fall back to technical text.
void main() {
  final failures = <AppFailure>[
    const NetworkFailure(),
    const TimeoutFailure(),
    const UnauthorizedFailure(),
    const RateLimitedFailure(),
    const ProviderFailure(),
    const InvalidResponseFailure(),
    const InputTooLargeFailure(),
    const QuotaExceededFailure(),
    const ServerFailure(),
    const MisconfiguredFailure(),
    const CancelledFailure(),
    const InvalidInputFailure(),
    const UnknownFailure(),
  ];

  for (final locale in const [Locale('km'), Locale('en')]) {
    group('localized messages (${locale.languageCode})', () {
      late AppLocalizations l10n;

      setUpAll(() async {
        l10n = await AppLocalizations.delegate.load(locale);
      });

      test('covers every failure kind', () {
        final kinds = failures.map((f) => f.kind).toSet();
        expect(
          kinds.length,
          FailureKind.values.length,
          reason: 'a failure kind is missing from this test',
        );
      });

      test('returns non-empty, non-technical text', () {
        for (final failure in failures) {
          final message = failure.localizedMessage(l10n);
          expect(
            message.trim(),
            isNotEmpty,
            reason: '${failure.kind} is empty',
          );
          expect(
            message,
            isNot(contains('Exception')),
            reason: '${failure.kind} leaks exception text',
          );
        }
      });
    });
  }

  test('Khmer and English messages differ', () async {
    final km = await AppLocalizations.delegate.load(const Locale('km'));
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    expect(
      const NetworkFailure().localizedMessage(km),
      isNot(const NetworkFailure().localizedMessage(en)),
    );
  });
}
