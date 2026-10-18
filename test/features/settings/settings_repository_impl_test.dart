import 'package:flutter_test/flutter_test.dart';
import 'package:khmer_ai_assistant/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:khmer_ai_assistant/features/settings/domain/entities/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences preferences;
  late SettingsRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await SharedPreferences.getInstance();
    repository = SettingsRepositoryImpl(preferences);
  });

  test('defaults to system theme and system language', () {
    final settings = repository.read();
    expect(settings.themeMode, AppThemeMode.system);
    expect(settings.localeCode, isNull);
  });

  test('persists the theme mode', () async {
    await repository.setThemeMode(AppThemeMode.dark);
    expect(repository.read().themeMode, AppThemeMode.dark);

    await repository.setThemeMode(AppThemeMode.light);
    expect(repository.read().themeMode, AppThemeMode.light);
  });

  test('persists a supported language', () async {
    await repository.setLocaleCode('en');
    expect(repository.read().localeCode, 'en');
  });

  test('clearing the language returns to the system default', () async {
    await repository.setLocaleCode('en');
    await repository.setLocaleCode(null);
    expect(repository.read().localeCode, isNull);
  });

  test('ignores an unsupported language code', () async {
    await preferences.setString(SettingsRepositoryImpl.localeCodeKey, 'fr');
    expect(repository.read().localeCode, isNull);
  });

  test('recovers from a corrupted theme value', () async {
    await preferences.setString(SettingsRepositoryImpl.themeModeKey, 'neon');
    expect(repository.read().themeMode, AppThemeMode.system);
  });

  test('AppSettings.copyWith keeps values that are not replaced', () {
    const settings = AppSettings(
      themeMode: AppThemeMode.dark,
      localeCode: 'km',
    );
    expect(settings.copyWith().localeCode, 'km');
    expect(settings.copyWith(localeCode: null).localeCode, isNull);
    expect(settings.copyWith(themeMode: AppThemeMode.light).localeCode, 'km');
  });
}
