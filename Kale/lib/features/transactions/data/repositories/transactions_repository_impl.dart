import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/features/transactions/data/datasources/transactions_local_datasource.dart';
import 'package:kale/features/transactions/data/models/transaction_model.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:uuid/uuid.dart';

/// Offline-first implementation of [TransactionsRepository].
///
/// All mutations are saved locally first and enqueued for background
/// sync via the sync queue. Reads return local data only: they never pull
/// from the server (see `SyncPuller`).
class TransactionsRepositoryImpl implements TransactionsRepository {
  /// Creates a [TransactionsRepositoryImpl].
  const TransactionsRepositoryImpl({
    required TransactionsLocalDataSource localDataSource,
  }) : _local = localDataSource;

  final TransactionsLocalDataSource _local;

  @override
  Future<Either<Failure, Transaction>> createTransaction({
    required int amountMinor,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    required PaymentMethod paymentMethod,
    String? description,
    String? mobileMoneyProvider,
    String? mobileMoneyRef,
  }) async {
    try {
      final now = DateTime.now();
      final id = const Uuid().v4();

      final model = TransactionModel(
        id: id,
        amountMinor: amountMinor,
        type: type.name,
        categoryId: categoryId,
        description: description,
        date: date,
        paymentMethod: paymentMethod.name,
        mobileMoneyProvider: mobileMoneyProvider,
        mobileMoneyRef: mobileMoneyRef,
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );

      // Save locally first.
      await _local.saveTransaction(model);

      // Enqueue for background sync.
      await _local.enqueueSync(
        entityId: id,
        operation: 'create',
        payload: jsonEncode(model.toJson()),
      );

      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction({
    required String id,
    required int amountMinor,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    required PaymentMethod paymentMethod,
    String? description,
    String? mobileMoneyProvider,
    String? mobileMoneyRef,
  }) async {
    try {
      // Fetch existing to preserve server ID and creation timestamp.
      final existing = await _local.getTransactionById(id);

      final model = TransactionModel(
        id: id,
        amountMinor: amountMinor,
        type: type.name,
        categoryId: categoryId,
        description: description,
        date: date,
        paymentMethod: paymentMethod.name,
        isRecurring: existing.isRecurring,
        recurringRuleId: existing.recurringRuleId,
        mobileMoneyProvider: mobileMoneyProvider,
        mobileMoneyRef: mobileMoneyRef,
        accountId: existing.accountId,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      // Save locally.
      await _local.saveTransaction(model);

      // Enqueue for background sync.
      await _local.enqueueSync(
        entityId: id,
        operation: 'update',
        payload: jsonEncode(model.toJson()),
      );

      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, int>> countTransactions() async {
    try {
      return Right(await _local.countTransactions());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      // A delete is a soft delete, synced as an update carrying
      // `deleted_at`.
      final deleted = await _local.deleteTransaction(id, DateTime.now());
      await _local.enqueueSync(
        entityId: id,
        operation: 'update',
        payload: jsonEncode(deleted.toJson()),
      );

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? categoryId,
    PaymentMethod? paymentMethod,
  }) async {
    try {
      final transactions = await _local.getTransactions(
        startDate: startDate,
        endDate: endDate,
        type: type,
        categoryId: categoryId,
        paymentMethod: paymentMethod,
      );

      return Right(transactions);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      final transaction = await _local.getTransactionById(id);
      return Right(transaction);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Stream<List<Transaction>> watchTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _local.watchTransactions(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<Either<Failure, Map<String, int>>> getCategoryTotals({
    required DateTime startDate,
    required DateTime endDate,
    TransactionType? type,
  }) async {
    try {
      final totals = await _local.getCategoryTotals(
        startDate: startDate,
        endDate: endDate,
        type: type,
      );
      return Right(totals);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalForPeriod({
    required DateTime startDate,
    required DateTime endDate,
    required TransactionType type,
  }) async {
    try {
      final total = await _local.getTotalForPeriod(
        startDate: startDate,
        endDate: endDate,
        type: type,
      );
      return Right(total);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
