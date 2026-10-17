import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Primary action button with a built-in loading state.
///
/// While [isLoading] is true the button is disabled and announces progress, so
/// a slow request can never be submitted twice.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    this.variant = AppButtonVariant.filled,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool expand;
  final AppButtonVariant variant;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final child = _buildChild(context);
    final isEnabled = onPressed != null && !isLoading;

    final button = switch (variant) {
      AppButtonVariant.filled => FilledButton(
        onPressed: isEnabled ? onPressed : null,
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: isEnabled ? onPressed : null,
        child: child,
      ),
    };

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: semanticLabel ?? label,
      child: expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          color: variant == AppButtonVariant.filled
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
        ),
      );
    }
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: AppConstants.spaceSm),
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

enum AppButtonVariant { filled, outlined, text }
