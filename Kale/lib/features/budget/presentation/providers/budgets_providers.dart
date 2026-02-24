import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/providers/network_providers.dart';
import 'package:kale/core/providers/supabase_provider.dart';
import 'package:kale/core/sync/sync_providers.dart';

import 'package:kale/features/budget/data/datasources/budgets_local_datasource.dart';
import 'package:kale/features/budget/data/datasources/budgets_remote_datasource.dart';
import 'package:kale/features/budget/data/datasources/budgets_sync_handler.dart';
import 'package:kale/features/budget/data/repositories/budgets_repository_impl.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';
import 'package:kale/features/budget/domain/usecases/create_budget_usecase.dart';
import 'package:kale/features/budget/domain/usecases/delete_budget_usecase.dart';
import 'package:kale/features/budget/domain/usecases/get_active_budget_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgets_providers.g.dart';

// ── Data Sources ────────────────────────────────────────────────

/// Provides the [BudgetsRemoteDataSource].
///
/// Uses mock implementation when `USE_MOCK_BUDGETS=true` in `.env`.
@riverpod
BudgetsRemoteDataSource budgetsRemoteDataSource(Ref ref) {
  final useMock =
      dotenv.get('USE_MOCK_BUDGETS', fallback: 'false') == 'true';
  if (useMock) return MockBudgetsRemoteDataSource();
  return SupabaseBudgetsRemoteDataSource(ref.watch(supabaseClientProvider));
}

/// Provides the [BudgetsLocalDataSource].
@riverpod
BudgetsLocalDataSource budgetsLocalDataSource(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return BudgetsLocalDataSourceImpl(
    budgetsDao: db.budgetsDao,
    budgetCategoriesDao: db.budgetCategoriesDao,
    syncQueueDao: db.syncQueueDao,
  );
}

// ── Sync Handler ────────────────────────────────────────────────

/// Registers the [BudgetsSyncHandler] with the [SyncEngine].
@Riverpod(keepAlive: true)
BudgetsSyncHandler budgetsSyncHandler(Ref ref) {
  final handler = BudgetsSyncHandler(
    remoteDataSource: ref.watch(budgetsRemoteDataSourceProvider),
    localDataSource: ref.watch(budgetsLocalDataSourceProvider),
  );
  ref.watch(syncEngineProvider).registerHandler(handler);
  return handler;
}

// ── Repository ──────────────────────────────────────────────────

/// Provides the [BudgetsRepository].
@riverpod
BudgetsRepository budgetsRepository(Ref ref) {
  // Ensure the sync handler is registered.
  ref.watch(budgetsSyncHandlerProvider);
  final db = ref.watch(appDatabaseProvider);
  return BudgetsRepositoryImpl(
    remoteDataSource: ref.watch(budgetsRemoteDataSourceProvider),
    localDataSource: ref.watch(budgetsLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
    transactionsDao: db.transactionsDao,
  );
}

// ── Streams ─────────────────────────────────────────────────────

/// Watches all budgets reactively from the local database.
@riverpod
Stream<List<Budget>> budgetsStream(Ref ref) {
  final repository = ref.watch(budgetsRepositoryProvider);
  return repository.watchBudgets();
}

/// Provides the currently active budget (with enriched spent amounts).
@riverpod
Future<Budget?> activeBudget(Ref ref) async {
  final repository = ref.watch(budgetsRepositoryProvider);
  final result = await repository.getActiveBudget();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (budget) => budget,
  );
}

// ── Use Cases ───────────────────────────────────────────────────

/// Provides the [CreateBudgetUseCase].
@riverpod
CreateBudgetUseCase createBudgetUseCase(Ref ref) {
  return CreateBudgetUseCase(ref.watch(budgetsRepositoryProvider));
}

/// Provides the [DeleteBudgetUseCase].
@riverpod
DeleteBudgetUseCase deleteBudgetUseCase(Ref ref) {
  return DeleteBudgetUseCase(ref.watch(budgetsRepositoryProvider));
}

/// Provides the [GetActiveBudgetUseCase].
@riverpod
GetActiveBudgetUseCase getActiveBudgetUseCase(Ref ref) {
  return GetActiveBudgetUseCase(ref.watch(budgetsRepositoryProvider));
}
