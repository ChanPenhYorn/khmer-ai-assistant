import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/context_extensions.dart';
import 'copy_action.dart';

/// Result panel shared by the assistant tool screens.
///
/// Generated text is shown as selectable, read-only text and is clearly marked
/// as a draft so it is never mistaken for text the user already approved.
class OutputCard extends StatelessWidget {
  const OutputCard({
    super.key,
    required this.label,
    required this.text,
    required this.placeholder,
    this.onClear,
    this.draftNotice,
    this.minHeight = 96,
  });

  final String label;
  final String text;
  final String placeholder;
  final VoidCallback? onClear;

  /// Notice shown under non-empty output. Pass `null` to hide it.
  final String? draftNotice;

  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasText = text.trim().isNotEmpty;
    final draftNotice = this.draftNotice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, size: 18, color: colors.primary),
            const SizedBox(width: AppConstants.spaceSm),
            Expanded(child: Text(label, style: context.texts.titleMedium)),
            if (onClear != null && hasText)
              IconButton(
                tooltip: context.l10n.actionClear,
                onPressed: onClear,
                icon: const Icon(Icons.backspace_outlined, size: 18),
              ),
            CopyAction(text: text),
          ],
        ),
        const SizedBox(height: AppConstants.spaceSm),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: minHeight),
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: SelectableText(
            hasText ? text : placeholder,
            style: hasText
                ? context.texts.bodyLarge
                : context.texts.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
          ),
        ),
        if (hasText && draftNotice != null)
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.spaceSm),
            child: Text(
              draftNotice,
              style: context.texts.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
