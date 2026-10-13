// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncConfigHash() => r'3f1c0d9a7b2e4c6a8d0f1e3b5a7c9e1d2f4a6b8c';

/// Retry and backoff settings for the [SyncEngine].
///
/// Overridden in tests to remove backoff delays.
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
String _$syncHandlersHash() => r'8b4e2d6f0a1c3e5b7d9f2a4c6e8b0d1f3a5c7e9b';

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
String _$syncEngineHash() => r'5c2a7e9b1d3f6a8c0e2b4d6f8a1c3e5b7d9f0a2c';

/// Provides the [SyncEngine] singleton, with every handler from
/// [syncHandlers] registered at construction.
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
String _$syncStatusHash() => r'bf656d81ec99f09b8c2e684f4f4ef8c40b20d3e9';

/// Streams the current [SyncStatus] for UI widgets.
///
/// Copied from [syncStatus].
@ProviderFor(syncStatus)
final syncStatusProvider = AutoDisposeStreamProvider<SyncStatus>.internal(
  syncStatus,
  name: r'syncStatusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncStatusRef = AutoDisposeStreamProviderRef<SyncStatus>;
String _$pendingSyncCountHash() => r'ec197835d59646a205e5e44c40daf090d32d7fb0';

/// Provides the count of pending sync operations for badges.
///
/// Copied from [pendingSyncCount].
@ProviderFor(pendingSyncCount)
final pendingSyncCountProvider = AutoDisposeStreamProvider<int>.internal(
  pendingSyncCount,
  name: r'pendingSyncCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingSyncCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingSyncCountRef = AutoDisposeStreamProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
