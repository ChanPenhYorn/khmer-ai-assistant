import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'content_width.dart';

/// Two-pane layout for the focused tool screens.
///
/// Phones stack the input above the result in one scroll view. Once the window
/// reaches [AppConstants.breakpointMedium] the panes sit side by side and
/// scroll independently, which keeps the result visible while the input, tone
/// and language controls stay in reach.
class ToolPanes extends StatelessWidget {
  const ToolPanes({
    super.key,
    required this.inputPane,
    required this.outputPane,
  });

  /// Controls and the source text.
  final List<Widget> inputPane;

  /// Generated result and its notices.
  final List<Widget> outputPane;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppConstants.breakpointMedium) {
          return ContentWidth(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spaceMd,
              AppConstants.spaceMd,
              AppConstants.spaceMd,
              AppConstants.spaceXl,
            ),
            child: ListView(
              children: [
                ...inputPane,
                const SizedBox(height: AppConstants.spaceLg),
                ...outputPane,
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceLg,
            vertical: AppConstants.spaceMd,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppConstants.toolMaxWidth,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _Pane(children: inputPane)),
                  const SizedBox(width: AppConstants.spaceLg),
                  Expanded(child: _Pane(children: outputPane)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Pane extends StatelessWidget {
  const _Pane({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppConstants.spaceXl),
      children: children,
    );
  }
}
