import 'package:flutter/material.dart';

/// Semantic color tokens for the Digital Loom design system.
///
/// All widgets reference these tokens instead of hardcoded colors.
/// Supports both light and dark themes.
///
/// Depth is achieved through surface container tiers (lowest → highest),
/// NOT borders. See the "Tonal Layering" section of the design spec.
class AppColors {
  const AppColors._();

  // ── Light Theme ──────────────────────────────────────────────

  /// Primary brand color – dark emerald for high-impact actions.
  static const Color primaryLight = Color(0xFF006C49);

  /// Primary container – lighter emerald for secondary emphasis.
  static const Color primaryContainerLight = Color(0xFF10B981);

  /// On-primary (text/icons on primary).
  static const Color onPrimaryLight = Color(0xFFFFFFFF);

  /// On-primary-container.
  static const Color onPrimaryContainerLight = Color(0xFF002114);

  /// Primary-fixed – bright mint for accent applications.
  static const Color primaryFixedLight = Color(0xFF6FFBBE);

  /// Primary-fixed-dim.
  static const Color primaryFixedDimLight = Color(0xFF4EDEA3);

  /// Secondary – slate blue-gray.
  static const Color secondaryLight = Color(0xFF565E74);

  /// Secondary container.
  static const Color secondaryContainerLight = Color(0xFFDAE2FD);

  /// Tertiary – warm brown/orange.
  static const Color tertiaryLight = Color(0xFF855300);

  /// Tertiary container – golden orange (budget displays).
  static const Color tertiaryContainerLight = Color(0xFFE29100);

  /// On-tertiary-container.
  static const Color onTertiaryContainerLight = Color(0xFF2C1700);

  /// Error / destructive color.
  static const Color errorLight = Color(0xFFBA1A1A);

  /// Error container.
  static const Color errorContainerLight = Color(0xFFFFDAD6);

  /// Warning color.
  static const Color warningLight = Color(0xFFF59E0B);

  /// Success color.
  static const Color successLight = Color(0xFF10B981);

  /// Info color.
  static const Color infoLight = Color(0xFF3B82F6);

  /// Main background.
  static const Color backgroundLight = Color(0xFFF7F9FB);

  // ── Surface Container Tier System (Light) ─────────────────────
  // Depth achieved by stacking tiers, not floating with shadows.

  /// Surface (base).
  static const Color surfaceLight = Color(0xFFF7F9FB);

  /// Surface bright.
  static const Color surfaceBrightLight = Color(0xFFF7F9FB);

  /// Surface container lowest – cards, sheets (purest white).
  static const Color surfaceContainerLowestLight = Color(0xFFFFFFFF);

  /// Surface container low – one step above background.
  static const Color surfaceContainerLowLight = Color(0xFFF2F4F6);

  /// Surface container – mid tier.
  static const Color surfaceContainerLight = Color(0xFFECEEF0);

  /// Surface container high.
  static const Color surfaceContainerHighLight = Color(0xFFE6E8EA);

  /// Surface container highest.
  static const Color surfaceContainerHighestLight = Color(0xFFE0E3E5);

  /// On-surface – primary text. Never use pure #000000.
  static const Color onSurfaceLight = Color(0xFF191C1E);

  /// On-surface-variant – secondary text.
  static const Color onSurfaceVariantLight = Color(0xFF3C4A42);

  /// Inverse surface.
  static const Color inverseSurfaceLight = Color(0xFF2E3133);

  /// Inverse on-surface.
  static const Color inverseOnSurfaceLight = Color(0xFFEFF1F3);

  /// Primary text color.
  static const Color textPrimaryLight = Color(0xFF0F172A);

  /// Secondary text color.
  static const Color textSecondaryLight = Color(0xFF64748B);

  /// Disabled text / hint color (WCAG AA compliant on light backgrounds).
  static const Color textDisabledLight = Color(0xFF6B7280);

  /// Outline – medium emphasis borders.
  static const Color outlineLight = Color(0xFF6C7A71);

  /// Outline variant – ghost borders at 15% opacity.
  static const Color outlineVariantLight = Color(0xFFBBCABF);

  /// Border color (legacy, prefer outline/outlineVariant).
  static const Color borderLight = Color(0xFFE2E8F0);

