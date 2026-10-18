import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/config/app_providers.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../controllers/chat_controller.dart';
import '../providers/chat_providers.dart';
import '../providers/chat_state.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_message_bubble.dart';

/// Chat screen for one conversation.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  /// Conversation to open, or [newConversationId] to start a new one.
  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _composerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _composerFocus = FocusNode();

  bool _stickToBottom = true;
  bool _autoSent = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendPendingPrompt());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _composerController.dispose();
    _composerFocus.dispose();
    super.dispose();
  }

  /// Tracks whether the user is reading near the end of the conversation.
  ///
  /// Auto-scrolling only happens in that case, so a user scrolling back through
  /// history is never yanked to the bottom mid-read.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    _stickToBottom = position.maxScrollExtent - position.pixels < 96;
  }

  void _scrollToBottomIfNeeded() {
    if (!_stickToBottom || !_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  /// Scrolls back to the newest message when the user was reading history.
  void _jumpToBottom() {
    if (!_scrollController.hasClients) return;
    _stickToBottom = true;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: AppConstants.motionSlow,
      curve: Curves.easeOutCubic,
    );
  }

  /// Sends a prompt handed over from the home screen, exactly once.
  Future<void> _sendPendingPrompt() async {
    if (_autoSent) return;
    final prompt = ref.read(pendingPromptProvider.notifier).take();
    if (prompt == null || prompt.trim().isEmpty) return;
    _autoSent = true;
    _composerController.text = prompt;
    _scrollToBottomIfNeeded();
    await ref
        .read(chatControllerProvider(widget.conversationId).notifier)
        .send(prompt);
    _composerController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = chatControllerProvider(widget.conversationId);
    final asyncState = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final l10n = context.l10n;
    final maxInput = ref.watch(aiConfigProvider).maxInputCharacters;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              asyncState.value?.conversation.title.isEmpty ?? true
                  ? l10n.chatTitle
                  : asyncState.value!.conversation.title,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              l10n.assistantName,
              style: context.texts.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.chatNewConversation,
            onPressed: () => context.go(AppRoutes.chat),
            icon: const Icon(Icons.add_comment_outlined),
          ),
          if (asyncState.hasValue)
            PopupMenuButton<_ChatMenuAction>(
              onSelected: (action) async {
                switch (action) {
                  case _ChatMenuAction.rename:
                    await _showRenameDialog(
                      context,
                      asyncState.value!.conversation.title,
                      controller.rename,
                    );
                  case _ChatMenuAction.delete:
                    final deleted = await _confirmDelete(context);
                    if (deleted && context.mounted) {
                      await controller.deleteConversation();
                      if (context.mounted) context.go(AppRoutes.chat);
                    }
                  case _ChatMenuAction.history:
                    if (context.mounted) context.go(AppRoutes.history);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _ChatMenuAction.rename,
                  child: Text(l10n.chatRenameTitle),
                ),
                PopupMenuItem(
                  value: _ChatMenuAction.history,
                  child: Text(l10n.historyTitle),
                ),
                PopupMenuItem(
                  value: _ChatMenuAction.delete,
                  child: Text(l10n.chatDeleteConfirm),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (error, _) => AppErrorView(
            failure: toAppFailure(error),
            onRetry: () => ref.invalidate(provider),
          ),
          data: (state) => _buildConversation(state, controller, maxInput),
        ),
      ),
      floatingActionButton:
          asyncState.hasValue &&
              asyncState.value!.conversation.messages.isNotEmpty &&
              !_stickToBottom
          ? FloatingActionButton.small(
              onPressed: _jumpToBottom,
              tooltip: l10n.chatScrollToBottom,
              child: const Icon(Icons.keyboard_arrow_down_rounded),
            )
          : null,
    );
  }

  Widget _buildConversation(
    ChatState state,
    ChatController controller,
    int maxInput,
  ) {
    final l10n = context.l10n;
    _scrollToBottomIfNeeded();

    final messages = state.conversation.messages;
    final lastAssistantId = messages.isEmpty
        ? null
        : messages.lastWhere((m) => !m.isUser, orElse: () => messages.first).id;

    return Column(
      children: [
        if (state.failure != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spaceMd,
              AppConstants.spaceSm,
              AppConstants.spaceMd,
              0,
            ),
            child: AppErrorView(
              failure: state.failure!,
              compact: true,
              onRetry: controller.retryLastTurn,
            ),
          ),
        Expanded(
          child: messages.isEmpty
              ? EmptyStateView(
                  title: l10n.chatEmptyTitle,
                  body: l10n.chatEmptyBody,
                  suggestions: [
                    l10n.chatEmptySuggestion1,
                    l10n.chatEmptySuggestion2,
                    l10n.chatEmptySuggestion3,
                  ],
                  onSuggestionSelected: (suggestion) =>
                      _submit(suggestion, controller),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.spaceMd,
                    AppConstants.spaceMd,
                    AppConstants.spaceMd,
                    AppConstants.spaceSm,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ChatMessageBubble(
                      message: message,
                      isLastAssistantMessage:
                          message.id == lastAssistantId && !message.isStreaming,
                      onRegenerate:
                          message.id == lastAssistantId &&
                              !message.isStreaming &&
                              !state.isGenerating
                          ? controller.regenerate
                          : null,
                    );
                  },
                ),
        ),
        ChatComposer(
          controller: _composerController,
          focusNode: _composerFocus,
          isGenerating: state.isGenerating,
          enabled: true,
          maxLength: maxInput,
          onSend: () => _submit(_composerController.text, controller),
          onStop: controller.stop,
        ),
      ],
    );
  }

  Future<void> _submit(String text, ChatController controller) async {
    if (text.trim().isEmpty) return;
    _stickToBottom = true;
    _composerController.clear();
    await controller.send(text);
    _scrollToBottomIfNeeded();
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = context.l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chatDeleteTitle),
        content: Text(l10n.chatDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    String currentTitle,
    Future<void> Function(String) onSave,
  ) async {
    final l10n = context.l10n;
    final controller = TextEditingController(text: currentTitle);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chatRenameTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: AppConstants.maxConversationTitleLength,
          decoration: InputDecoration(hintText: l10n.chatRenameHint),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(l10n.actionSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (newTitle != null && newTitle.trim().isNotEmpty) {
      await onSave(newTitle);
    }
  }
}

enum _ChatMenuAction { rename, delete, history }
