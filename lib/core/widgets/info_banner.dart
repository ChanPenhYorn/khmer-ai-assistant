import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/context_extensions.dart';

/// Severity of an [InfoBanner].
enum InfoBannerTone { info, warning }

/// Persistent informational strip (demo mode, degraded connectivity, notices).
///
/// It is intentionally always visible rather than dismissible: it communicates
/// a property of the running build, not a transient message.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline,
    this.tone = InfoBannerTone.info,
    this.action,
  });

  final String title;
  final String message;
  final IconData icon;
  final InfoBannerTone tone;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (tone) {
      InfoBannerTone.info => (colors.secondaryContainer, colors.onSecondaryContainer),
      InfoBannerTone.warning => (colors.errorContainer, colors.onErrorContainer),
    };

    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
        padding: const EdgeInsets.all(AppConstants.spaceMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: foreground),
            const SizedBox(width: AppConstants.spaceSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.texts.titleSmall?.copyWith(color: foreground),
                  ),
                  const SizedBox(height: AppConstants.spaceXs),
                  Text(
                    message,
                    style: context.texts.bodySmall?.copyWith(color: foreground),
                  ),
                ],
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: AppConstants.spaceSm),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
