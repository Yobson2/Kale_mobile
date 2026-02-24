import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_typography.dart';

/// Composes [ThemeData] from design tokens for light and dark modes.
class AppTheme {
  const AppTheme._();

  /// Light theme data.
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryLight,
          primaryContainer: AppColors.primaryContainerLight,
          secondary: AppColors.secondaryLight,
          secondaryContainer: AppColors.secondaryContainerLight,
          error: AppColors.errorLight,
          errorContainer: AppColors.errorContainerLight,
          surface: AppColors.surfaceLight,
          onPrimary: AppColors.onPrimaryLight,
          onSurface: AppColors.onSurfaceLight,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: AppTypography.lightTextTheme,
        dividerColor: AppColors.dividerLight,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surfaceLight,
          foregroundColor: AppColors.textPrimaryLight,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTypography.lightTextTheme.titleLarge,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLight,
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(
              color: AppColors.primaryLight,
              width: 2,
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
          color: AppColors.surfaceLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
            side: const BorderSide(color: AppColors.borderLight),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceLight,
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.textSecondaryLight,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceLight,
          side: const BorderSide(color: AppColors.borderLight),
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
          secondary: AppColors.secondaryDark,
          secondaryContainer: AppColors.secondaryContainerDark,
          error: AppColors.errorDark,
          errorContainer: AppColors.errorContainerDark,
          surface: AppColors.surfaceDark,
          onPrimary: AppColors.onPrimaryDark,
          onSurface: AppColors.onSurfaceDark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: AppTypography.darkTextTheme,
        dividerColor: AppColors.dividerDark,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surfaceDark,
          foregroundColor: AppColors.textPrimaryDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTypography.darkTextTheme.titleLarge,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceDark,
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(color: AppColors.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusMd,
            borderSide: const BorderSide(
              color: AppColors.primaryDark,
              width: 2,
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
          color: AppColors.surfaceDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
            side: const BorderSide(color: AppColors.borderDark),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceDark,
          selectedItemColor: AppColors.primaryDark,
          unselectedItemColor: AppColors.textSecondaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceDark,
          side: const BorderSide(color: AppColors.borderDark),
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
