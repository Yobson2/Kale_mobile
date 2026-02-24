import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/providers/network_providers.dart';
import 'package:kale/core/providers/supabase_provider.dart';
import 'package:kale/core/sync/sync_providers.dart';
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
import 'package:kale/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:kale/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_providers.g.dart';

/// Provides the [TransactionsRemoteDataSource].
///
/// Set `USE_MOCK_TRANSACTIONS=true` in `.env` to use mock data for testing.
@riverpod
TransactionsRemoteDataSource transactionsRemoteDataSource(Ref ref) {
  final useMock =
      dotenv.get('USE_MOCK_TRANSACTIONS', fallback: 'false') == 'true';
  if (useMock) return MockTransactionsRemoteDataSource();
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
        (rows) => rows.map((row) => CategoryModel.fromDrift(row).toEntity())
            .toList(),
      );
}

/// Registers the [TransactionsSyncHandler] with the [SyncEngine].
///
/// This provider ensures the handler is registered once. It should be
/// read before using the repository to guarantee sync is wired up.
@riverpod
TransactionsSyncHandler transactionsSyncHandler(Ref ref) {
  final handler = TransactionsSyncHandler(
    remoteDataSource: ref.watch(transactionsRemoteDataSourceProvider),
    localDataSource: ref.watch(transactionsLocalDataSourceProvider),
  );

  // Register with the sync engine so offline mutations get pushed.
  final engine = ref.watch(syncEngineProvider);
  engine.registerHandler(handler);

  return handler;
}

/// Provides the [TransactionsRepository].
///
/// Ensures the sync handler is registered before returning the repository.
@riverpod
TransactionsRepository transactionsRepository(Ref ref) {
  // Ensure sync handler is registered.
  ref.watch(transactionsSyncHandlerProvider);

  return TransactionsRepositoryImpl(
    remoteDataSource: ref.watch(transactionsRemoteDataSourceProvider),
    localDataSource: ref.watch(transactionsLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
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
