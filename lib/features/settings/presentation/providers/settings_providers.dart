import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/preferences_providers.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepositoryImpl(ref.watch(sharedPreferencesProvider));

/// Current preferences. Synchronous: values are read from storage once, before
/// the first frame.
@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).read();

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await ref.read(settingsRepositoryProvider).setThemeMode(mode);
  }

  Future<void> setLocaleCode(String? localeCode) async {
    state = state.copyWith(localeCode: localeCode);
    await ref.read(settingsRepositoryProvider).setLocaleCode(localeCode);
  }
}

/// Locale passed to `MaterialApp`.
///
/// Falls back to Khmer when the system language is not translated, because the
/// product is Khmer-first.
@Riverpod(keepAlive: true)
Locale appLocale(Ref ref) {
  final preferred = ref.watch(settingsControllerProvider).localeCode;
  if (preferred != null) return Locale(preferred);

  final systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
  for (final locale in systemLocales) {
    if (SettingsRepositoryImpl.supportedLocaleCodes.contains(
      locale.languageCode,
    )) {
      return Locale(locale.languageCode);
    }
  }
  return const Locale(AppConstants.kmLanguageCode);
}

/// Language code sent with AI requests so answers match the interface.
@Riverpod(keepAlive: true)
String contentLanguageCode(Ref ref) =>
    ref.watch(appLocaleProvider).languageCode;

/// Appearance preference resolved for `MaterialApp`.
@Riverpod(keepAlive: true)
AppThemeMode appThemeMode(Ref ref) =>
    ref.watch(settingsControllerProvider).themeMode;
