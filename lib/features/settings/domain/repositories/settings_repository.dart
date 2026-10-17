import '../entities/app_settings.dart';

/// Contract for reading and writing user preferences.
abstract interface class SettingsRepository {
  /// Current preferences. Synchronous because storage is available at startup.
  AppSettings read();

  Future<void> setThemeMode(AppThemeMode mode);

  /// Persists the interface language. `null` follows the system language.
  Future<void> setLocaleCode(String? localeCode);
}
