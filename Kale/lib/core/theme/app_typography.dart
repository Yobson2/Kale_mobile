import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kale/core/theme/app_colors.dart';

/// Typography tokens using Google Fonts (Inter).
///
/// Follows the "Editorial Authority" design language:
/// - Display/Headline tokens use tight negative letter-spacing (-1% to -2%)
/// - Display tokens use bold weight (w700) for premium print density
/// - Label tokens use semibold (w600) for micro-data and status labels
class AppTypography {
  const AppTypography._();

  static String get _fontFamily => GoogleFonts.inter().fontFamily!;

  // ── Light Text Theme ─────────────────────────────────────────

  /// Light theme text styles.
  static TextTheme get lightTextTheme => TextTheme(
        displayLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 56,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.12, // -2%
          color: AppColors.textPrimaryLight,
        ),
        displayMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.9, // -2%
          color: AppColors.textPrimaryLight,
        ),
        displaySmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.36, // -1%
          color: AppColors.textPrimaryLight,
        ),
        headlineLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.32, // -1%
          color: AppColors.textPrimaryLight,
        ),
        headlineMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.28, // -1%
          color: AppColors.textPrimaryLight,
        ),
        headlineSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.24, // -1%
          color: AppColors.textPrimaryLight,
        ),
        titleLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
        titleMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: AppColors.textPrimaryLight,
        ),
        titleSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppColors.textPrimaryLight,
        ),
        bodyLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: AppColors.textPrimaryLight,
        ),
        bodyMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: AppColors.textPrimaryLight,
        ),
        bodySmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: AppColors.textSecondaryLight,
        ),
        labelLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppColors.textPrimaryLight,
        ),
        labelMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.textSecondaryLight,
        ),
        labelSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.65, // 0.15em for uppercase micro-data
          color: AppColors.textSecondaryLight,
        ),
      );

  // ── Dark Text Theme ──────────────────────────────────────────

  /// Dark theme text styles.
  static TextTheme get darkTextTheme => TextTheme(
        displayLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 56,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.12, // -2%
          color: AppColors.textPrimaryDark,
        ),
        displayMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.9, // -2%
          color: AppColors.textPrimaryDark,
        ),
        displaySmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.36, // -1%
          color: AppColors.textPrimaryDark,
        ),
        headlineLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.32, // -1%
          color: AppColors.textPrimaryDark,
        ),
        headlineMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.28, // -1%
          color: AppColors.textPrimaryDark,
        ),
        headlineSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.24, // -1%
          color: AppColors.textPrimaryDark,
        ),
        titleLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        titleMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: AppColors.textPrimaryDark,
        ),
        titleSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: AppColors.textPrimaryDark,
        ),
        bodySmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: AppColors.textSecondaryDark,
        ),
        labelLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppColors.textPrimaryDark,
        ),
        labelMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.textSecondaryDark,
        ),
        labelSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.65, // 0.15em for uppercase micro-data
          color: AppColors.textSecondaryDark,
        ),
      );
}
