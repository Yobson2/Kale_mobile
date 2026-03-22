import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_typography.dart';

/// Composes [ThemeData] from Digital Loom design tokens for light and dark modes.
///
/// Key design rules applied here:
/// - No 1px solid borders on cards/chips → use surface tier color shifts
/// - Ghost borders (outlineVariant at 15%) for inputs only
/// - Glassmorphism applied per-widget, not globally
class AppTheme {
  const AppTheme._();

  /// Light theme data.
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryLight,
          primaryContainer: AppColors.primaryContainerLight,
          onPrimary: AppColors.onPrimaryLight,
          onPrimaryContainer: AppColors.onPrimaryContainerLight,
          primaryFixed: AppColors.primaryFixedLight,
          primaryFixedDim: AppColors.primaryFixedDimLight,
          secondary: AppColors.secondaryLight,
          secondaryContainer: AppColors.secondaryContainerLight,
          tertiary: AppColors.tertiaryLight,
          tertiaryContainer: AppColors.tertiaryContainerLight,
          onTertiaryContainer: AppColors.onTertiaryContainerLight,
          error: AppColors.errorLight,
          errorContainer: AppColors.errorContainerLight,
          surface: AppColors.surfaceLight,
          surfaceBright: AppColors.surfaceBrightLight,
          surfaceContainerLowest: AppColors.surfaceContainerLowestLight,
          surfaceContainerLow: AppColors.surfaceContainerLowLight,
          surfaceContainer: AppColors.surfaceContainerLight,
          surfaceContainerHigh: AppColors.surfaceContainerHighLight,
          surfaceContainerHighest: AppColors.surfaceContainerHighestLight,
          onSurface: AppColors.onSurfaceLight,
          onSurfaceVariant: AppColors.onSurfaceVariantLight,
          inverseSurface: AppColors.inverseSurfaceLight,
          onInverseSurface: AppColors.inverseOnSurfaceLight,
          outline: AppColors.outlineLight,
          outlineVariant: AppColors.outlineVariantLight,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: AppTypography.lightTextTheme,
        dividerColor: AppColors.dividerLight,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimaryLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: AppTypography.lightTextTheme.titleLarge,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceContainerLowestLight,
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.outlineVariantLight.withValues(alpha: 0.15),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.outlineVariantLight.withValues(alpha: 0.15),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(
              color: AppColors.primaryLight,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.errorLight),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.onPrimaryLight,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
            textStyle: AppTypography.lightTextTheme.labelLarge,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
            side: const BorderSide(color: AppColors.primaryLight),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surfaceContainerLowLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.textSecondaryLight,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceContainerHighLight,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusFull,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.dividerLight,
          thickness: 1,
        ),
      );

  /// Dark theme data.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryDark,
          primaryContainer: AppColors.primaryContainerDark,
          onPrimary: AppColors.onPrimaryDark,
          onPrimaryContainer: AppColors.onPrimaryContainerDark,
          primaryFixed: AppColors.primaryFixedDark,
          primaryFixedDim: AppColors.primaryFixedDimDark,
          secondary: AppColors.secondaryDark,
          secondaryContainer: AppColors.secondaryContainerDark,
          tertiary: AppColors.tertiaryDark,
          tertiaryContainer: AppColors.tertiaryContainerDark,
          onTertiaryContainer: AppColors.onTertiaryContainerDark,
          error: AppColors.errorDark,
          errorContainer: AppColors.errorContainerDark,
          surface: AppColors.surfaceDark,
          surfaceContainerLowest: AppColors.surfaceContainerLowestDark,
          surfaceContainerLow: AppColors.surfaceContainerLowDark,
          surfaceContainer: AppColors.surfaceContainerDark,
          surfaceContainerHigh: AppColors.surfaceContainerHighDark,
          surfaceContainerHighest: AppColors.surfaceContainerHighestDark,
          onSurface: AppColors.onSurfaceDark,
          onSurfaceVariant: AppColors.onSurfaceVariantDark,
          inverseSurface: AppColors.inverseSurfaceDark,
          onInverseSurface: AppColors.inverseOnSurfaceDark,
          outline: AppColors.outlineDark,
          outlineVariant: AppColors.outlineVariantDark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        splashColor: AppColors.primaryDark.withValues(alpha: 0.08),
        highlightColor: AppColors.primaryDark.withValues(alpha: 0.04),
        textTheme: AppTypography.darkTextTheme,
        dividerColor: AppColors.dividerDark,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimaryDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: AppTypography.darkTextTheme.titleLarge,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceContainerLowestDark,
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.outlineVariantDark.withValues(alpha: 0.15),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.outlineVariantDark.withValues(alpha: 0.15),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(
              color: AppColors.primaryDark,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.errorDark),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            foregroundColor: AppColors.onPrimaryDark,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
            textStyle: AppTypography.darkTextTheme.labelLarge,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
            side: const BorderSide(color: AppColors.primaryDark),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surfaceContainerLowDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primaryDark,
          unselectedItemColor: AppColors.textSecondaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceContainerHighDark,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusFull,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.dividerDark,
          thickness: 1,
        ),
      );
}
