import 'package:flutter/foundation.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';

/// Domain entity representing a user's savings goal.
///
/// Amounts are integer minor units of the account's base currency. The
/// goal carries no currency of its own; wrap amounts in [Money] with the
/// base currency (see the `*In` getters) to format them.
@immutable
class SavingsGoal {
  /// Creates a [SavingsGoal].
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmountMinor,
    required this.currentAmountMinor,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.deadline,
    this.iconName,
    this.colorHex,
    this.isSynced = true,
  });

  /// Unique identifier (client-generated UUID).
  final String id;

  /// Human-readable name (e.g. "Emergency Fund", "New Laptop").
  final String name;

  /// Target amount, in minor units of the base currency.
  final int targetAmountMinor;

  /// Amount saved so far, in minor units: the sum of the goal's
  /// contributions.
  final int currentAmountMinor;

  /// Optional description.
  final String? description;

  /// Optional deadline for the goal.
  final DateTime? deadline;

  /// Material icon name for display.
  final String? iconName;

  /// Hex color string for display.
  final String? colorHex;

  /// Current status of the goal.
  final SavingsGoalStatus status;

  /// When the goal was created.
  final DateTime createdAt;

  /// When the goal was last updated.
  final DateTime updatedAt;

  /// Whether this goal has been synced to the server.
  final bool isSynced;

  /// The target as [Money] in the account's base [currency].
  Money targetIn(Currency currency) =>
      Money.fromMinorUnits(targetAmountMinor, currency);

  /// The amount saved so far as [Money] in the base [currency].
  Money savedIn(Currency currency) =>
      Money.fromMinorUnits(currentAmountMinor, currency);

  /// What is left to save as [Money] in the base [currency].
  Money remainingIn(Currency currency) =>
      Money.fromMinorUnits(remainingMinor, currency);

  /// What is left to save, in minor units (never negative).
  int get remainingMinor => targetAmountMinor > currentAmountMinor
      ? targetAmountMinor - currentAmountMinor
      : 0;

  /// Progress as a fraction (0.0 to 1.0), for display only.
  double get progress => targetAmountMinor > 0
      ? (currentAmountMinor / targetAmountMinor).clamp(0.0, 1.0)
      : 0.0;

  /// Whether the goal has been fully funded.
  bool get isFullyFunded => currentAmountMinor >= targetAmountMinor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsGoal &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SavingsGoal(id: $id, name: $name, '
      '$currentAmountMinor/$targetAmountMinor)';
}
