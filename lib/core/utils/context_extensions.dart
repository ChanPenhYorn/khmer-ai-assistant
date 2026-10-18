import 'package:flutter/material.dart';

import '../../app/localization/generated/app_localizations.dart';
import '../constants/app_constants.dart';

/// Convenience accessors used across presentation code.
extension AppContextX on BuildContext {
  /// Localized strings for the active locale.
  AppLocalizations get l10n => AppLocalizations.of(this);

  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get texts => Theme.of(this).textTheme;

  /// `true` when the user has enlarged system text.
  bool get usesLargeText => MediaQuery.textScalerOf(this).scale(1) > 1.3;

  /// Current locale language code, defaulting to Khmer.
  String get languageCode => Localizations.localeOf(this).languageCode.isEmpty
      ? AppConstants.kmLanguageCode
      : Localizations.localeOf(this).languageCode;

  void showSnack(String message) {
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
