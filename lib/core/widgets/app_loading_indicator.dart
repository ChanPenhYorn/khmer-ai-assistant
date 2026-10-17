import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Centered progress indicator with an optional status label.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.label, this.size = 28});

  final String? label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    return Semantics(
      liveRegion: true,
      label: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size,
              width: size,
              child: const CircularProgressIndicator(strokeWidth: 2.6),
            ),
            if (label != null) ...[
              const SizedBox(height: AppConstants.spaceMd),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Thin inline progress bar used while the assistant streams a response.
class AppStreamingBar extends StatelessWidget {
  const AppStreamingBar({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LinearProgressIndicator(minHeight: 2),
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.spaceXs),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
