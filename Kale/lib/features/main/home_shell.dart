import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/dashboard/presentation/widgets/items/nav_item.dart';

/// Shell wrapper for the home section with glassmorphic bottom navigation
/// and gradient center FAB.
class HomeShell extends ConsumerWidget {
  /// Creates a [HomeShell].
  const HomeShell({required this.navigationShell, super.key});

  /// GoRouter navigation shell for managing nested routes.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final isGuest = ref.watch(authNotifierProvider) is AuthGuest;

    return AppScaffold(
      body: Column(
        children: [
          if (isGuest) _GuestBanner(colorScheme: colorScheme),
          Expanded(child: navigationShell),
        ],
      ),
      floatingActionButton: _GradientFAB(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.pushNamed(RouteNames.addTransactionName);
        },
        colorScheme: colorScheme,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _GlassBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: navigationShell.currentIndex == index,
        ),
      ),
    );
  }
}

/// Glassmorphic bottom navigation bar with backdrop blur.
class _GlassBottomNav extends StatelessWidget {
  const _GlassBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isDark = context.isDark;
    final bottomPadding = context.bottomPadding;

    return ClipRRect(
      borderRadius: AppRadius.borderRadiusTopXl,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surface.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: AppRadius.borderRadiusTopXl,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: AppSpacing.md,
            bottom: bottomPadding + AppSpacing.sm,
          ),
          child: Row(
            children: [
              _buildNavItem(
                context,
                index: 0,
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                label: context.l10n.navDashboard,
              ),
              _buildNavItem(
                context,
                index: 1,
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: context.l10n.navTransactions,
              ),
              const SizedBox(width: 56), // Space for center FAB
              _buildNavItem(
                context,
                index: 2,
                icon: Icons.pie_chart_outline,
                activeIcon: Icons.pie_chart,
                label: context.l10n.navBudget,
              ),
              _buildNavItem(
                context,
                index: 3,
                icon: Icons.more_horiz,
                activeIcon: Icons.more_horiz,
                label: context.l10n.navMore,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    return Expanded(
      child: NavItem(
        icon: icon,
        activeIcon: activeIcon,
        label: label,
        isActive: currentIndex == index,
        onTap: () => onTap(index),
      ),
    );
  }
}

/// Gradient floating action button.
class _GradientFAB extends StatelessWidget {
  const _GradientFAB({
    required this.onPressed,
    required this.colorScheme,
  });

  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Icon(
            Icons.add,
            color: colorScheme.onPrimary,
            size: 28,
          ),
        ),
      ),
    );
  }
}

/// Guest mode banner encouraging sign-up.
class _GuestBanner extends StatelessWidget {
  const _GuestBanner({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            color: colorScheme.onSurfaceVariant,
          ),
          AppSpacing.horizontalMd,
          Expanded(
            child: Text(
              context.l10n.guestBannerMessage,
              style: context.textTheme.bodySmall,
            ),
          ),
          AppSpacing.horizontalSm,
          TextButton(
            onPressed: () => context.go(RouteNames.register),
            child: Text(context.l10n.guestBannerAction),
          ),
        ],
      ),
    );
  }
}
