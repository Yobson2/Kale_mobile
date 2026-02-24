import 'package:flutter/foundation.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';

/// Domain entity representing a contribution to a savings goal.
@immutable
class SavingsContribution {
  /// Creates a [SavingsContribution].
  const SavingsContribution({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.source,
    required this.date,
    required this.createdAt,
    this.note,
  });

  /// Unique identifier (client-generated UUID).
  final String id;

  /// The savings goal this contribution belongs to.
  final String goalId;

  /// Amount contributed.
  final double amount;

  /// How the contribution was made.
  final ContributionSource source;

  /// Date of the contribution.
  final DateTime date;

  /// Optional note.
  final String? note;

  /// When the contribution was created.
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsContribution &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
