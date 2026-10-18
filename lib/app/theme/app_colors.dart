import 'package:flutter/material.dart';

/// Brand palette.
///
/// A warm, friendly scheme built around a calm teal primary and a honeyed
/// amber secondary, sitting on cream-tinted neutral surfaces. Colour still
/// communicates state first; warmth is carried by the surfaces and the
/// secondary accent rather than by decoration.
abstract final class AppColors {
  /// Seed colour: a calm teal that reads well behind gold-tinted Khmer text.
  static const Color seed = Color(0xFF11635B);

  /// Secondary accent used for selected chips, icons and highlights.
  static const Color accent = Color(0xFFB3822F);

  /// Semantic colours for message states.
  static const Color success = Color(0xFF2F7D4F);
  static const Color warning = Color(0xFF9A6400);
  static const Color danger = Color(0xFFB3261E);

  static ColorScheme lightScheme() {
    final base = ColorScheme.fromSeed(seedColor: seed);
    return base.copyWith(
      primary: const Color(0xFF0E6B5C),
      primaryContainer: const Color(0xFFC9EDE3),
      onPrimaryContainer: const Color(0xFF043029),
      secondary: const Color(0xFF8A5A12),
      onSecondary: const Color(0xFFFFFFFF),
      secondaryContainer: const Color(0xFFFBE3BC),
      onSecondaryContainer: const Color(0xFF3B2604),
      tertiary: const Color(0xFF9A4A1E),
      onTertiary: const Color(0xFFFFFFFF),
      tertiaryContainer: const Color(0xFFFFDCC6),
      onTertiaryContainer: const Color(0xFF371200),
      error: const Color(0xFFB3261E),
      onError: const Color(0xFFFFFFFF),
      errorContainer: const Color(0xFFF9DEDC),
      onErrorContainer: const Color(0xFF410E0B),
      surface: const Color(0xFFFDFBF7),
      onSurface: const Color(0xFF1B1B17),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFF7F3EB),
      surfaceContainer: const Color(0xFFF1ECE1),
      surfaceContainerHigh: const Color(0xFFEBE4D7),
      surfaceContainerHighest: const Color(0xFFE5DDCE),
      onSurfaceVariant: const Color(0xFF48453C),
      outline: const Color(0xFF7A7567),
      outlineVariant: const Color(0xFFD3CCBC),
      inverseSurface: const Color(0xFF30302B),
      onInverseSurface: const Color(0xFFF3EFE6),
      inversePrimary: const Color(0xFF93D7C4),
    );
  }

  static ColorScheme darkScheme() {
    final base = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );
    return base.copyWith(
      primary: const Color(0xFF93D7C4),
      onPrimary: const Color(0xFF00382F),
      primaryContainer: const Color(0xFF0E5245),
      onPrimaryContainer: const Color(0xFFB0F0DD),
      secondary: const Color(0xFFF0C47F),
      onSecondary: const Color(0xFF3E2B00),
      secondaryContainer: const Color(0xFF5A410F),
      onSecondaryContainer: const Color(0xFFFBE0B4),
      tertiary: const Color(0xFFFFB68F),
      onTertiary: const Color(0xFF54230A),
      tertiaryContainer: const Color(0xFF72361A),
      onTertiaryContainer: const Color(0xFFFFDBC6),
      error: const Color(0xFFF2B8B5),
      onError: const Color(0xFF601410),
      errorContainer: const Color(0xFF8C1D18),
      onErrorContainer: const Color(0xFFF9DEDC),
      surface: const Color(0xFF14130F),
      onSurface: const Color(0xFFEAE6DB),
      surfaceContainerLowest: const Color(0xFF0F0E0A),
      surfaceContainerLow: const Color(0xFF1C1B17),
      surfaceContainer: const Color(0xFF211F1B),
      surfaceContainerHigh: const Color(0xFF2B2A25),
      surfaceContainerHighest: const Color(0xFF36342E),
      onSurfaceVariant: const Color(0xFFCFC7B8),
      outline: const Color(0xFF989082),
      outlineVariant: const Color(0xFF4B473E),
      inverseSurface: const Color(0xFFEAE6DB),
      onInverseSurface: const Color(0xFF1B1B17),
      inversePrimary: const Color(0xFF0E6B5C),
    );
  }
}
