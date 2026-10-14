import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/config/env_provider.dart';
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/providers/supabase_provider.dart';
import 'package:kale/features/transactions/data/datasources/transactions_local_datasource.dart';
import 'package:kale/features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:kale/features/transactions/data/datasources/transactions_sync_handler.dart';
import 'package:kale/features/transactions/data/models/category_model.dart';
import 'package:kale/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:kale/features/transactions/domain/entities/category.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:kale/features/transactions/domain/usecases/create_transaction_usecase.dart';
import 'package:kale/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:kale/features/transactions/domain/usecases/export_transactions_csv_usecase.dart';
import 'package:kale/features/transactions/domain/usecases/get_transactions_page_usecase.dart';
import 'package:kale/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:kale/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:kale/features/transactions/domain/usecases/watch_transaction_changes_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_providers.g.dart';

/// Provides the [TransactionsRemoteDataSource].
///
/// Uses the in-memory mock when the `USE_MOCK_TRANSACTIONS` define is true.
@riverpod
TransactionsRemoteDataSource transactionsRemoteDataSource(Ref ref) {
  if (ref.watch(envProvider).useMockTransactions) {
    return MockTransactionsRemoteDataSource();
  }
  return SupabaseTransactionsRemoteDataSource(
    ref.watch(supabaseClientProvider),
  );
}

/// Provides the [TransactionsLocalDataSource].
@riverpod
TransactionsLocalDataSource transactionsLocalDataSource(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TransactionsLocalDataSourceImpl(
    transactionsDao: db.transactionsDao,
    syncQueueDao: db.syncQueueDao,
  );
}

/// Provides a simple categories local data source from the database DAO.
@riverpod
Stream<List<Category>> categoriesStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoriesDao.watchAll().map(
        (rows) =>
            rows.map((row) => CategoryModel.fromDrift(row).toEntity()).toList(),
      );
}

/// Provides the [TransactionsSyncHandler].
///
/// Registered with the sync engine through `syncHandlersProvider`.
@riverpod
TransactionsSyncHandler transactionsSyncHandler(Ref ref) {
  return TransactionsSyncHandler(
    remoteDataSource: ref.watch(transactionsRemoteDataSourceProvider),
    localDataSource: ref.watch(transactionsLocalDataSourceProvider),
  );
}

/// Provides the [TransactionsRepository].
@riverpod
TransactionsRepository transactionsRepository(Ref ref) {
  return TransactionsRepositoryImpl(
    localDataSource: ref.watch(transactionsLocalDataSourceProvider),
  );
}

/// Watches transactions reactively from the repository stream.
@riverpod
Stream<List<Transaction>> transactionsStream(Ref ref) {
  final repository = ref.watch(transactionsRepositoryProvider);
  return repository.watchTransactions();
}

/// Provides the [CreateTransactionUseCase].
@riverpod
CreateTransactionUseCase createTransactionUseCase(Ref ref) {
  return CreateTransactionUseCase(ref.watch(transactionsRepositoryProvider));
}

/// Provides the [UpdateTransactionUseCase].
@riverpod
UpdateTransactionUseCase updateTransactionUseCase(Ref ref) {
  return UpdateTransactionUseCase(ref.watch(transactionsRepositoryProvider));
}

/// Provides the [DeleteTransactionUseCase].
@riverpod
DeleteTransactionUseCase deleteTransactionUseCase(Ref ref) {
  return DeleteTransactionUseCase(ref.watch(transactionsRepositoryProvider));
}

/// Provides the [GetTransactionsUseCase].
@riverpod
GetTransactionsUseCase getTransactionsUseCase(Ref ref) {
  return GetTransactionsUseCase(ref.watch(transactionsRepositoryProvider));
}

/// Provides the [GetTransactionsPageUseCase].
@riverpod
GetTransactionsPageUseCase getTransactionsPageUseCase(Ref ref) {
  return GetTransactionsPageUseCase(ref.watch(transactionsRepositoryProvider));
}

/// Provides the [WatchTransactionChangesUseCase].
@riverpod
WatchTransactionChangesUseCase watchTransactionChangesUseCase(Ref ref) {
  return WatchTransactionChangesUseCase(
    ref.watch(transactionsRepositoryProvider),
  );
}

/// Provides the [ExportTransactionsCsvUseCase].
@riverpod
ExportTransactionsCsvUseCase exportTransactionsCsvUseCase(Ref ref) {
  return ExportTransactionsCsvUseCase(
    ref.watch(transactionsRepositoryProvider),
  );
}
