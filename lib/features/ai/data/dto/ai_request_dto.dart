import '../../domain/entities/ai_message.dart';
import '../../domain/entities/ai_task.dart';

/// Wire-shaped request payload for the AI backend.
///
/// Lives in the data layer so the exact request format stays swappable.
class AiRequestDto {
  const AiRequestDto({
    required this.task,
    required this.locale,
    this.messages = const <AiMessage>[],
    this.input,
    this.params = const <String, Object?>{},
  });

  final AiTask task;

  /// Locale of the user interface, so the backend can pick a reply language.
  final String locale;

  /// Conversation turns, used by [AiTask.chat].
  final List<AiMessage> messages;

  /// Single input string, used by every non-chat task.
  final String? input;

  /// Task-specific parameters (`source`, `target`, `action`, `tone`, `style`, …).
  final Map<String, Object?> params;

  Map<String, dynamic> toJson() => {
    'task': task.wireValue,
    'locale': locale,
    if (messages.isNotEmpty)
      'messages': messages.map((m) => m.toJson()).toList(growable: false),
    if (input != null) 'input': input,
    if (params.isNotEmpty) 'params': params,
  };
}
