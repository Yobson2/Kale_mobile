import 'package:flutter/foundation.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';

/// Domain entity representing a user's savings goal.
@immutable
class SavingsGoal {
  /// Creates a [SavingsGoal].
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.currencyCode,
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

  /// Target amount to save.
  final double targetAmount;

  /// Amount saved so far.
  final double currentAmount;

  /// ISO 4217 currency code.
  final String currencyCode;

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

  /// Progress as a fraction (0.0 to 1.0).
  double get progress =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  /// Remaining amount to reach the goal.
  double get remaining => (targetAmount - currentAmount).clamp(0.0, targetAmount);

  /// Whether the goal has been fully funded.
  bool get isFullyFunded => currentAmount >= targetAmount;

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
      '${currentAmount.toStringAsFixed(0)}/${targetAmount.toStringAsFixed(0)})';
}
