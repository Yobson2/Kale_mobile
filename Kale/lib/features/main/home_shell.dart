import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';
import 'package:kale/features/dashboard/presentation/widgets/items/nav_item.dart';

/// Shell wrapper for the home section with bottom navigation and center FAB.
class HomeShell extends StatelessWidget {
  /// Creates a [HomeShell].
  const HomeShell({required this.navigationShell, super.key});

  /// GoRouter navigation shell for managing nested routes.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppScaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteNames.addTransactionName),
        backgroundColor:
            isDark ? AppColors.primaryDark : AppColors.primaryLight,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard,
              label: 'Dashboard',
              isActive: navigationShell.currentIndex == 0,
              onTap: () => navigationShell.goBranch(
                0,
                initialLocation: navigationShell.currentIndex == 0,
              ),
            ),
            NavItem(
              icon: Icons.receipt_long_outlined,
              activeIcon: Icons.receipt_long,
              label: 'Transactions',
              isActive: navigationShell.currentIndex == 1,
              onTap: () => navigationShell.goBranch(
                1,
                initialLocation: navigationShell.currentIndex == 1,
              ),
            ),
            const SizedBox(width: 48), // Space for FAB
            NavItem(
              icon: Icons.pie_chart_outline,
              activeIcon: Icons.pie_chart,
              label: 'Budget',
              isActive: navigationShell.currentIndex == 2,
              onTap: () => navigationShell.goBranch(
                2,
                initialLocation: navigationShell.currentIndex == 2,
              ),
            ),
            NavItem(
              icon: Icons.more_horiz,
              activeIcon: Icons.more_horiz,
              label: 'More',
              isActive: navigationShell.currentIndex == 3,
              onTap: () => navigationShell.goBranch(
                3,
                initialLocation: navigationShell.currentIndex == 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
