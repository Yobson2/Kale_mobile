import 'package:flutter/material.dart';

/// Ghost shadow tokens for the Digital Loom design system.
///
/// Shadows feel like a soft glow of light, never a dark smudge.
/// Formula: `0px Ypx Bpx rgba(15, 23, 42, opacity)`.
class AppShadows {
  const AppShadows._();

  // ── Light Theme Ghost Shadows ──────────────────────────────

  /// Small ghost shadow – subtle elevation for cards.
  static List<BoxShadow> get smLight => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  /// Medium ghost shadow – canonical Digital Loom shadow.
  static List<BoxShadow> get mdLight => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.06),
          blurRadius: 40,
          offset: const Offset(0, 20),
        ),
      ];

  /// Large ghost shadow – bottom sheets (upward cast).
  static List<BoxShadow> get lgLight => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.08),
          blurRadius: 40,
          offset: const Offset(0, -8),
        ),
      ];

  /// Glass shadow – minimal shadow for glassmorphic elements.
  static List<BoxShadow> get glassLight => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.03),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  // ── Dark Theme Ghost Shadows ───────────────────────────────

  /// Small ghost shadow (dark).
  static List<BoxShadow> get smDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  /// Medium ghost shadow (dark).
  static List<BoxShadow> get mdDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.20),
          blurRadius: 40,
          offset: const Offset(0, 20),
        ),
      ];

  /// Large ghost shadow (dark).
  static List<BoxShadow> get lgDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 40,
          offset: const Offset(0, -8),
        ),
      ];

  /// Glass shadow (dark).
  static List<BoxShadow> get glassDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];
}
