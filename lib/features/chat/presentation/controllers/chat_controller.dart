import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../ai/domain/entities/ai_stream_event.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/chat_message.dart';
import '../providers/chat_providers.dart';
import '../providers/chat_state.dart';

part 'chat_controller.g.dart';

/// Drives one conversation: loading it, sending turns, streaming the answer,
/// stopping generation, retrying and renaming.
///
/// Called with [newConversationId] to start a fresh conversation.
@riverpod
class ChatController extends _$ChatController {
  // Cancelled in `ref.onDispose` and by `stop()`/`deleteConversation()`; it is
  // intentionally not cancelled in `dispose()` because this class is not a
  // widget.
  // ignore: cancel_subscriptions
  StreamSubscription<AiStreamEvent>? _subscription;
  bool _initialised = false;

  @override
  Future<ChatState> build(String conversationId) async {
    ref.onDispose(_cancelSubscription);
    _initialised = true;

    final repository = ref.watch(chatRepositoryProvider);
    if (conversationId == newConversationId) {
      final created = await repository.createConversation();
      return ChatState(conversation: created);
    }

    final existing = await repository.getConversation(conversationId);
    if (existing == null) {
      throw UnknownFailure(
        technicalMessage: 'conversation $conversationId not found',
      );
    }
    return ChatState(conversation: existing);
  }

  /// Sends [text] as a user turn and streams the assistant answer.
  ///
  /// Waits for the conversation to finish loading rather than dropping the
  /// turn, so a prompt handed over from the home screen is never lost.
  ///
  /// Ignored while a generation is already running, which prevents duplicate
  /// submissions from double taps or keyboard `Enter` repeats.
  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final ChatState current;
    try {
      current = state.value ?? await future;
    } catch (_) {
      // Loading failed; the chat screen already shows the failure and offers
      // a retry, so there is nothing useful to do here.
      return;
    }
    if (current.isGenerating) return;

    final now = DateTime.now();
    final userMessage = ChatMessage(
      id: IdGenerator.nextId('m_'),
      author: ChatAuthor.user,
      content: trimmed,
      createdAt: now,
    );
    final placeholder = ChatMessage(
      id: IdGenerator.nextId('m_'),
      author: ChatAuthor.assistant,
      content: '',
      createdAt: now,
      status: ChatMessageStatus.streaming,
    );

    state = AsyncData(
      current.copyWith(
        conversation: current.conversation.copyWith(
          updatedAt: now,
          messages: [
            ...current.conversation.messages,
            userMessage,
            placeholder,
          ],
        ),
        isGenerating: true,
        failure: null,
        retryText: null,
      ),
    );

    // The user's turn is persisted before the network call so it survives a
    // crash or a kill while generation is running.
    await _persist();

