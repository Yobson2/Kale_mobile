import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/config/env_provider.dart';
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/core/providers/supabase_provider.dart';
import 'package:kale/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:kale/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:kale/features/profile/data/datasources/profile_sync_handler.dart';
import 'package:kale/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:kale/features/profile/domain/repositories/profile_repository.dart';
import 'package:kale/features/profile/domain/usecases/change_base_currency_usecase.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_providers.g.dart';

/// Provides the [ProfileRemoteDataSource].
///
/// Mocked whenever auth is mocked (`USE_MOCK_AUTH`): without a real
/// Supabase user there is no `profiles` row to write.
@Riverpod(keepAlive: true)
ProfileRemoteDataSource profileRemoteDataSource(Ref ref) {
  if (ref.watch(envProvider).useMockAuth) {
    return MockProfileRemoteDataSource();
  }
  return SupabaseProfileRemoteDataSource(ref.watch(supabaseClientProvider));
}

/// Provides the [ProfileLocalDataSource].
@riverpod
ProfileLocalDataSource profileLocalDataSource(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProfileLocalDataSourceImpl(
    profileDao: db.profileDao,
    syncQueueDao: db.syncQueueDao,
  );
}

/// Provides the [ProfileSyncHandler].
///
/// Registered with the sync engine through `syncHandlersProvider`.
@Riverpod(keepAlive: true)
ProfileSyncHandler profileSyncHandler(Ref ref) {
  return ProfileSyncHandler(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    localDataSource: ref.watch(profileLocalDataSourceProvider),
  );
}

/// Provides the [ProfileRepository].
@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(
    localDataSource: ref.watch(profileLocalDataSourceProvider),
  );
}

/// Provides the [ChangeBaseCurrencyUseCase].
@riverpod
ChangeBaseCurrencyUseCase changeBaseCurrencyUseCase(Ref ref) {
  return ChangeBaseCurrencyUseCase(
    profileRepository: ref.watch(profileRepositoryProvider),
    transactionsRepository: ref.watch(transactionsRepositoryProvider),
  );
}

/// Watches the stored base currency; null until the user has chosen one.
@riverpod
Stream<Currency?> storedBaseCurrency(Ref ref) {
  return ref.watch(profileRepositoryProvider).watchBaseCurrency();
}

/// The account's base currency, in which every amount is entered, stored,
/// and shown. Falls back to [defaultBaseCurrency] until one is chosen.
@riverpod
Currency baseCurrency(Ref ref) {
  return ref.watch(storedBaseCurrencyProvider).valueOrNull ??
      defaultBaseCurrency;
}

/// Changes the base currency through [ChangeBaseCurrencyUseCase].
@riverpod
class BaseCurrencyController extends _$BaseCurrencyController {
  @override
  FutureOr<void> build() {}

  /// Requests [currency] as the base currency. Returns
  /// [BaseCurrencyChange.needsRelabelConfirmation] when the account has
  /// transactions and [relabelConfirmed] is false; nothing changes then.
  /// Returns null on failure (the error is in [state]).
  Future<BaseCurrencyChange?> change(
    Currency currency, {
    bool relabelConfirmed = false,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(changeBaseCurrencyUseCaseProvider).call(
          ChangeBaseCurrencyParams(
            currency: currency,
            relabelConfirmed: relabelConfirmed,
          ),
        );
    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (change) {
        state = const AsyncData(null);
        return change;
      },
    );
  }
}
