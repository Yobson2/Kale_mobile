import 'package:flutter/material.dart';

/// Finance-themed illustration for each onboarding step featuring
/// contextual floating elements and concentric circles.
class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({
    required this.stepIndex,
    super.key,
  });

  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final container = theme.colorScheme.primaryContainer;
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer soft circle (preserved from original design).
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: container.withValues(alpha: isDark ? 0.2 : 0.4),
            ),
          ),
          // Inner circle.
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: container.withValues(alpha: isDark ? 0.4 : 0.7),
            ),
          ),
          // Step icon in the center.
          Icon(
            _iconForStep,
            size: 64,
            color: primary,
          ),
          // Floating decorative elements.
          ..._buildFloatingElements(primary, isDark),
        ],
      ),
    );
  }

  IconData get _iconForStep => switch (stepIndex) {
        0 => Icons.account_balance_wallet_rounded,
        1 => Icons.bar_chart_rounded,
        2 => Icons.flag_rounded,
        _ => Icons.account_balance_wallet_rounded,
      };

  List<Widget> _buildFloatingElements(Color primary, bool isDark) =>
      switch (stepIndex) {
        0 => [
            Positioned(
              top: 18,
              right: 28,
              child: _FloatingBubble(
                icon: Icons.receipt_long_rounded,
                iconSize: 22,
                color: primary,
                isDark: isDark,
              ),
            ),
            Positioned(
              bottom: 32,
              left: 22,
              child: _FloatingBubble(
                icon: Icons.trending_up_rounded,
                iconSize: 20,
                color: primary,
                isDark: isDark,
              ),
            ),
            Positioned(
              top: 55,
              left: 42,
              child: _Dot(
                color: primary.withValues(alpha: 0.3),
                size: 10,
              ),
            ),
          ],
        1 => [
            Positioned(
              top: 22,
              left: 32,
              child: _FloatingBubble(
                icon: Icons.bar_chart_rounded,
                iconSize: 22,
                color: primary,
                isDark: isDark,
              ),
            ),
            Positioned(
              bottom: 28,
              right: 28,
              child: _FloatingBubble(
                icon: Icons.notifications_active_rounded,
                iconSize: 20,
                color: primary,
                isDark: isDark,
              ),
            ),
            Positioned(
              bottom: 52,
              left: 48,
              child: _Dot(
                color: primary.withValues(alpha: 0.25),
                size: 8,
              ),
            ),
          ],
        2 => [
            Positioned(
              top: 18,
              right: 32,
              child: _FloatingBubble(
                icon: Icons.flag_rounded,
                iconSize: 22,
                color: primary,
                isDark: isDark,
              ),
            ),
            Positioned(
              bottom: 30,
              left: 28,
              child: _FloatingBubble(
                icon: Icons.auto_awesome_rounded,
                iconSize: 20,
                color: primary,
                isDark: isDark,
              ),
            ),
            Positioned(
              top: 52,
              left: 38,
              child: _Dot(
                color: primary.withValues(alpha: 0.3),
                size: 10,
              ),
            ),
          ],
        _ => [],
      };
}

/// A small icon inside a circular bubble with a subtle shadow.
class _FloatingBubble extends StatelessWidget {
  const _FloatingBubble({
    required this.icon,
    required this.iconSize,
    required this.color,
    required this.isDark,
  });

  final IconData icon;
  final double iconSize;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.15) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.1 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}

/// A plain decorative dot.
class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
