import 'package:flutter/material.dart';

/// Appearance preference.
enum AppThemeMode {
  system,
  light,
  dark;

  ThemeMode get themeMode => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };

  static AppThemeMode fromName(String? name) => switch (name) {
    'light' => AppThemeMode.light,
    'dark' => AppThemeMode.dark,
    _ => AppThemeMode.system,
  };
}

/// User-controlled preferences that are not sensitive.
@immutable
class AppSettings {
  const AppSettings({this.themeMode = AppThemeMode.system, this.localeCode});

  static const AppSettings defaults = AppSettings();

  final AppThemeMode themeMode;

  /// `null` means "follow the system language".
  final String? localeCode;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    Object? localeCode = _unset,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    localeCode: identical(localeCode, _unset)
        ? this.localeCode
        : localeCode as String?,
  );

  static const Object _unset = Object();

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.themeMode == themeMode &&
      other.localeCode == localeCode;

  @override
  int get hashCode => Object.hash(themeMode, localeCode);
}
