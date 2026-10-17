/// Compile-time application configuration.
///
/// Values are supplied with `--dart-define` (or `--dart-define-from-file`).
/// See `README.md` for the full list. Nothing here is a secret: every value in
/// this file ends up inside the shipped binary.
class AppConfig {
  const AppConfig._();

  /// Human readable product name used for branding and OS-level metadata.
  static const String appName = 'Khmer AI Assistant';

  /// Product name rendered in Khmer by default (see localization ARB files).
  static const String appNameKhmer = 'ជំនួយការ AI ខ្មែរ';

  /// Shown in Settings. Kept in sync with `pubspec.yaml` on release builds via
  /// the `APP_VERSION` define; falls back to the development version.
  static const String version = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '0.1.0',
  );

  /// Maximum number of characters accepted by a single AI request.
  static const int maxInputCharacters = int.fromEnvironment(
    'AI_MAX_INPUT_CHARS',
    defaultValue: 6000,
  );

  /// Whether the app was compiled for a local debug session.
  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
}