    _startGeneration(
      history: [...current.conversation.messages, userMessage],
      assistantMessageId: placeholder.id,
    );
  }

  /// Replaces the last assistant answer with a new one.
  Future<void> regenerate() async {
    final current = state.value;
    if (current == null || current.isGenerating) return;

    final history = current.conversation.messages
        .where((m) => m.id != current.streamingMessageId)
        .toList(growable: true);
    while (history.isNotEmpty && !history.last.isUser) {
      history.removeLast();
    }
    if (history.isEmpty) return;

    final now = DateTime.now();
    final placeholder = ChatMessage(
      id: IdGenerator.nextId('m_'),
      author: ChatAuthor.assistant,
      content: '',
      createdAt: now,
      status: ChatMessageStatus.streaming,
    );

    state = AsyncData(
      current.copyWith(
        conversation: current.conversation.copyWith(
          updatedAt: now,
          messages: [...history, placeholder],
        ),
        isGenerating: true,
        failure: null,
        retryText: null,
      ),
    );

    _startGeneration(history: history, assistantMessageId: placeholder.id);
  }

  /// Retries the turn that failed, dropping the failed answer.
  Future<void> retryLastTurn() async {
    final current = state.value;
    if (current == null || current.isGenerating) return;

    final messages = current.conversation.messages
        .where((m) => m.status != ChatMessageStatus.failed)
        .toList(growable: true);
    // Drop an empty assistant placeholder left behind by the failure.
    while (messages.isNotEmpty &&
        !messages.last.isUser &&
        messages.last.content.trim().isEmpty) {
      messages.removeLast();
    }
    if (messages.isEmpty || !messages.last.isUser) return;

    final now = DateTime.now();
    final placeholder = ChatMessage(
      id: IdGenerator.nextId('m_'),
      author: ChatAuthor.assistant,
      content: '',
      createdAt: now,
      status: ChatMessageStatus.streaming,
    );

    state = AsyncData(
      current.copyWith(
        conversation: current.conversation.copyWith(
          updatedAt: now,
          messages: [...messages, placeholder],
        ),
        isGenerating: true,
        failure: null,
        retryText: null,
      ),
    );

    _startGeneration(history: messages, assistantMessageId: placeholder.id);
  }

  /// Stops the in-flight generation, keeping the text received so far.
  Future<void> stop() async {
    final current = state.value;
    if (current == null || !current.isGenerating) return;

    await _cancelSubscription();
    _finishGeneration(removeEmptyPlaceholder: true);
  }

  Future<void> rename(String title) async {
    final current = state.value;
    if (current == null) return;
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;

    await ref
        .read(chatRepositoryProvider)
        .renameConversation(current.conversation.id, trimmed);
    state = AsyncData(
      current.copyWith(
        conversation: current.conversation.copyWith(title: trimmed),
      ),
    );
    _refreshHistory();
  }

  /// Deletes this conversation and its stored history.
  Future<void> deleteConversation() async {
    final current = state.value;
    if (current == null) return;
    await _cancelSubscription();
    await ref
        .read(chatRepositoryProvider)
        .deleteConversation(current.conversation.id);
    _refreshHistory();
  }

  void _startGeneration({
    required List<ChatMessage> history,
    required String assistantMessageId,
  }) {
    final locale = ref.read(contentLanguageCodeProvider);
    final stream = ref.read(sendChatMessageProvider)(
      history: history,
      locale: locale,
    );

    _subscription = stream.listen(
      (event) => _onStreamEvent(event, assistantMessageId),
      onError: (Object error) {
        _applyFailure(toAppFailure(error), assistantMessageId);
      },
      onDone: () {
        if (_isGenerating()) _finishGeneration();
      },
      cancelOnError: true,
    );
  }

  void _onStreamEvent(AiStreamEvent event, String assistantMessageId) {
    switch (event) {
      case AiStreamDelta(:final text):
        _appendText(assistantMessageId, text);
      case AiStreamCompleted(:final reply):
        _appendText(assistantMessageId, reply.text, replaceWith: true);
        _finishGeneration();
      case AiStreamFailed(:final failure):
        _applyFailure(failure, assistantMessageId);
    }
  }

  void _appendText(String messageId, String text, {bool replaceWith = false}) {
    if (!_initialised) return;
    final current = state.value;
    if (current == null) return;

    final messages = current.conversation.messages
        .map((message) {
          if (message.id != messageId) return message;
          final content = replaceWith
              ? text
              : (message.content.isEmpty ? text : '${message.content}$text');
          return message.copyWith(content: content);
        })
        .toList(growable: false);

    state = AsyncData(
      current.copyWith(
        conversation: current.conversation.copyWith(messages: messages),
      ),
    );
  }

  void _applyFailure(AppFailure failure, String assistantMessageId) {
    final current = state.value;
    if (current == null) return;

    final messages = current.conversation.messages
        .map(
          (message) => message.id == assistantMessageId
              ? message.copyWith(status: ChatMessageStatus.failed)
              : message,
        )
        .toList(growable: false);

    // A user-initiated stop is not an error worth reporting.
    final isCancellation = failure.kind == FailureKind.cancelled;
    final lastUserText = messages.lastWhere(
      (m) => m.isUser,
      orElse: () => messages.first,
    );

    state = AsyncData(
      current.copyWith(
        conversation: current.conversation.copyWith(messages: messages),
        isGenerating: false,
        failure: isCancellation ? null : failure,
        retryText: isCancellation ? null : lastUserText.content,
      ),
    );
    _persist();
  }

  /// Marks the streaming message as finished and stores the conversation.
  void _finishGeneration({bool removeEmptyPlaceholder = false}) {
    final current = state.value;
    if (current == null) return;

    final messages = current.conversation.messages
        .where(
          (message) =>
              !(removeEmptyPlaceholder &&
                  message.isStreaming &&
                  message.content.trim().isEmpty),
        )
        .map(
          (message) => message.isStreaming
              ? message.copyWith(status: ChatMessageStatus.complete)
              : message,
        )
        .toList(growable: false);

    state = AsyncData(
      current.copyWith(
        conversation: current.conversation.copyWith(
          messages: messages,
          updatedAt: DateTime.now(),
        ),
        isGenerating: false,
      ),
    );
    _persist();
  }

  bool _isGenerating() => state.value?.isGenerating ?? false;

  Future<void> _persist() async {
    final current = state.value;
    if (current == null) return;
    await ref
        .read(chatRepositoryProvider)
        .saveConversation(current.conversation);
    _refreshHistory();
  }

  Future<void> _cancelSubscription() async {
    final subscription = _subscription;
    _subscription = null;
    if (subscription == null) return;
    await subscription.cancel();
  }

  void _refreshHistory() {
    ref.invalidate(conversationListProvider);
  }
}
