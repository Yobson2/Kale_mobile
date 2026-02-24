import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';

/// Abstract transactions repository defined in the domain layer.
abstract class TransactionsRepository {
  /// Gets transactions with optional filters.
  Future<Either<Failure, List<Transaction>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? categoryId,
    PaymentMethod? paymentMethod,
  });

  /// Watches transactions reactively.
  Stream<List<Transaction>> watchTransactions({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Gets a single transaction by ID.
  Future<Either<Failure, Transaction>> getTransactionById(String id);

  /// Creates a new transaction. Saves locally and queues for sync.
  Future<Either<Failure, Transaction>> createTransaction({
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    required PaymentMethod paymentMethod,
    required String currencyCode,
    String? description,
    String? mobileMoneyProvider,
    String? mobileMoneyRef,
  });

  /// Updates an existing transaction.
  Future<Either<Failure, Transaction>> updateTransaction({
    required String id,
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    required PaymentMethod paymentMethod,
    required String currencyCode,
    String? description,
    String? mobileMoneyProvider,
    String? mobileMoneyRef,
  });

  /// Deletes a transaction.
  Future<Either<Failure, void>> deleteTransaction(String id);

  /// Triggers a full refresh from the server.
  Future<Either<Failure, void>> refreshFromServer();

  /// Gets total amounts grouped by category for a period.
  Future<Either<Failure, Map<String, double>>> getCategoryTotals({
    required DateTime startDate,
    required DateTime endDate,
    TransactionType? type,
  });

  /// Gets the total amount for a period and type.
  Future<Either<Failure, double>> getTotalForPeriod({
    required DateTime startDate,
    required DateTime endDate,
    required TransactionType type,
  });
}
