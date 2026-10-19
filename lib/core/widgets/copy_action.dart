import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/context_extensions.dart';

/// Copies text to the clipboard and confirms it with a short message.
///
/// Returns `true` when the copy succeeded, so callers can react if needed.
Future<bool> copyToClipboard(BuildContext context, String text) async {
  if (text.trim().isEmpty) return false;
  await Clipboard.setData(ClipboardData(text: text));
  // Fire and forget: feedback must never delay the confirmation.
  unawaited(HapticFeedback.selectionClick());
  if (context.mounted) context.showSnack(context.l10n.chatCopied);
  return true;
}

/// Icon button that copies [text].
class CopyAction extends StatelessWidget {
  const CopyAction({
    super.key,
    required this.text,
    this.tooltip,
    this.iconSize = 18,
    this.dense = false,
  });

  final String text;
  final String? tooltip;
  final double iconSize;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final label = tooltip ?? context.l10n.actionCopy;
    return Tooltip(
      message: label,
      child: IconButton(
        onPressed: text.trim().isEmpty
            ? null
            : () => copyToClipboard(context, text),
        icon: Icon(Icons.copy_rounded, size: iconSize),
        visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
        iconSize: iconSize,
        tooltip: label,
      ),
    );
  }
}
