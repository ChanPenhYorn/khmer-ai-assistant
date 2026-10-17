import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_failure.dart';
import '../../core/errors/failure_messages.dart';
import '../../core/utils/context_extensions.dart';
import 'app_button.dart';

/// Friendly, localized error state.
///
/// Technical detail is never rendered: it stays in the debug log.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.failure,
    this.onRetry,
    this.retryLabel,
    this.compact = false,
  });

  final AppFailure failure;

  /// Shown only when the failure can plausibly be retried.
  final VoidCallback? onRetry;
  final String? retryLabel;

  /// Renders a single line instead of a full-page state.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final message = failure.localizedMessage(context.l10n);
    final colors = context.colors;

    if (compact) {
      return Container(
        padding: const EdgeInsets.all(AppConstants.spaceMd),
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline, color: colors.onErrorContainer, size: 20),
            const SizedBox(width: AppConstants.spaceSm),
            Expanded(
              child: Text(
                message,
                style: context.texts.bodyMedium?.copyWith(
                  color: colors.onErrorContainer,
                ),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(retryLabel ?? context.l10n.actionRetry),
              ),
          ],
        ),
      );
    }

    return Semantics(
      liveRegion: true,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spaceLg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off_outlined,
                  size: 44,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(height: AppConstants.spaceMd),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: context.texts.bodyLarge,
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: AppConstants.spaceLg),
                  AppButton(
                    label: retryLabel ?? context.l10n.actionRetry,
                    icon: Icons.refresh,
                    onPressed: onRetry,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
