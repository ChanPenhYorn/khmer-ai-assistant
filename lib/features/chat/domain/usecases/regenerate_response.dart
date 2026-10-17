import '../../../ai/domain/entities/ai_stream_event.dart';
import '../entities/chat_message.dart';
import '../entities/conversation.dart';
import 'send_chat_message.dart';

/// Regenerates the last assistant answer.
///
/// The previous answer is dropped from the context so the model is not asked to
/// repeat itself, and the user's last message stays as the final turn.
class RegenerateResponse {
  const RegenerateResponse({required SendChatMessage sendChatMessage})
    : _sendChatMessage = sendChatMessage;

  final SendChatMessage _sendChatMessage;

  /// Returns `null` when there is nothing to regenerate.
  Stream<AiStreamEvent>? call({
    required Conversation conversation,
    required String locale,
  }) {
    final history = conversation.messages
        .where((m) => m.status == ChatMessageStatus.complete)
        .toList(growable: true);
    while (history.isNotEmpty && !history.last.isUser) {
      history.removeLast();
    }
    if (history.isEmpty || !history.last.isUser) return null;

    return _sendChatMessage(history: history, locale: locale);
  }
}
