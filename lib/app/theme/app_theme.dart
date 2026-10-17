import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Central theme configuration for both brightness variants.
abstract final class AppTheme {
  static ThemeData light() => _build(AppColors.lightScheme());

  static ThemeData dark() => _build(AppColors.darkScheme());

  static ThemeData _build(ColorScheme colors) {
    final textTheme = AppTypography.textTheme(colors);
    final isLight = colors.brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.surface,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colors.onSurface,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colors.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.6)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant.withValues(alpha: 0.5),
        space: 1,
        thickness: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppConstants.minTapTarget + 4),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceLg,
            vertical: AppConstants.spaceSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppConstants.minTapTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceMd,
            vertical: AppConstants.spaceSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, AppConstants.minTapTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceMd,
            vertical: AppConstants.spaceSm,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(
            AppConstants.minTapTarget,
            AppConstants.minTapTarget,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? colors.surfaceContainerLowest
            : colors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMd,
          vertical: AppConstants.spaceMd,
        ),
        border: _inputBorder(colors.outlineVariant),
        enabledBorder: _inputBorder(colors.outlineVariant),
        focusedBorder: _inputBorder(colors.primary, width: 1.6),
        errorBorder: _inputBorder(colors.error),
        focusedErrorBorder: _inputBorder(colors.error, width: 1.6),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(color: colors.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceSm,
          vertical: AppConstants.spaceXs,
        ),
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: AppConstants.spaceSm,
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colors.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: colors.surfaceContainerLow,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
        indicatorColor: colors.secondaryContainer,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearMinHeight: 3,
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: textTheme.bodySmall?.copyWith(
          color: colors.onInverseSurface,
        ),
        waitDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        borderSide: BorderSide(color: color, width: width),
      );
}
