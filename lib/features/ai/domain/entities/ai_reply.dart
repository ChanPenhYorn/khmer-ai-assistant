import 'package:flutter/foundation.dart';

/// Server-reported token and quota metadata. Every field is optional: the app
/// shows nothing rather than inventing numbers when the backend omits them.
@immutable
class AiUsage {
  const AiUsage({
    this.inputTokens,
    this.outputTokens,
    this.remainingRequests,
    this.remainingCharacters,
  });

  static const AiUsage empty = AiUsage();

  final int? inputTokens;
  final int? outputTokens;

  /// Remaining requests in the caller's current allowance, when the server
  /// enforces and reports one.
  final int? remainingRequests;

  /// Remaining characters in the caller's allowance, when reported.
  final int? remainingCharacters;

  bool get isEmpty =>
      inputTokens == null &&
      outputTokens == null &&
      remainingRequests == null &&
      remainingCharacters == null;

  @override
  String toString() =>
      'AiUsage(in: $inputTokens, out: $outputTokens, '
      'remainingRequests: $remainingRequests)';
}

/// A completed assistant response.
@immutable
class AiReply {
  const AiReply({
    required this.text,
    this.model,
    this.usage = AiUsage.empty,
    this.detectedLanguage,
  });

  final String text;

  /// Model identifier reported by the backend. Never hardcoded in the client.
  final String? model;

  final AiUsage usage;

  /// Language the backend recognised in the input, when it reports one.
  final String? detectedLanguage;

  bool get isEmpty => text.trim().isEmpty;

  @override
  String toString() => 'AiReply(${text.length} chars, model: $model)';
}
