import 'package:flutter/foundation.dart';

/// Broad category of a failure. Presentation code maps this to a localized
/// message; it never shows [AppFailure.technicalMessage] to end users.
enum FailureKind {
  /// The device has no working network connection.
  network,

  /// The request exceeded the configured timeout.
  timeout,

  /// 401/403 from the backend.
  unauthorized,

  /// 429 or a provider rate limit.
  rateLimited,

  /// The AI provider refused or failed to produce an answer.
  provider,

  /// The payload could not be parsed into the expected shape.
  invalidResponse,

  /// The input is larger than the configured limit.
  inputTooLarge,

  /// The user exhausted their server-side allowance.
  quotaExceeded,

  /// 5xx from the backend.
  server,

  /// No AI endpoint is configured.
  misconfigured,

  /// The request was cancelled by the user.
  cancelled,

  /// The input failed local validation before any request was made.
  invalidInput,

  unknown,
}

/// Typed failure raised by the data layer and surfaced by providers.
///
/// Use [AppFailure.localizedMessage] (in `failure_messages.dart`) to obtain a
/// user-facing string.
@immutable
sealed class AppFailure implements Exception {
  const AppFailure({
    required this.kind,
    this.technicalMessage,
    this.statusCode,
    this.cause,
  });

  final FailureKind kind;

  /// Diagnostic detail. Logged in debug builds only, never rendered.
  final String? technicalMessage;

  final int? statusCode;
  final Object? cause;

  /// Whether retrying the same request is guaranteed not to duplicate work.
  ///
  /// Only a failure that happened *before* the request reached the server
  /// qualifies: a timeout or a 5xx may mean the provider already generated
  /// (and billed for) an answer. See `AppFailure.isSafeToRetry` usage in
  /// `AiRepositoryImpl`.
  bool get isSafeToRetry => switch (kind) {
    FailureKind.network => true,
    FailureKind.timeout => false,
    FailureKind.server => false,
    FailureKind.rateLimited => false,
    FailureKind.quotaExceeded => false,
    FailureKind.unauthorized => false,
    FailureKind.misconfigured => false,
    FailureKind.invalidInput => false,
    FailureKind.inputTooLarge => false,
    FailureKind.provider => false,
    FailureKind.invalidResponse => false,
    FailureKind.cancelled => false,
    FailureKind.unknown => false,
  };

  @override
  String toString() =>
      'AppFailure(${kind.name}'
      '${statusCode != null ? ', status: $statusCode' : ''}'
      '${technicalMessage != null ? ', detail: $technicalMessage' : ''})';
}

/// Device is offline or the host is unreachable.
final class NetworkFailure extends AppFailure {
  const NetworkFailure({super.technicalMessage, super.cause})
    : super(kind: FailureKind.network);
}

/// The request did not complete inside the configured timeout.
final class TimeoutFailure extends AppFailure {
  const TimeoutFailure({super.technicalMessage, super.cause})
    : super(kind: FailureKind.timeout);
}

/// The backend rejected the caller's credentials.
final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure({super.technicalMessage, super.statusCode, super.cause})
    : super(kind: FailureKind.unauthorized);
}

/// The caller is sending requests too quickly.
final class RateLimitedFailure extends AppFailure {
  const RateLimitedFailure({super.technicalMessage, super.statusCode, super.cause})
    : super(kind: FailureKind.rateLimited);
}

/// The AI provider could not fulfil the request.
final class ProviderFailure extends AppFailure {
  const ProviderFailure({super.technicalMessage, super.statusCode, super.cause})
    : super(kind: FailureKind.provider);
}

/// The response body was missing or malformed.
final class InvalidResponseFailure extends AppFailure {
  const InvalidResponseFailure({super.technicalMessage, super.statusCode, super.cause})
    : super(kind: FailureKind.invalidResponse);
}

/// The input exceeds the configured size limit.
final class InputTooLargeFailure extends AppFailure {
  const InputTooLargeFailure({super.technicalMessage, super.cause})
    : super(kind: FailureKind.inputTooLarge);
}

/// The user ran out of server-side allowance.
final class QuotaExceededFailure extends AppFailure {
  const QuotaExceededFailure({super.technicalMessage, super.statusCode, super.cause})
    : super(kind: FailureKind.quotaExceeded);
}

/// The backend reported an unexpected error.
final class ServerFailure extends AppFailure {
  const ServerFailure({super.technicalMessage, super.statusCode, super.cause})
    : super(kind: FailureKind.server);
}

/// No AI endpoint has been configured for this build.
final class MisconfiguredFailure extends AppFailure {
  const MisconfiguredFailure({super.technicalMessage})
    : super(kind: FailureKind.misconfigured);
}

/// The user cancelled the request.
final class CancelledFailure extends AppFailure {
  const CancelledFailure() : super(kind: FailureKind.cancelled);
}

/// Local validation rejected the input before a request was sent.
final class InvalidInputFailure extends AppFailure {
  const InvalidInputFailure({super.technicalMessage})
    : super(kind: FailureKind.invalidInput);
}

/// Anything not covered by the cases above.
final class UnknownFailure extends AppFailure {
  const UnknownFailure({super.technicalMessage, super.statusCode, super.cause})
    : super(kind: FailureKind.unknown);
}
