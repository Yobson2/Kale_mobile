import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/config/env_provider.dart';
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/providers/network_providers.dart';
import 'package:kale/core/providers/supabase_provider.dart';
import 'package:kale/features/savings/data/datasources/savings_contributions_local_datasource.dart';
import 'package:kale/features/savings/data/datasources/savings_contributions_remote_datasource.dart';
import 'package:kale/features/savings/data/datasources/savings_contributions_sync_handler.dart';
import 'package:kale/features/savings/data/datasources/savings_goals_sync_handler.dart';
import 'package:kale/features/savings/data/datasources/savings_local_datasource.dart';
import 'package:kale/features/savings/data/datasources/savings_remote_datasource.dart';
import 'package:kale/features/savings/data/repositories/savings_repository_impl.dart';
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';
import 'package:kale/features/savings/domain/repositories/savings_repository.dart';
import 'package:kale/features/savings/domain/usecases/contribute_to_goal_usecase.dart';
import 'package:kale/features/savings/domain/usecases/create_savings_goal_usecase.dart';
import 'package:kale/features/savings/domain/usecases/delete_savings_goal_usecase.dart';
import 'package:kale/features/savings/domain/usecases/update_savings_goal_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'savings_providers.g.dart';

// ── Data Sources ────────────────────────────────────────────────

/// Provides the [SavingsRemoteDataSource] (goals).
///
/// Uses the in-memory mock when the `USE_MOCK_SAVINGS` define is true.
@riverpod
SavingsRemoteDataSource savingsRemoteDataSource(Ref ref) {
  if (ref.watch(envProvider).useMockSavings) {
    return MockSavingsRemoteDataSource();
  }
  return SupabaseSavingsRemoteDataSource(ref.watch(supabaseClientProvider));
}

/// Provides the [SavingsContributionsRemoteDataSource].
///
/// Uses the in-memory mock when the `USE_MOCK_SAVINGS` define is true.
@riverpod
SavingsContributionsRemoteDataSource savingsContributionsRemoteDataSource(
  Ref ref,
) {
  if (ref.watch(envProvider).useMockSavings) {
    return MockSavingsContributionsRemoteDataSource();
  }
  return SupabaseSavingsContributionsRemoteDataSource(
    ref.watch(supabaseClientProvider),
  );
}

/// Provides the [SavingsLocalDataSource] (goals).
@riverpod
SavingsLocalDataSource savingsLocalDataSource(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return SavingsLocalDataSourceImpl(
    savingsGoalsDao: db.savingsGoalsDao,
    savingsContributionsDao: db.savingsContributionsDao,
    syncQueueDao: db.syncQueueDao,
  );
}

/// Provides the [SavingsContributionsLocalDataSource].
@riverpod
SavingsContributionsLocalDataSource savingsContributionsLocalDataSource(
  Ref ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return SavingsContributionsLocalDataSourceImpl(
    savingsContributionsDao: db.savingsContributionsDao,
    syncQueueDao: db.syncQueueDao,
  );
}

// ── Sync Handlers ───────────────────────────────────────────────

/// Provides the [SavingsGoalsSyncHandler].
///
/// Registered with the sync engine through `syncHandlersProvider`.
@Riverpod(keepAlive: true)
SavingsGoalsSyncHandler savingsGoalsSyncHandler(Ref ref) {
  return SavingsGoalsSyncHandler(
    remoteDataSource: ref.watch(savingsRemoteDataSourceProvider),
    localDataSource: ref.watch(savingsLocalDataSourceProvider),
  );
}

/// Provides the [SavingsContributionsSyncHandler].
///
/// Registered with the sync engine through `syncHandlersProvider`.
@Riverpod(keepAlive: true)
SavingsContributionsSyncHandler savingsContributionsSyncHandler(Ref ref) {
  return SavingsContributionsSyncHandler(
    remoteDataSource: ref.watch(savingsContributionsRemoteDataSourceProvider),
    localDataSource: ref.watch(savingsContributionsLocalDataSourceProvider),
  );
}

// ── Repository ──────────────────────────────────────────────────

/// Provides the [SavingsRepository].
@riverpod
SavingsRepository savingsRepository(Ref ref) {
  return SavingsRepositoryImpl(
    remoteDataSource: ref.watch(savingsRemoteDataSourceProvider),
    localDataSource: ref.watch(savingsLocalDataSourceProvider),
    contributionsRemoteDataSource:
        ref.watch(savingsContributionsRemoteDataSourceProvider),
    contributionsLocalDataSource:
        ref.watch(savingsContributionsLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

// ── Use Cases ───────────────────────────────────────────────────

/// Provides the [CreateSavingsGoalUseCase].
@riverpod
CreateSavingsGoalUseCase createSavingsGoalUseCase(Ref ref) =>
    CreateSavingsGoalUseCase(ref.watch(savingsRepositoryProvider));

/// Provides the [UpdateSavingsGoalUseCase].
@riverpod
UpdateSavingsGoalUseCase updateSavingsGoalUseCase(Ref ref) =>
    UpdateSavingsGoalUseCase(ref.watch(savingsRepositoryProvider));

/// Provides the [DeleteSavingsGoalUseCase].
@riverpod
DeleteSavingsGoalUseCase deleteSavingsGoalUseCase(Ref ref) =>
    DeleteSavingsGoalUseCase(ref.watch(savingsRepositoryProvider));

/// Provides the [ContributeToGoalUseCase].
@riverpod
ContributeToGoalUseCase contributeToGoalUseCase(Ref ref) =>
    ContributeToGoalUseCase(ref.watch(savingsRepositoryProvider));

// ── Streams ─────────────────────────────────────────────────────

/// Watches all savings goals reactively.
@riverpod
Stream<List<SavingsGoal>> savingsGoalsStream(Ref ref) {
  final repository = ref.watch(savingsRepositoryProvider);
  return repository.watchSavingsGoals();
}

/// Watches contributions for a specific goal.
@riverpod
Stream<List<SavingsContribution>> savingsContributionsStream(
  Ref ref,
  String goalId,
) {
  final repository = ref.watch(savingsRepositoryProvider);
  return repository.watchContributions(goalId);
}
