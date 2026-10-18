import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/context_extensions.dart';

/// Empty state with an optional list of tappable suggestions.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    this.body,
    this.icon = Icons.chat_bubble_outline,
    this.suggestions = const <String>[],
    this.onSuggestionSelected,
    this.actions = const <Widget>[],
  });

  final String title;
  final String? body;
  final IconData icon;
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionSelected;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final body = this.body;
    final colors = context.colors;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 76,
                width: 76,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 34, color: colors.onPrimaryContainer),
              ),
              const SizedBox(height: AppConstants.spaceMd),
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.texts.titleMedium,
              ),
              if (body != null) ...[
                const SizedBox(height: AppConstants.spaceSm),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: context.texts.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
              if (suggestions.isNotEmpty) ...[
                const SizedBox(height: AppConstants.spaceLg),
                Wrap(
                  spacing: AppConstants.spaceSm,
                  runSpacing: AppConstants.spaceSm,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final suggestion in suggestions)
                      ActionChip(
                        label: Text(
                          suggestion,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: onSuggestionSelected == null
                            ? null
                            : () => onSuggestionSelected!(suggestion),
                      ),
                  ],
                ),
              ],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: AppConstants.spaceLg),
                Wrap(
                  spacing: AppConstants.spaceSm,
                  runSpacing: AppConstants.spaceSm,
                  alignment: WrapAlignment.center,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
