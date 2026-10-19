import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/content_width.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/skeleton.dart';
import '../providers/chat_providers.dart';

/// Conversation history: open, rename or delete stored conversations.
class ConversationHistoryScreen extends ConsumerWidget {
  const ConversationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationListProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: SafeArea(
        child: ContentWidth(
          padding: EdgeInsets.zero,
          child: conversations.when(
            loading: () => const SkeletonList(),
            error: (error, _) => AppErrorView(
              failure: toAppFailure(error),
              onRetry: () => ref.invalidate(conversationListProvider),
            ),
            data: (items) {
              if (items.isEmpty) {
                return EmptyStateView(
                  title: l10n.historyEmptyTitle,
                  body: l10n.historyEmptyBody,
                  icon: Icons.history_toggle_off,
                  actions: [
                    FilledButton.icon(
                      onPressed: () => context.go(AppRoutes.chat),
                      icon: const Icon(Icons.add_comment_outlined),
                      label: Text(l10n.chatNewConversation),
                    ),
                  ],
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref.refresh(conversationListProvider.future),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.spaceMd,
                    AppConstants.spaceSm,
                    AppConstants.spaceMd,
                    AppConstants.spaceMd + 72,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppConstants.spaceSm),
                  itemBuilder: (context, index) {
                    final summary = items[index];
                    final title = summary.title.trim().isEmpty
                        ? l10n.chatUntitled
                        : summary.title;
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.forum_outlined),
                        title: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${l10n.historyMessageCount(summary.messageCount)} · '
                          '${_formatDate(context, summary.updatedAt)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: PopupMenuButton<_HistoryAction>(
                          icon: Icon(
                            Icons.more_vert,
                            semanticLabel: l10n.historyOpen,
                          ),
                          onSelected: (action) async {
                            switch (action) {
                              case _HistoryAction.open:
                                context.go(AppRoutes.chatFor(summary.id));
                              case _HistoryAction.rename:
                                final renamed = await _askForTitle(
                                  context,
                                  title,
                                );
                                if (renamed != null) {
                                  await ref
                                      .read(chatRepositoryProvider)
                                      .renameConversation(summary.id, renamed);
                                  ref.invalidate(conversationListProvider);
                                }
                              case _HistoryAction.delete:
                                final confirmed = await _confirmDelete(context);
                                if (confirmed) {
                                  await ref
                                      .read(chatRepositoryProvider)
                                      .deleteConversation(summary.id);
                                  ref.invalidate(conversationListProvider);
                                }
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: _HistoryAction.open,
                              child: Text(l10n.historyOpen),
                            ),
                            PopupMenuItem(
                              value: _HistoryAction.rename,
                              child: Text(l10n.historyRename),
                            ),
                            PopupMenuItem(
                              value: _HistoryAction.delete,
                              child: Text(l10n.historyDelete),
                            ),
                          ],
                        ),
                        onTap: () => context.go(AppRoutes.chatFor(summary.id)),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final material = MaterialLocalizations.of(context);
    return material.formatShortDate(date);
  }

  Future<String?> _askForTitle(BuildContext context, String current) async {
    final l10n = context.l10n;
    final controller = TextEditingController(text: current);
    final result = await showDialog<String>(
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
    return (result ?? '').trim().isEmpty ? null : result!.trim();
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
}

enum _HistoryAction { open, rename, delete }
