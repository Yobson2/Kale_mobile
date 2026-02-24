import 'package:flutter/foundation.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';

/// Domain entity representing a transaction category.
@immutable
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    required this.createdAt,
    this.isDefault = true,
    this.sortOrder = 0,
  });

  /// Unique identifier.
  final String id;

  /// Category name.
  final String name;

  /// Material icon name.
  final String icon;

  /// Hex color string.
  final String color;

  /// Whether this is for income, expense, or both.
  final CategoryType type;

  /// Whether this is a system-provided category.
  final bool isDefault;

  /// Display order.
  final int sortOrder;

  /// When the category was created.
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
