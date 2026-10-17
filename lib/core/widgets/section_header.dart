import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/context_extensions.dart';

/// Section title with an optional trailing action.
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
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: context.texts.titleMedium),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
