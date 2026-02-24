import 'package:flutter/material.dart';

/// Themed bottom navigation bar item data.
class AppBottomNavItem {
  /// Creates an [AppBottomNavItem].
  const AppBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  /// Default icon.
  final IconData icon;

  /// Icon when selected.
  final IconData activeIcon;

  /// Label text.
  final String label;
}

/// Themed bottom navigation bar.
class AppBottomNav extends StatelessWidget {
  /// Creates an [AppBottomNav].
  const AppBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.items,
    super.key,
  });

  /// Currently selected index.
  final int currentIndex;

  /// Called when an item is tapped.
  final ValueChanged<int> onTap;

  /// Navigation items.
  final List<AppBottomNavItem> items;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              activeIcon: Icon(item.activeIcon),
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}
