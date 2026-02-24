import 'package:flutter/material.dart';

/// Box shadow tokens for elevation effects.
///
/// Provides consistent shadow styles for light and dark themes.
class AppShadows {
  const AppShadows._();

  // ── Light Theme Shadows ──────────────────────────────────────

  /// Small shadow for subtle elevation (cards).
  static List<BoxShadow> get smLight => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Medium shadow for elevated components.
  static List<BoxShadow> get mdLight => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  /// Large shadow for floating components (dialogs, sheets).
  static List<BoxShadow> get lgLight => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 32,
          offset: const Offset(0, 16),
        ),
      ];

  // ── Dark Theme Shadows ───────────────────────────────────────

  /// Small shadow (dark).
  static List<BoxShadow> get smDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  /// Medium shadow (dark).
  static List<BoxShadow> get mdDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  /// Large shadow (dark).
  static List<BoxShadow> get lgDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];
}
