import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../errors/app_failure.dart';

/// Server error codes understood by the client. Documented in
/// `backend/README.md`; the backend always returns
/// `{"error": {"code": "...", "message": "..."}}`.
abstract final class ServerErrorCode {
  static const unauthorized = 'unauthorized';
  static const rateLimited = 'rate_limited';
  static const quotaExceeded = 'quota_exceeded';
  static const inputTooLarge = 'input_too_large';
  static const invalidRequest = 'invalid_request';
  static const providerError = 'provider_error';
  static const serverError = 'server_error';
}

/// Translates transport-level errors into the app's typed failure model.
///
/// Keeping this in one place means every data source reports failures the same
/// way, and no Dio type ever reaches the domain or presentation layers.
AppFailure mapDioException(DioException error) {
  final status = error.response?.statusCode;
  final serverCode = _readServerCode(error.response?.data);
  final detail = serverCode ?? error.message;

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return TimeoutFailure(technicalMessage: detail, cause: error);
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return NetworkFailure(technicalMessage: detail, cause: error);
    case DioExceptionType.cancel:
      return const CancelledFailure();
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
      break;
  }

  if (error.error is SocketException) {
    return NetworkFailure(technicalMessage: detail, cause: error);
  }

  switch (serverCode) {
    case ServerErrorCode.unauthorized:
      return UnauthorizedFailure(
        technicalMessage: detail,
        statusCode: status,
        cause: error,
      );
    case ServerErrorCode.rateLimited:
      return RateLimitedFailure(
        technicalMessage: detail,
        statusCode: status,
        cause: error,
      );
    case ServerErrorCode.quotaExceeded:
      return QuotaExceededFailure(
        technicalMessage: detail,
        statusCode: status,
        cause: error,
      );
    case ServerErrorCode.inputTooLarge:
      return InputTooLargeFailure(technicalMessage: detail, cause: error);
    case ServerErrorCode.providerError:
      return ProviderFailure(
        technicalMessage: detail,
        statusCode: status,
        cause: error,
      );
    case ServerErrorCode.serverError:
      return ServerFailure(
        technicalMessage: detail,
        statusCode: status,
        cause: error,
      );
    case ServerErrorCode.invalidRequest:
      return InvalidInputFailure(technicalMessage: detail);
  }

  if (status == null) {
    return NetworkFailure(technicalMessage: detail, cause: error);
  }
  if (status == 401 || status == 403) {
    return UnauthorizedFailure(
      technicalMessage: detail,
      statusCode: status,
      cause: error,
    );
  }
  if (status == 413) {
    return InputTooLargeFailure(technicalMessage: detail, cause: error);
  }
  if (status == 429) {
    return RateLimitedFailure(
      technicalMessage: detail,
      statusCode: status,
      cause: error,
    );
  }
  if (status >= 500) {
    return ServerFailure(
      technicalMessage: detail,
      statusCode: status,
      cause: error,
    );
  }
  if (status >= 400) {
    return ProviderFailure(
      technicalMessage: detail,
      statusCode: status,
      cause: error,
    );
  }
  return UnknownFailure(technicalMessage: detail, cause: error);
}

/// Extracts `error.code` from a response body without throwing on junk input.
String? _readServerCode(Object? data) {
  final map = _asStringMap(data);
  if (map == null) return null;
  final error = map['error'];
  if (error is Map) {
    final code = error['code'];
    if (code is String && code.isNotEmpty) return code;
    final message = error['message'];
    if (message is String && message.isNotEmpty) return message;
  }
  return null;
}

Map<String, dynamic>? _asStringMap(Object? data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return data.cast<String, dynamic>();
  if (data is String && data.isNotEmpty) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map) return decoded.cast<String, dynamic>();
    } on FormatException {
      return null;
    }
  }
  return null;
}

/// Debug-only logging helper that never prints tokens or conversation content.
void logFailureInDebug(AppFailure failure) {
  if (kDebugMode) {
    debugPrint(
      '[ai] ${failure.kind.name} :: ${failure.technicalMessage ?? '-'}',
    );
  }
}
