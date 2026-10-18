import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/ai_reply.dart';

part 'ai_usage_provider.g.dart';

/// Last usage metadata reported by the backend.
///
/// Starts empty and stays empty until the server actually reports something:
/// the app never estimates or fabricates quota numbers.
@Riverpod(keepAlive: true)
class AiUsageController extends _$AiUsageController {
  @override
  AiUsage build() => AiUsage.empty;

  void record(AiUsage usage) {
    if (usage.isEmpty) return;
    state = AiUsage(
      inputTokens: usage.inputTokens ?? state.inputTokens,
      outputTokens: usage.outputTokens ?? state.outputTokens,
      remainingRequests: usage.remainingRequests ?? state.remainingRequests,
      remainingCharacters:
          usage.remainingCharacters ?? state.remainingCharacters,
    );
  }
}
