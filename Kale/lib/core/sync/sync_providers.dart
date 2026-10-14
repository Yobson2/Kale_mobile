import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/providers/network_providers.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/sync/backup_status.dart';
import 'package:kale/core/sync/last_backup_store.dart';
import 'package:kale/core/sync/sync_clock.dart';
import 'package:kale/core/sync/sync_config.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_providers.g.dart';

/// Retry, backoff and debounce settings for the [SyncEngine].
@Riverpod(keepAlive: true)
SyncConfig syncConfig(Ref ref) => const SyncConfig();

/// Time source for the [SyncEngine]. Overridden in tests with a fake
/// clock so debounce and backoff need no real waits.
@Riverpod(keepAlive: true)
SyncClock syncClock(Ref ref) => const SyncClock();

/// Where the [SyncEngine] persists the last successful backup time.
@Riverpod(keepAlive: true)
LastBackupStore lastBackupStore(Ref ref) =>
    PreferencesLastBackupStore(ref.watch(localStorageProvider));

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
/// [syncHandlers] registered at construction. Reading it starts the
/// engine (see [SyncEngine.start]); the app root does so at launch.
@Riverpod(keepAlive: true)
SyncEngine syncEngine(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  final engine = SyncEngine(
    syncQueueDao: db.syncQueueDao,
    networkInfo: networkInfo,
    handlers: ref.watch(syncHandlersProvider),
    config: ref.watch(syncConfigProvider),
    clock: ref.watch(syncClockProvider),
    lastBackupStore: ref.watch(lastBackupStoreProvider),
  )..start(
      networkInfo.onConnectivityChanged.map(
        (results) => !results.contains(ConnectivityResult.none),
      ),
    );

  ref.onDispose(engine.dispose);
  return engine;
}

/// Streams the [BackupStatus] for the sync banner and Settings.
@riverpod
Stream<BackupStatus> backupStatus(Ref ref) =>
    ref.watch(syncEngineProvider).watchBackupStatus();
