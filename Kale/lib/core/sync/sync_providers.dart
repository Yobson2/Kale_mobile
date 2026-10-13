import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/providers/network_providers.dart';
import 'package:kale/core/sync/sync_config.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/core/sync/sync_status.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_providers.g.dart';

/// Retry and backoff settings for the [SyncEngine].
///
/// Overridden in tests to remove backoff delays.
@Riverpod(keepAlive: true)
SyncConfig syncConfig(Ref ref) => const SyncConfig();

/// Every [SyncHandler] in the app, one per syncable entity type.
///
/// Add a feature's handler here when it starts enqueueing a new entity
/// type; `test/core/sync/sync_wiring_test.dart` fails until you do.
@Riverpod(keepAlive: true)
List<SyncHandler> syncHandlers(Ref ref) => [
      ref.watch(transactionsSyncHandlerProvider),
      ref.watch(budgetsSyncHandlerProvider),
      ref.watch(profileSyncHandlerProvider),
    ];

/// Provides the [SyncEngine] singleton, with every handler from
/// [syncHandlers] registered at construction.
@Riverpod(keepAlive: true)
SyncEngine syncEngine(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  final engine = SyncEngine(
    syncQueueDao: db.syncQueueDao,
    networkInfo: networkInfo,
    handlers: ref.watch(syncHandlersProvider),
    config: ref.watch(syncConfigProvider),
  )
    // Push pending changes whenever connectivity returns.
    ..start(
      networkInfo.onConnectivityChanged.map(
        (results) => !results.contains(ConnectivityResult.none),
      ),
    );

  ref.onDispose(engine.dispose);
  return engine;
}

/// Streams the current [SyncStatus] for UI widgets.
@riverpod
Stream<SyncStatus> syncStatus(Ref ref) {
  final engine = ref.watch(syncEngineProvider);
  return engine.statusStream;
}

/// Provides the count of pending sync operations for badges.
@riverpod
Stream<int> pendingSyncCount(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.syncQueueDao.watchPendingCount();
}
