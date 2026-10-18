import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../core/constants/app_constants.dart';
import '../utils/context_extensions.dart';
import '../utils/link_launcher.dart';

/// Renders assistant output as Markdown (headings, lists, links, code blocks).
///
/// Long code blocks scroll horizontally instead of overflowing, and Khmer text
/// keeps the taller line height defined in the theme.
class MarkdownText extends StatelessWidget {
  const MarkdownText({super.key, required this.data, this.selectable = true});

  final String data;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final texts = context.texts;

    final sheet = MarkdownStyleSheet.fromTheme(context.theme).copyWith(
      p: texts.bodyLarge,
      h1: texts.headlineSmall,
      h2: texts.titleLarge,
      h3: texts.titleMedium,
      listBullet: texts.bodyLarge,
      code: texts.bodyMedium?.copyWith(
        fontFamily: 'monospace',
        backgroundColor: colors.surfaceContainerHighest,
      ),
      codeblockDecoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      blockquoteDecoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border(left: BorderSide(color: colors.primary, width: 3)),
      ),
      a: texts.bodyLarge?.copyWith(
        color: colors.primary,
        decoration: TextDecoration.underline,
      ),
      blockSpacing: AppConstants.spaceMd,
    );

    return MarkdownBody(
      data: data,
      selectable: selectable,
      styleSheet: sheet,
      softLineBreak: true,
      onTapLink: (text, href, title) {
        if (href == null) return;
        openExternalLink(context, href);
      },
      imageBuilder: (uri, title, alt) =>
          Text(alt ?? uri.toString(), style: texts.bodySmall),
    );
  }
}
