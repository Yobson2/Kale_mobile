import 'package:flutter/material.dart';

/// Maps Material icon name strings (as stored in categories) to [IconData].
const Map<String, IconData> categoryIconMap = {
  // Expense categories
  'restaurant': Icons.restaurant,
  'directions_bus': Icons.directions_bus,
  'phone_android': Icons.phone_android,
  'home': Icons.home,
  'electrical_services': Icons.electrical_services,
  'account_balance_wallet': Icons.account_balance_wallet,
  'business_center': Icons.business_center,
  'school': Icons.school,
  'local_hospital': Icons.local_hospital,
  'checkroom': Icons.checkroom,
  'movie': Icons.movie,
  'family_restroom': Icons.family_restroom,
  'volunteer_activism': Icons.volunteer_activism,
  'savings': Icons.savings,
  'money_off': Icons.money_off,
  'spa': Icons.spa,
  'weekend': Icons.weekend,
  'security': Icons.security,
  'more_horiz': Icons.more_horiz,
  // Income categories
  'payments': Icons.payments,
  'storefront': Icons.storefront,
  'laptop': Icons.laptop,
  'trending_up': Icons.trending_up,
  'phone_iphone': Icons.phone_iphone,
  'people': Icons.people,
  'apartment': Icons.apartment,
  'show_chart': Icons.show_chart,
  'account_balance': Icons.account_balance,
  // Fallback
  'category': Icons.category_outlined,
};

/// Resolves a Material icon name string to an [IconData].
IconData resolveCategoryIcon(String? iconName) {
  if (iconName == null) return Icons.category_outlined;
  return categoryIconMap[iconName] ?? Icons.category_outlined;
}

/// Resolves a hex color string to a [Color].
Color resolveCategoryColor(String? hexColor) {
  if (hexColor == null || hexColor.length < 6) return Colors.grey;
  try {
    return Color(int.parse(hexColor, radix: 16));
  } catch (_) {
    return Colors.grey;
  }
}
