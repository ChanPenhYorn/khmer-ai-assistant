import 'package:flutter/material.dart';

/// Brand palette.
///
/// Deliberately restrained: one accent family, neutral surfaces, no gradients.
/// Colour is used to communicate state, not decoration.
abstract final class AppColors {
  /// Seed colour: a calm teal that reads well behind gold-tinted Khmer text.
  static const Color seed = Color(0xFF11635B);

  /// Secondary accent used sparingly (selected chips, links).
  static const Color accent = Color(0xFFB3822F);

  /// Semantic colours for message states.
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFF9A6400);
  static const Color danger = Color(0xFFB3261E);

  static ColorScheme lightScheme() => ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  );

  static ColorScheme darkScheme() => ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );
}
