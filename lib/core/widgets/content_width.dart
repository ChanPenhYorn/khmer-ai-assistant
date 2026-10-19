import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Centres a single-column layout and caps its width on large screens.
///
/// On phones the child fills the available width with normal page padding. On
/// tablets, web and desktop the column keeps a readable measure and the extra
/// space becomes symmetric margin instead of very long text lines.
class ContentWidth extends StatelessWidget {
  const ContentWidth({
    super.key,
    required this.child,
    this.maxWidth = AppConstants.contentMaxWidth,
    this.padding,
  });

  final Widget child;

  /// Upper bound for the content, excluding [padding].
  final double maxWidth;

  /// Outer padding. Defaults to a compact horizontal inset on phones and a
  /// roomier one once the window is wide enough to centre the column.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedPadding =
            padding ??
            EdgeInsets.symmetric(
              horizontal: constraints.maxWidth >= AppConstants.breakpointMedium
                  ? AppConstants.spaceLg
                  : AppConstants.spaceMd,
            );

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(padding: resolvedPadding, child: child),
          ),
        );
      },
    );
  }
}