  /// Divider color.
  static const Color dividerLight = Color(0xFFF1F5F9);

  // ── Dark Theme ───────────────────────────────────────────────

  /// Primary brand color (dark) – brighter emerald for dark backgrounds.
  static const Color primaryDark = Color(0xFF34D399);

  /// Primary container (dark).
  static const Color primaryContainerDark = Color(0xFF10B981);

  /// On-primary (dark).
  static const Color onPrimaryDark = Color(0xFF003822);

  /// On-primary-container (dark).
  static const Color onPrimaryContainerDark = Color(0xFF6FFBBE);

  /// Primary-fixed (dark).
  static const Color primaryFixedDark = Color(0xFF6FFBBE);

  /// Primary-fixed-dim (dark).
  static const Color primaryFixedDimDark = Color(0xFF4EDEA3);

  /// Secondary accent (dark).
  static const Color secondaryDark = Color(0xFFBEC6E0);

  /// Secondary container (dark).
  static const Color secondaryContainerDark = Color(0xFF3E465B);

  /// Tertiary (dark).
  static const Color tertiaryDark = Color(0xFFFFB951);

  /// Tertiary container (dark).
  static const Color tertiaryContainerDark = Color(0xFFE29100);

  /// On-tertiary-container (dark).
  static const Color onTertiaryContainerDark = Color(0xFFFFDDB8);

  /// Error (dark).
  static const Color errorDark = Color(0xFFF87171);

  /// Error container (dark).
  static const Color errorContainerDark = Color(0xFF93000A);

  /// Warning (dark).
  static const Color warningDark = Color(0xFFFBBF24);

  /// Success (dark).
  static const Color successDark = Color(0xFF34D399);

  /// Info (dark).
  static const Color infoDark = Color(0xFF60A5FA);

  /// Background (dark).
  static const Color backgroundDark = Color(0xFF0F172A);

  // ── Surface Container Tier System (Dark) ──────────────────────

  /// Surface (dark).
  static const Color surfaceDark = Color(0xFF0F172A);

  /// Surface container lowest (dark).
  static const Color surfaceContainerLowestDark = Color(0xFF020617);

  /// Surface container low (dark) – slightly brighter than surface for card lift.
  static const Color surfaceContainerLowDark = Color(0xFF162033);

  /// Surface container (dark).
  static const Color surfaceContainerDark = Color(0xFF1E293B);

  /// Surface container high (dark) – one step above container.
  static const Color surfaceContainerHighDark = Color(0xFF283548);

  /// Surface container highest (dark).
  static const Color surfaceContainerHighestDark = Color(0xFF334155);

  /// On-surface (dark).
  static const Color onSurfaceDark = Color(0xFFF8FAFC);

  /// On-surface-variant (dark).
  static const Color onSurfaceVariantDark = Color(0xFF94A3B8);

  /// Inverse surface (dark).
  static const Color inverseSurfaceDark = Color(0xFFE2E8F0);

  /// Inverse on-surface (dark).
  static const Color inverseOnSurfaceDark = Color(0xFF0F172A);

  /// Primary text (dark).
  static const Color textPrimaryDark = Color(0xFFF8FAFC);

  /// Secondary text (dark).
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  /// Disabled text (dark).
  static const Color textDisabledDark = Color(0xFF475569);

  /// Outline (dark).
  static const Color outlineDark = Color(0xFF8A938E);

  /// Outline variant (dark).
  static const Color outlineVariantDark = Color(0xFF334155);

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

  /// Budget color (golden orange – tertiary).
  static const Color budgetLight = Color(0xFFE29100);
  static const Color budgetDark = Color(0xFFFFB951);

  /// Savings color (blue).
  static const Color savingsLight = Color(0xFF3B82F6);
  static const Color savingsDark = Color(0xFF60A5FA);

  // ── Gradient Helpers ────────────────────────────────────────

  /// Primary gradient (light) – used on hero cards and CTA buttons.
  static const LinearGradient primaryGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primaryContainerLight],
  );

  /// Primary gradient (dark).
  static const LinearGradient primaryGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryContainerDark],
  );

  /// Tertiary gradient (light) – used on budget cards.
  static const LinearGradient tertiaryGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [tertiaryLight, tertiaryContainerLight],
  );

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
