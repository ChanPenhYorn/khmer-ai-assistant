import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/copy_action.dart';
import '../../../../core/widgets/markdown_text.dart';
import '../../domain/entities/chat_message.dart';

/// One message in the conversation.
///
/// User turns are compact bubbles on the trailing edge; assistant turns use the
/// full width so Markdown, code blocks and long Khmer paragraphs stay readable.
class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    this.isLastAssistantMessage = false,
    this.onRegenerate,
  });

  final ChatMessage message;
  final bool isLastAssistantMessage;
  final VoidCallback? onRegenerate;

  @override
  Widget build(BuildContext context) {
    return message.isUser
        ? _UserBubble(message: message)
        : _AssistantBubble(
            message: message,
            showActions: isLastAssistantMessage,
            onRegenerate: onRegenerate,
          );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: context.l10n.chatUserLabel,
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 560),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceMd,
                vertical: AppConstants.spaceSm + 2,
              ),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusLg),
                  topRight: Radius.circular(AppConstants.radiusLg),
                  bottomLeft: Radius.circular(AppConstants.radiusLg),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: SelectableText(
                message.content,
                style: context.texts.bodyLarge?.copyWith(
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spaceXs),
            Text(
              _formatTime(context, message.createdAt),
              style: context.texts.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssistantBubble extends StatelessWidget {
  const _AssistantBubble({
    required this.message,
    required this.showActions,
    this.onRegenerate,
  });

  final ChatMessage message;
  final bool showActions;
  final VoidCallback? onRegenerate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isFailed = message.isFailed;
    final isEmpty = message.content.trim().isEmpty;

    return Semantics(
      label: context.l10n.chatAssistantLabel,
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: isFailed
                        ? colors.errorContainer
                        : colors.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFailed ? Icons.error_outline : Icons.auto_awesome,
                    size: 17,
                    color: isFailed
                        ? colors.onErrorContainer
                        : colors.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: AppConstants.spaceSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.assistantName,
                        style: context.texts.labelMedium?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (message.isStreaming)
                        AppStreamingBar(label: context.l10n.chatStreaming)
                      else
                        Text(
                          _formatTime(context, message.createdAt),
                          style: context.texts.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spaceSm),
            if (isEmpty && message.isStreaming)
              const AppLoadingIndicator(size: 22)
            else
              MarkdownText(data: message.content),
            if (showActions && !isEmpty && !message.isStreaming) ...[
              const SizedBox(height: AppConstants.spaceXs),
              Row(
                children: [
                  CopyAction(
                    text: message.content,
                    tooltip: context.l10n.chatCopyMessage,
                  ),
                  if (onRegenerate != null)
                    TextButton.icon(
                      onPressed: onRegenerate,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(context.l10n.chatRegenerate),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact, locale-aware clock time used as a message timestamp.
String _formatTime(BuildContext context, DateTime date) {
  final localizations = MaterialLocalizations.of(context);
  final time = TimeOfDay.fromDateTime(date);
  return localizations.formatTimeOfDay(
    time,
    alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
  );
}
