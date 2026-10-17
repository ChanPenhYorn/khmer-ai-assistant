import '../../app/localization/generated/app_localizations.dart';
import 'app_failure.dart';

/// Maps a typed [AppFailure] to a localized, non-technical message.
///
/// The switch is exhaustive over [FailureKind]: adding a new failure kind
/// without a message is a compile error.
extension AppFailureLocalization on AppFailure {
  String localizedMessage(AppLocalizations l10n) => switch (kind) {
    FailureKind.network => l10n.errorNetwork,
    FailureKind.timeout => l10n.errorTimeout,
    FailureKind.unauthorized => l10n.errorUnauthorized,
    FailureKind.rateLimited => l10n.errorRateLimited,
    FailureKind.provider => l10n.errorProvider,
    FailureKind.invalidResponse => l10n.errorInvalidResponse,
    FailureKind.inputTooLarge => l10n.errorInputTooLarge,
    FailureKind.quotaExceeded => l10n.errorQuotaExceeded,
    FailureKind.server => l10n.errorServer,
    FailureKind.misconfigured => l10n.errorMisconfigured,
    FailureKind.cancelled => l10n.errorCancelled,
    FailureKind.invalidInput => l10n.errorInvalidInput,
    FailureKind.unknown => l10n.errorUnknown,
  };
}

/// Wraps an arbitrary error into a typed [AppFailure].
AppFailure toAppFailure(Object error) {
  if (error is AppFailure) return error;
  return UnknownFailure(technicalMessage: error.toString(), cause: error);
}
