import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/conversation.dart';

part 'chat_state.freezed.dart';

/// State of one open conversation.
@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    required Conversation conversation,

    /// `true` while the assistant is producing a response.
    @Default(false) bool isGenerating,

    /// Failure of the most recent send attempt, if any.
    AppFailure? failure,

    /// Text that failed to send and can be retried from the error banner.
    String? retryText,
  }) = _ChatState;

  const ChatState._();

  /// `true` when the conversation has no messages yet.
  bool get isEmpty => conversation.messages.isEmpty;

  /// Id of the message currently being streamed, if any.
  String? get streamingMessageId {
    for (final message in conversation.messages) {
      if (message.isStreaming) return message.id;
    }
    return null;
  }
}
