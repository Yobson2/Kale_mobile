import 'package:flutter/material.dart';

/// Semantic color tokens for the design system.
///
/// All widgets reference these tokens instead of hardcoded colors.
/// Supports both light and dark themes.
class AppColors {
  const AppColors._();

  // ── Light Theme ──────────────────────────────────────────────

  /// Primary brand color.
  static const Color primaryLight = Color(0xFF10B981);

  /// Primary variant for containers/backgrounds.
  static const Color primaryContainerLight = Color(0xFFD1FAE5);

  /// Secondary accent color.
  static const Color secondaryLight = Color(0xFF10B981);

  /// Secondary container.
  static const Color secondaryContainerLight = Color(0xFFD1FAE5);

  /// Error / destructive color.
  static const Color errorLight = Color(0xFFEF4444);

  /// Error container.
  static const Color errorContainerLight = Color(0xFFFEE2E2);

  /// Warning color.
  static const Color warningLight = Color(0xFFF59E0B);

  /// Success color.
  static const Color successLight = Color(0xFF10B981);

  /// Info color.
  static const Color infoLight = Color(0xFF3B82F6);

  /// Main background.
  static const Color backgroundLight = Color(0xFFF8FAFC);

  /// Surface (cards, sheets).
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// On-primary (text/icons on primary).
  static const Color onPrimaryLight = Color(0xFFFFFFFF);

  /// On-surface (text/icons on surface).
  static const Color onSurfaceLight = Color(0xFF1E293B);

  /// Primary text color.
  static const Color textPrimaryLight = Color(0xFF0F172A);

  /// Secondary text color.
  static const Color textSecondaryLight = Color(0xFF64748B);

  /// Disabled text / hint color.
  static const Color textDisabledLight = Color(0xFF94A3B8);

  /// Border color.
  static const Color borderLight = Color(0xFFE2E8F0);

  /// Divider color.
  static const Color dividerLight = Color(0xFFF1F5F9);

  // ── Dark Theme ───────────────────────────────────────────────

  /// Primary brand color (dark).
  static const Color primaryDark = Color(0xFF34D399);

  /// Primary container (dark).
  static const Color primaryContainerDark = Color(0xFF064E3B);

  /// Secondary accent (dark).
  static const Color secondaryDark = Color(0xFF34D399);

  /// Secondary container (dark).
  static const Color secondaryContainerDark = Color(0xFF064E3B);

  /// Error (dark).
  static const Color errorDark = Color(0xFFF87171);

  /// Error container (dark).
  static const Color errorContainerDark = Color(0xFF7F1D1D);

  /// Warning (dark).
  static const Color warningDark = Color(0xFFFBBF24);

  /// Success (dark).
  static const Color successDark = Color(0xFF34D399);

  /// Info (dark).
  static const Color infoDark = Color(0xFF60A5FA);

  /// Background (dark).
  static const Color backgroundDark = Color(0xFF0F172A);

  /// Surface (dark).
  static const Color surfaceDark = Color(0xFF1E293B);

  /// On-primary (dark).
  static const Color onPrimaryDark = Color(0xFF064E3B);

  /// On-surface (dark).
  static const Color onSurfaceDark = Color(0xFFF1F5F9);

  /// Primary text (dark).
  static const Color textPrimaryDark = Color(0xFFF8FAFC);

  /// Secondary text (dark).
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  /// Disabled text (dark).
  static const Color textDisabledDark = Color(0xFF475569);

  /// Border (dark).
  static const Color borderDark = Color(0xFF334155);

  /// Divider (dark).
  static const Color dividerDark = Color(0xFF1E293B);

  // ── Finance-Specific Colors ─────────────────────────────────

  /// Income color (green).
  static const Color incomeLight = Color(0xFF22C55E);
  static const Color incomeDark = Color(0xFF4ADE80);

  /// Expense color (red).
  static const Color expenseLight = Color(0xFFEF4444);
  static const Color expenseDark = Color(0xFFF87171);

  /// Budget color (amber).
  static const Color budgetLight = Color(0xFFF59E0B);
  static const Color budgetDark = Color(0xFFFBBF24);

  /// Savings color (blue).
  static const Color savingsLight = Color(0xFF3B82F6);
  static const Color savingsDark = Color(0xFF60A5FA);

  // ── Mascot Colors (Kai the Chameleon) ─────────────────────

  /// Kai's primary body color.
  static const Color kaiBody = Color(0xFF10B981);

  /// Kai's lighter belly color.
  static const Color kaiBelly = Color(0xFFD1FAE5);

  /// Kai's head crest / deep teal.
  static const Color kaiCrest = Color(0xFF064E3B);

  /// Kai's eye color (amber-gold).
  static const Color kaiEye = Color(0xFFF59E0B);

  /// Kai's Adinkra / Ndebele markings accent.
  static const Color kaiMarkings = Color(0xFF065F46);

  /// Kai's wristband blue accent.
  static const Color kaiAccentBlue = Color(0xFF3B82F6);

  // ── Savanna Sunset Palette (warm variant for marketing) ───

  /// Warm gold secondary.
  static const Color savannaGold = Color(0xFFD97706);

  /// Sunset orange accent.
  static const Color savannaSunset = Color(0xFFEA580C);

  /// Savanna sand neutral.
  static const Color savannaSand = Color(0xFFD4A574);

  /// Warm cream background.
  static const Color savannaWarmWhite = Color(0xFFFFFBF5);

  /// Terracotta red.
  static const Color savannaTerracotta = Color(0xFFDC2626);

  // ── Afrofuture Neon Palette (bold Gen-Z marketing) ────────

  /// Neon mint.
  static const Color afroNeonMint = Color(0xFF6EE7B7);

  /// Deep space background.
  static const Color afroDeepSpace = Color(0xFF020617);

  /// Electric purple accent.
  static const Color afroViolet = Color(0xFF8B5CF6);

  /// Cyber cyan accent.
  static const Color afroCyan = Color(0xFF06B6D4);

  /// Hot pink danger/expense.
  static const Color afroHotPink = Color(0xFFEC4899);
}
