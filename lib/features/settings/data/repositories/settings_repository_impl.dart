import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// [SettingsRepository] backed by shared preferences.
///
/// Preferences are non-sensitive, so plain storage is appropriate here. Secrets
/// use `flutter_secure_storage` instead.
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._preferences);

  static const String themeModeKey = 'settings_theme_mode';
  static const String localeCodeKey = 'settings_locale_code';

  /// Locale codes the app ships translations for.
  static const Set<String> supportedLocaleCodes = {'km', 'en'};

  final SharedPreferences _preferences;

  @override
  AppSettings read() {
    final storedLocale = _preferences.getString(localeCodeKey);
    return AppSettings(
      themeMode: AppThemeMode.fromName(_preferences.getString(themeModeKey)),
      localeCode: supportedLocaleCodes.contains(storedLocale)
          ? storedLocale
          : null,
    );
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) =>
      _preferences.setString(themeModeKey, mode.name);

  @override
  Future<void> setLocaleCode(String? localeCode) async {
    if (localeCode == null || !supportedLocaleCodes.contains(localeCode)) {
      await _preferences.remove(localeCodeKey);
      return;
    }
    await _preferences.setString(localeCodeKey, localeCode);
  }
}
