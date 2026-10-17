import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'context_extensions.dart';

/// Opens an external link in the platform browser.
///
/// Only `http` and `https` are allowed: assistant output is model-generated, so
/// arbitrary schemes (`tel:`, `file:`, app deep links) are rejected instead of
/// handed to the operating system.
Future<bool> openExternalLink(BuildContext context, String url) async {
  final uri = Uri.tryParse(url.trim());
  final isAllowedScheme =
      uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  if (!isAllowedScheme) {
    context.showSnack(context.l10n.errorInvalidResponse);
    return false;
  }

  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      context.showSnack(context.l10n.errorUnknown);
    }
    return launched;
  } catch (_) {
    if (context.mounted) context.showSnack(context.l10n.errorUnknown);
    return false;
  }
}
