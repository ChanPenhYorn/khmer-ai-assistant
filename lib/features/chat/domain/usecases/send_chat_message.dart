import '../../../ai/domain/entities/ai_message.dart';
import '../../../ai/domain/entities/ai_stream_event.dart';
import '../../../ai/domain/usecases/send_message.dart';
import '../entities/chat_message.dart';

/// Sends the conversation to the assistant, trimmed to a bounded context.
///
/// Only the most recent [maxHistoryMessages] turns are sent. This keeps request
/// size (and therefore cost) predictable, and keeps the request under the
/// backend's input limits.
class SendChatMessage {
  const SendChatMessage({
    required SendMessage sendMessage,
    this.maxHistoryMessages = 20,
  }) : _sendMessage = sendMessage;

  final SendMessage _sendMessage;
  final int maxHistoryMessages;

  Stream<AiStreamEvent> call({
    required List<ChatMessage> history,
    required String locale,
  }) {
    return _sendMessage(
      conversation: _toContext(history),
      locale: locale,
    );
  }

  /// Exposed for tests: builds the exact message list that is transmitted.
  List<AiMessage> contextFor(List<ChatMessage> history) => _toContext(history);

  List<AiMessage> _toContext(List<ChatMessage> history) {
    final usable = history
        .where((m) => !m.isEmpty && m.status != ChatMessageStatus.failed)
        .toList(growable: false);
    if (usable.length <= maxHistoryMessages) {
      return usable.map((m) => m.toAiMessage()).toList(growable: false);
    }
    final window = usable.sublist(usable.length - maxHistoryMessages);
    // A context window must start with a user turn.
    final firstUserIndex = window.indexWhere((m) => m.isUser);
    final trimmed = firstUserIndex <= 0 ? window : window.sublist(firstUserIndex);
    return trimmed.map((m) => m.toAiMessage()).toList(growable: false);
  }
}
