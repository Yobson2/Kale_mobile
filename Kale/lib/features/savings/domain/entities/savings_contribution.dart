import 'package:flutter/foundation.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';

/// Domain entity representing a contribution to a savings goal.
@immutable
class SavingsContribution {
  /// Creates a [SavingsContribution].
  const SavingsContribution({
    required this.id,
    required this.goalId,
    required this.amountMinor,
    required this.source,
    required this.date,
    required this.createdAt,
    this.note,
    this.isSynced = true,
  });

  /// Unique identifier (client-generated UUID).
  final String id;

  /// The savings goal this contribution belongs to.
  final String goalId;

  /// Amount contributed, in minor units of the base currency.
  final int amountMinor;

  /// How the contribution was made.
  final ContributionSource source;

  /// Date of the contribution.
  final DateTime date;

  /// Optional note.
  final String? note;

  /// When the contribution was created.
  final DateTime createdAt;

  /// Whether this contribution has been synced to the server.
  final bool isSynced;

  /// The amount as [Money] in the account's base [currency].
  Money amountIn(Currency currency) =>
      Money.fromMinorUnits(amountMinor, currency);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsContribution &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
