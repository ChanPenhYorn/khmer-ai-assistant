import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/ai_reply.dart';

/// Parses the backend response envelope:
///
/// ```json
/// {
///   "text": "…",
///   "model": "provider/model-name",
///   "detected_language": "km",
///   "usage": {
///     "input_tokens": 128,
///     "output_tokens": 256,
///     "remaining_requests": 17
///   }
/// }
/// ```
///
/// Unknown extra fields are ignored, and any missing field other than `text`
/// is tolerated. A missing or empty `text` is an error: the app never invents
/// a reply.
abstract final class AiResponseDto {
  static AiReply parse(Object? data) {
    if (data is! Map) {
      throw const InvalidResponseFailure(
        technicalMessage: 'response body is not a JSON object',
      );
    }
    final map = data.cast<String, dynamic>();

    final text = map['text'];
    if (text is! String || text.trim().isEmpty) {
      throw const InvalidResponseFailure(
        technicalMessage: 'response has no "text" field',
      );
    }

    return AiReply(
      text: text,
      model: map['model'] is String ? map['model'] as String : null,
      detectedLanguage: map['detected_language'] is String
          ? map['detected_language'] as String
          : null,
      usage: _parseUsage(map['usage']),
    );
  }

  static AiUsage _parseUsage(Object? raw) {
    if (raw is! Map) return AiUsage.empty;
    final map = raw.cast<String, dynamic>();
    return AiUsage(
      inputTokens: _asInt(map['input_tokens']),
      outputTokens: _asInt(map['output_tokens']),
      remainingRequests: _asInt(map['remaining_requests']),
      remainingCharacters: _asInt(map['remaining_characters']),
    );
  }

  static int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
