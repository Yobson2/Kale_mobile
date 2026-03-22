import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/dashboard/presentation/widgets/items/nav_item.dart';

/// Shell wrapper for the home section with bottom navigation and center FAB.
class HomeShell extends ConsumerWidget {
  /// Creates a [HomeShell].
  const HomeShell({required this.navigationShell, super.key});

  /// GoRouter navigation shell for managing nested routes.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isGuest = ref.watch(authNotifierProvider) is AuthGuest;

    return AppScaffold(
      body: Column(
        children: [
          if (isGuest)
            MaterialBanner(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              content: Text(context.l10n.guestBannerMessage),
              leading: const Icon(Icons.cloud_off_outlined),
              actions: [
                TextButton(
                  onPressed: () => context.go(RouteNames.register),
                  child: Text(context.l10n.guestBannerAction),
                ),
              ],
            ),
          Expanded(child: navigationShell),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.pushNamed(RouteNames.addTransactionName);
        },
        backgroundColor:
            isDark ? AppColors.primaryDark : AppColors.primaryLight,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          children: [
            Expanded(
              child: NavItem(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                label: context.l10n.navDashboard,
                isActive: navigationShell.currentIndex == 0,
                onTap: () => navigationShell.goBranch(
                  0,
                  initialLocation: navigationShell.currentIndex == 0,
                ),
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: context.l10n.navTransactions,
                isActive: navigationShell.currentIndex == 1,
                onTap: () => navigationShell.goBranch(
                  1,
                  initialLocation: navigationShell.currentIndex == 1,
                ),
              ),
            ),
            const SizedBox(width: 48), // Space for FAB
            Expanded(
              child: NavItem(
                icon: Icons.pie_chart_outline,
                activeIcon: Icons.pie_chart,
                label: context.l10n.navBudget,
                isActive: navigationShell.currentIndex == 2,
                onTap: () => navigationShell.goBranch(
                  2,
                  initialLocation: navigationShell.currentIndex == 2,
                ),
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.more_horiz,
                activeIcon: Icons.more_horiz,
                label: context.l10n.navMore,
                isActive: navigationShell.currentIndex == 3,
                onTap: () => navigationShell.goBranch(
                  3,
                  initialLocation: navigationShell.currentIndex == 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
