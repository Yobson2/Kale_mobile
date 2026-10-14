// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncConfigHash() => r'b2d2f0ff7108f9a3f606efb51a3b70ca0d909f64';

/// Retry, backoff and debounce settings for the [SyncEngine].
///
/// Copied from [syncConfig].
@ProviderFor(syncConfig)
final syncConfigProvider = Provider<SyncConfig>.internal(
  syncConfig,
  name: r'syncConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncConfigRef = ProviderRef<SyncConfig>;
String _$syncClockHash() => r'640d1c1a26e2862e9236b30e4227c6b348788742';

/// Time source for the [SyncEngine]. Overridden in tests with a fake
/// clock so debounce and backoff need no real waits.
///
/// Copied from [syncClock].
@ProviderFor(syncClock)
final syncClockProvider = Provider<SyncClock>.internal(
  syncClock,
  name: r'syncClockProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncClockHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncClockRef = ProviderRef<SyncClock>;
String _$lastBackupStoreHash() => r'1a757fa03688187349b795213ac7d004f9548c77';

/// Where the [SyncEngine] persists the last successful backup time.
///
/// Copied from [lastBackupStore].
@ProviderFor(lastBackupStore)
final lastBackupStoreProvider = Provider<LastBackupStore>.internal(
  lastBackupStore,
  name: r'lastBackupStoreProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastBackupStoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LastBackupStoreRef = ProviderRef<LastBackupStore>;
String _$syncHandlersHash() => r'37878bed3a8390209cac0187cbef57453c895f31';

/// Every [SyncHandler] in the app, one per syncable entity type.
///
/// Add a feature's handler here when it starts enqueueing a new entity
/// type; `test/core/sync/sync_wiring_test.dart` fails until you do.
///
/// Copied from [syncHandlers].
@ProviderFor(syncHandlers)
final syncHandlersProvider = Provider<List<SyncHandler>>.internal(
  syncHandlers,
  name: r'syncHandlersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncHandlersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncHandlersRef = ProviderRef<List<SyncHandler>>;
String _$syncEngineHash() => r'1d1514a39394551433b875030c71c3dc2f32d27c';

/// Provides the [SyncEngine] singleton, with every handler from
/// [syncHandlers] registered at construction. Reading it starts the
/// engine (see [SyncEngine.start]); the app root does so at launch.
///
/// Copied from [syncEngine].
@ProviderFor(syncEngine)
final syncEngineProvider = Provider<SyncEngine>.internal(
  syncEngine,
  name: r'syncEngineProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncEngineHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncEngineRef = ProviderRef<SyncEngine>;
String _$backupStatusHash() => r'3b56618bb349cc18fd78c8025cae0e074b4e4286';

/// Streams the [BackupStatus] for the sync banner and Settings.
///
/// Copied from [backupStatus].
@ProviderFor(backupStatus)
final backupStatusProvider = AutoDisposeStreamProvider<BackupStatus>.internal(
  backupStatus,
  name: r'backupStatusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$backupStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BackupStatusRef = AutoDisposeStreamProviderRef<BackupStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
