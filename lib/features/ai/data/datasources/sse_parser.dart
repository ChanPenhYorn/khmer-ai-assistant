import 'dart:convert';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/dio_failure_mapper.dart';
import '../../domain/entities/ai_stream_event.dart';
import '../dto/ai_response_dto.dart';

/// Parses the backend's Server-Sent Events stream.
///
/// The wire format is documented in `backend/README.md`:
/// * `data: {"delta":"…"}` for each text chunk,
/// * a terminal `data: {"text":"…","model":"…","usage":{…}}` envelope that
///   carries the complete reply and usage totals,
/// * `data: [DONE]` to end the stream,
/// * `data: {"error":{"code":"…"}}` to fail mid-stream.
///
/// Keeping the parsing here (not in [RemoteAiDataSource]) makes the wire
/// format testable without a network or a Dio double.
class AiSseParser {
  final StringBuffer _dataBuffer = StringBuffer();

  /// Extracts the JSON payload of one `data:` line, or `null` for comments,
  /// blank lines, and other SSE fields. Multi-line data fields are joined per
  /// the SSE specification.
  String? readDataLine(String line) {
    if (line.isEmpty) return null;
    if (line.startsWith(':')) return null; // SSE comment / keep-alive
    if (!line.startsWith('data:')) return null;
    final value = line.substring(5).trim();
    if (value.isEmpty) return null;
    if (_dataBuffer.isNotEmpty) _dataBuffer.write('\n');
    _dataBuffer.write(value);
    final payload = _dataBuffer.toString();
    _dataBuffer.clear();
    return payload;
  }

  /// Decodes one payload into a stream event, or `null` for frames that can be
  /// ignored (unreadable JSON, unknown shapes).
  AiStreamEvent? parsePayload(String payload) {
    final Object? decoded;
    try {
      decoded = jsonDecode(payload);
    } on FormatException {
      return null; // ignore frames we cannot read
    }
    if (decoded is! Map) return null;
    final map = decoded.cast<String, dynamic>();

    // Mid-stream error frame: {"error": {"code": "…", "message": "…"}}
    if (map['error'] != null) {
      final code = map['error'] is Map
          ? (map['error'] as Map)['code']?.toString()
          : map['error'].toString();
      return AiStreamFailed(failureFromServerCode(code));
    }

    // Terminal envelope. It carries `usage` and the complete text. It must be
    // recognised before the delta branch, otherwise the same text would be
    // emitted twice: once as a delta and once as the completed reply.
    if (map.containsKey('usage')) {
      try {
        return AiStreamCompleted(AiResponseDto.parse(map));
      } on AppFailure {
        // Not a usable envelope (for example usage-only metadata): fall through.
      }
    }

    final delta = map['delta'] ?? map['text'];
    if (delta is String) return AiStreamDelta(delta);

    // Legacy shape: a final frame identified only by a model field.
    if (map.containsKey('model')) {
      try {
        return AiStreamCompleted(AiResponseDto.parse(map));
      } on AppFailure {
        return null;
      }
    }
    return null;
  }
}

/// Maps a server error code to the app's typed failure model.
AppFailure failureFromServerCode(String? code) => switch (code) {
  ServerErrorCode.unauthorized => const UnauthorizedFailure(),
  ServerErrorCode.rateLimited => const RateLimitedFailure(),
  ServerErrorCode.quotaExceeded => const QuotaExceededFailure(),
  ServerErrorCode.inputTooLarge => const InputTooLargeFailure(),
  ServerErrorCode.invalidRequest => const InvalidInputFailure(),
  ServerErrorCode.serverError => const ServerFailure(),
  _ => const ProviderFailure(),
};
