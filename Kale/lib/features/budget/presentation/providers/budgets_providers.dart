import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/config/env_provider.dart';
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/providers/supabase_provider.dart';
import 'package:kale/features/budget/data/datasources/budget_categories_local_datasource.dart';
import 'package:kale/features/budget/data/datasources/budget_categories_remote_datasource.dart';
import 'package:kale/features/budget/data/datasources/budget_categories_sync_handler.dart';
import 'package:kale/features/budget/data/datasources/budgets_local_datasource.dart';
import 'package:kale/features/budget/data/datasources/budgets_remote_datasource.dart';
import 'package:kale/features/budget/data/datasources/budgets_sync_handler.dart';
import 'package:kale/features/budget/data/repositories/budgets_repository_impl.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';
import 'package:kale/features/budget/domain/usecases/create_budget_usecase.dart';
import 'package:kale/features/budget/domain/usecases/delete_budget_usecase.dart';
import 'package:kale/features/budget/domain/usecases/get_active_budget_usecase.dart';
import 'package:kale/features/budget/domain/usecases/update_budget_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgets_providers.g.dart';

// ── Data Sources ────────────────────────────────────────────────

/// Provides the [BudgetsRemoteDataSource].
///
/// Uses the in-memory mock when the `USE_MOCK_BUDGETS` define is true.
@riverpod
BudgetsRemoteDataSource budgetsRemoteDataSource(Ref ref) {
  if (ref.watch(envProvider).useMockBudgets) {
    return MockBudgetsRemoteDataSource();
  }
  return SupabaseBudgetsRemoteDataSource(ref.watch(supabaseClientProvider));
}

/// Provides the [BudgetsLocalDataSource].
@riverpod
BudgetsLocalDataSource budgetsLocalDataSource(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return BudgetsLocalDataSourceImpl(
    budgetsDao: db.budgetsDao,
    syncQueueDao: db.syncQueueDao,
  );
}

/// Provides the [BudgetCategoriesRemoteDataSource]; mocked with budgets
/// (`USE_MOCK_BUDGETS`).
@riverpod
BudgetCategoriesRemoteDataSource budgetCategoriesRemoteDataSource(Ref ref) {
  if (ref.watch(envProvider).useMockBudgets) {
    return MockBudgetCategoriesRemoteDataSource();
  }
  return SupabaseBudgetCategoriesRemoteDataSource(
    ref.watch(supabaseClientProvider),
  );
}

/// Provides the [BudgetCategoriesLocalDataSource].
@riverpod
BudgetCategoriesLocalDataSource budgetCategoriesLocalDataSource(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return BudgetCategoriesLocalDataSourceImpl(
    budgetCategoriesDao: db.budgetCategoriesDao,
    syncQueueDao: db.syncQueueDao,
  );
}

// ── Sync Handler ────────────────────────────────────────────────

/// Provides the [BudgetsSyncHandler].
///
/// Registered with the sync engine through `syncHandlersProvider`.
@Riverpod(keepAlive: true)
BudgetsSyncHandler budgetsSyncHandler(Ref ref) {
  return BudgetsSyncHandler(
    remoteDataSource: ref.watch(budgetsRemoteDataSourceProvider),
    localDataSource: ref.watch(budgetsLocalDataSourceProvider),
  );
}

/// Provides the [BudgetCategoriesSyncHandler].
///
/// Registered with the sync engine through `syncHandlersProvider`.
@Riverpod(keepAlive: true)
BudgetCategoriesSyncHandler budgetCategoriesSyncHandler(Ref ref) {
  return BudgetCategoriesSyncHandler(
    remoteDataSource: ref.watch(budgetCategoriesRemoteDataSourceProvider),
    localDataSource: ref.watch(budgetCategoriesLocalDataSourceProvider),
  );
}

// ── Repository ──────────────────────────────────────────────────

/// Provides the [BudgetsRepository].
@riverpod
BudgetsRepository budgetsRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return BudgetsRepositoryImpl(
    localDataSource: ref.watch(budgetsLocalDataSourceProvider),
    categoriesLocalDataSource:
        ref.watch(budgetCategoriesLocalDataSourceProvider),
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
  final result = await repository.getActiveBudget(today: CalendarDate.today());
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

/// Provides the [UpdateBudgetUseCase].
@riverpod
UpdateBudgetUseCase updateBudgetUseCase(Ref ref) {
  return UpdateBudgetUseCase(ref.watch(budgetsRepositoryProvider));
}

/// Provides the [GetActiveBudgetUseCase].
@riverpod
GetActiveBudgetUseCase getActiveBudgetUseCase(Ref ref) {
  return GetActiveBudgetUseCase(ref.watch(budgetsRepositoryProvider));
}
