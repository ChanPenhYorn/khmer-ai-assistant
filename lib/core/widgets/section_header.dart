import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/context_extensions.dart';

/// Section title with an optional trailing action.
///
/// A short accent bar keeps the title anchored without adding a second
/// heading level or colour noise.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.padding = const EdgeInsets.only(
      top: AppConstants.spaceLg,
      bottom: AppConstants.spaceSm,
    ),
  });

  final String title;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppConstants.spaceSm),
          Expanded(child: Text(title, style: context.texts.titleMedium)),
          ?action,
        ],
      ),
    );
  }
}
