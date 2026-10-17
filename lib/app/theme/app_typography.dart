import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Typography for a Khmer-first interface.
///
/// Noto Sans Khmer (SIL OFL 1.1, bundled in `assets/fonts`) covers Khmer and the
/// Latin letters used in mixed text, so no font fallback gaps appear. Khmer
/// glyphs stack subscripts and diacritics, so line heights are larger than a
/// Latin-only design would use.
abstract final class AppTypography {
  static const String fontFamily = 'NotoSansKhmer';

  static TextTheme textTheme(ColorScheme colors) {
    final base = TextTheme(
      displaySmall: _style(36, FontWeight.w600, AppConstants.khmerLineHeight),
      headlineMedium: _style(28, FontWeight.w600, AppConstants.khmerLineHeight),
      headlineSmall: _style(24, FontWeight.w600, AppConstants.khmerLineHeight),
      titleLarge: _style(20, FontWeight.w600, AppConstants.khmerLineHeight),
      titleMedium: _style(17, FontWeight.w600, AppConstants.khmerLineHeight),
      titleSmall: _style(15, FontWeight.w600, AppConstants.khmerLineHeight),
      bodyLarge: _style(16, FontWeight.w400, AppConstants.khmerLineHeight),
      bodyMedium: _style(15, FontWeight.w400, AppConstants.khmerLineHeight),
      bodySmall: _style(13, FontWeight.w400, AppConstants.khmerLineHeight),
      labelLarge: _style(15, FontWeight.w600, AppConstants.khmerLineHeight),
      labelMedium: _style(13, FontWeight.w500, AppConstants.khmerLineHeight),
      labelSmall: _style(12, FontWeight.w500, AppConstants.khmerLineHeight),
    );

    // Body and label colours are applied by `ThemeData`; only geometry and
    // weight are set here.
    return base.apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
    );
  }

  /// Monospaced style for code inside assistant answers.
  static TextStyle code(ColorScheme colors) => TextStyle(
    fontFamily: 'monospace',
    fontFamilyFallback: const ['Menlo', 'Roboto Mono', 'Courier New'],
    fontSize: 14,
    height: AppConstants.latinLineHeight,
    backgroundColor: colors.surfaceContainerHighest,
  );

  static TextStyle _style(double size, FontWeight weight, double height) =>
      TextStyle(
        fontFamily: fontFamily,
        fontFamilyFallback: _fallbacks,
        fontSize: size,
        fontWeight: weight,
        height: height,
        // Khmer text is denser than Latin; a small letter-spacing keeps
        // stacked clusters legible at small sizes.
        letterSpacing: 0.1,
      );

  static const List<String> _fallbacks = <String>[
    'Noto Sans Khmer',
    'Khmer OS',
    'Sans Serif',
  ];
}
