import 'package:flutter/foundation.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';

/// Domain entity representing a financial transaction.
@immutable
class Transaction {
  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    required this.paymentMethod,
    required this.currencyCode,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.isRecurring = false,
    this.recurringRuleId,
    this.mobileMoneyProvider,
    this.mobileMoneyRef,
    this.accountId,
    this.isSynced = true,
  });

  /// Client-generated UUID.
  final String id;

  /// Transaction amount (always positive; type determines direction).
  final double amount;

  /// Income, expense, or transfer.
  final TransactionType type;

  /// FK to category.
  final String categoryId;

  /// Optional description/note.
  final String? description;

  /// When the transaction occurred.
  final DateTime date;

  /// How the payment was made.
  final PaymentMethod paymentMethod;

  /// ISO 4217 currency code.
  final String currencyCode;

  /// Whether this is a recurring transaction.
  final bool isRecurring;

  /// FK to recurring rule.
  final String? recurringRuleId;

  /// Mobile money provider name.
  final String? mobileMoneyProvider;

  /// Mobile money transaction reference.
  final String? mobileMoneyRef;

  /// FK to account (future multi-account support).
  final String? accountId;

  /// When the record was created.
  final DateTime createdAt;

  /// When the record was last updated.
  final DateTime updatedAt;

  /// Whether this record has been synced to the server.
  final bool isSynced;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
