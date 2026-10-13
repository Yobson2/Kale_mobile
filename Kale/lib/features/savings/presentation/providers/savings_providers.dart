import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/config/env_provider.dart';
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/providers/network_providers.dart';
import 'package:kale/core/providers/supabase_provider.dart';
import 'package:kale/features/savings/data/datasources/savings_local_datasource.dart';
import 'package:kale/features/savings/data/datasources/savings_remote_datasource.dart';
import 'package:kale/features/savings/data/repositories/savings_repository_impl.dart';
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';
import 'package:kale/features/savings/domain/repositories/savings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'savings_providers.g.dart';

/// Provides the [SavingsRemoteDataSource].
///
/// Uses the in-memory mock when the `USE_MOCK_SAVINGS` define is true.
@riverpod
SavingsRemoteDataSource savingsRemoteDataSource(Ref ref) {
  if (ref.watch(envProvider).useMockSavings) {
    return MockSavingsRemoteDataSource();
  }
  return SupabaseSavingsRemoteDataSource(ref.watch(supabaseClientProvider));
}

/// Provides the [SavingsLocalDataSource].
@riverpod
SavingsLocalDataSource savingsLocalDataSource(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return SavingsLocalDataSourceImpl(
    savingsGoalsDao: db.savingsGoalsDao,
    savingsContributionsDao: db.savingsContributionsDao,
    syncQueueDao: db.syncQueueDao,
  );
}

/// Provides the [SavingsRepository].
@riverpod
SavingsRepository savingsRepository(Ref ref) {
  return SavingsRepositoryImpl(
    remoteDataSource: ref.watch(savingsRemoteDataSourceProvider),
    localDataSource: ref.watch(savingsLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

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
