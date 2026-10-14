import 'dart:async';

import 'package:kale/core/database/app_database.dart';
import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/network/network_info.dart';
import 'package:kale/core/sync/backup_status.dart';
import 'package:kale/core/sync/last_backup_store.dart';
import 'package:kale/core/sync/pull.dart';
import 'package:kale/core/sync/sync_clock.dart';
import 'package:kale/core/sync/sync_config.dart';
import 'package:kale/core/utils/logger.dart';

/// Contract that each syncable feature must implement.
///
/// Registered with the [SyncEngine] so it knows how to push each entity
/// type's operations to the server, and with the `SyncPuller` so it knows
/// how to pull them back.
abstract class SyncHandler {
  /// The entity type string this handler manages (e.g., 'note').
  String get entityType;

  /// Pushes a create operation to the server.
  /// Returns the server-assigned ID (may differ from local ID).
  Future<String> pushCreate(String entityId, String payload);

  /// Pushes an update operation to the server.
  ///
  /// Deletes are soft deletes: they arrive here as updates whose payload
  /// carries `deleted_at`. Nothing is ever hard-deleted on the server.
  Future<void> pushUpdate(String entityId, String payload);

  /// Pulls the next page of at most [limit] server rows changed after
  /// [after] (from the start when null), in `(server_updated_at, id)`
  /// order, and merges them into the local table: a row with a local
  /// change not yet pushed is kept, otherwise the newer `updatedAt` wins
  /// (see `rowsToApply`).
  Future<PulledPage> pullPage({
    required PullCursor? after,
    required int limit,
  });

  /// Queues every live local row of [entityType] as a `create`: the
  /// device's data is moving to another account (see
  /// `AppDatabase.rekeyForAnotherAccount`). Called in handler order, so
  /// parents are queued before their children.
  Future<void> requeueAllAsCreates();
}

/// Orchestrates background synchronization of offline mutations.
///
/// A sync run pushes every pending queue entry. Runs are triggered by:
/// * a local write (debounced by [SyncConfig.writeDebounce]),
/// * the app starting or returning to the foreground ([onAppResumed]),
/// * connectivity coming back,
/// * manual retry ([retry]),
/// * an entry's backoff expiring.
///
/// Triggers that arrive while a run is in progress coalesce into a single
/// follow-up run.
///
/// Failures: a network error leaves the entry pending without using a
/// retry. Any other error uses a retry and holds the entry back for an
/// exponential backoff; at [SyncConfig.maxRetries] the entry is marked
/// stuck. Stuck entries are kept and counted in [currentBackupStatus];
/// they are re-attempted on [retry] and on the next app start, which
/// resets every retry count.
class SyncEngine {
  /// Creates a [SyncEngine] that pushes queue entries through [handlers].
  ///
  /// Every handler is registered here, up front, so entries queued in an
  /// earlier session sync even if no feature has been opened yet.
  /// Throws [ArgumentError] if two handlers claim the same entity type.
  SyncEngine({
    required SyncQueueDao syncQueueDao,
    required NetworkInfo networkInfo,
    required Iterable<SyncHandler> handlers,
    SyncConfig config = const SyncConfig(),
    SyncClock clock = const SyncClock(),
    LastBackupStore? lastBackupStore,
  })  : _syncQueueDao = syncQueueDao,
        _networkInfo = networkInfo,
        _config = config,
        _clock = clock,
        _lastBackupStore = lastBackupStore ?? InMemoryLastBackupStore() {
    for (final handler in handlers) {
      if (_handlers.containsKey(handler.entityType)) {
        throw ArgumentError.value(
          handler,
          'handlers',
          'Duplicate SyncHandler for "${handler.entityType}"',
        );
      }
      _handlers[handler.entityType] = handler;
    }
    _status = BackupStatus(lastBackupAt: _lastBackupStore.read());
  }

  final SyncQueueDao _syncQueueDao;
  final NetworkInfo _networkInfo;
  final SyncConfig _config;
  final SyncClock _clock;
  final LastBackupStore _lastBackupStore;

  final Map<String, SyncHandler> _handlers = {};
  final _statusController = StreamController<BackupStatus>.broadcast();
  late BackupStatus _status;

  Future<void> _ready = Future.value();
  Future<void>? _inFlight;
  bool _rerunRequested = false;
  bool _disposed = false;

  Timer? _writeDebounce;

  /// Entries holding back after a failed attempt, with the timer that
  /// re-triggers a run when their backoff expires.
  final Map<int, Timer> _backoffs = {};

  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<void>? _enqueueSubscription;

  /// The registered handlers, one per entity type.
  Iterable<SyncHandler> get handlers => _handlers.values;

  /// The latest backup status.
  BackupStatus get currentBackupStatus => _status;

  /// Emits the current backup status, then every change.
  Stream<BackupStatus> watchBackupStatus() async* {
    yield _status;
    yield* _statusController.stream;
  }

  /// Completes when no sync run is in progress.
  Future<void> get idle => _inFlight ?? Future<void>.value();

  /// Starts the engine for this app session: resets retry counts, starts
  /// listening for local writes and connectivity changes, and runs a
  /// first sync.
  ///
  /// Call this once during app initialization.
  void start(Stream<bool> connectivityStream) {
    _ready = _syncQueueDao.resetRetries().then((_) => _refreshCounts());
    _connectivitySubscription = connectivityStream.listen((isOnline) {
      if (isOnline) {
        processQueue();
      } else {
        _update(_status.copyWith(isOffline: true));
      }
    });
    _enqueueSubscription = _syncQueueDao.watchEnqueued().listen((_) {
      _refreshCounts();
      _writeDebounce?.cancel();
      _writeDebounce = _clock.timer(_config.writeDebounce, processQueue);
    });
    processQueue();
  }

  /// Pushes pending changes after the app returns to the foreground.
  void onAppResumed() => processQueue();

  /// Manual retry: re-attempts every pending and stuck entry now, with a
  /// fresh set of retries for the stuck ones, ignoring backoffs.
  Future<void> retry() async {
    for (final timer in _backoffs.values) {
      timer.cancel();
    }
    _backoffs.clear();
    await _ready;
    await _syncQueueDao.releaseStuck();
    await _refreshCounts();
    await processQueue();
  }

  /// Pushes everything it can right now, like [retry], and returns the
  /// resulting status: what is still pending or stuck afterwards could not
  /// be backed up (offline, or the server refused it).
  Future<BackupStatus> backUpNow() async {
    await retry();
    return _status;
  }

  /// Forgets the previous user's backup state after the local database
  /// and sync queue were wiped (logout): drops scheduled pushes, clears
  /// the last backup time, and re-reads the (now empty) queue counts.
  Future<void> onLocalDataCleared() async {
    _writeDebounce?.cancel();
    for (final timer in _backoffs.values) {
      timer.cancel();
    }
    _backoffs.clear();
    await _lastBackupStore.clear();
    _update(BackupStatus(isOffline: _status.isOffline));
    await _refreshCounts();
  }

  /// Stops listening and cleans up resources.
  Future<void> dispose() async {
    _disposed = true;
    _writeDebounce?.cancel();
    for (final timer in _backoffs.values) {
      timer.cancel();
    }
    _backoffs.clear();
    await _connectivitySubscription?.cancel();
    await _enqueueSubscription?.cancel();
    await _statusController.close();
  }

  /// Triggers a sync run.
  ///
  /// If a run is already in progress, a single follow-up run is scheduled
  /// for after it (so changes queued meanwhile are not missed) and the
  /// returned future completes when both are done.
  Future<void> processQueue() {
    final inFlight = _inFlight;
    if (inFlight != null) {
      _rerunRequested = true;
      return inFlight;
    }
    return _inFlight = _runUntilSettled().whenComplete(() => _inFlight = null);
  }

  Future<void> _runUntilSettled() async {
    do {
      _rerunRequested = false;
      await _runCycle();
    } while (_rerunRequested && !_disposed);
  }

  Future<void> _runCycle() async {
    await _ready;
    if (_disposed) return;

    if (!await _networkInfo.isConnected) {
      _update(_status.copyWith(isOffline: true));
      return;
    }

    try {
      final pending = (await _syncQueueDao.getPending())
          .where((entry) => !_backoffs.containsKey(entry.id))
          .toList();
      _update(_status.copyWith(isOffline: false));
      if (pending.isEmpty) return;

      _update(_status.copyWith(isSyncing: true));
      for (final entry in pending) {
        if (_disposed) return;
        if (!await _networkInfo.isConnected) {
          _update(_status.copyWith(isOffline: true));
          break;
        }

        final handler = _handlers[entry.entityType];
        if (handler == null) {
          AppLogger.warning(
            'No SyncHandler registered for "${entry.entityType}"',
            tag: 'SyncEngine',
          );
          continue;
        }

        await _processEntry(entry, handler);
        await _refreshCounts();
      }

      await _refreshCounts();
      if (_status.isFullyBackedUp) {
        final now = _clock.now();
        await _lastBackupStore.write(now);
        _update(_status.copyWith(lastBackupAt: now));
      }
    } catch (e) {
      AppLogger.error('Sync run failed', tag: 'SyncEngine', error: e);
    } finally {
      _update(_status.copyWith(isSyncing: false));
    }
  }

  Future<void> _processEntry(
    SyncQueueEntry entry,
    SyncHandler handler,
  ) async {
    await _syncQueueDao.markInProgress(entry.id);

    try {
      switch (entry.operation) {
        case 'create':
          await handler.pushCreate(entry.entityId, entry.payload!);
          await _syncQueueDao.markCompleted(entry.id);

        case 'update':
          await handler.pushUpdate(entry.entityId, entry.payload!);
          await _syncQueueDao.markCompleted(entry.id);

        default:
          throw StateError('Unknown sync operation "${entry.operation}"');
      }
    } on ServerException catch (e) {
      await _recordFailedAttempt(entry, e.message);
    } on NetworkException {
      await _syncQueueDao.markFailed(entry.id, 'Network lost during sync');
    } catch (e) {
      await _recordFailedAttempt(entry, e.toString());
    }
  }

  /// Uses one retry. Below the limit, the entry waits out its backoff
  /// (without blocking the run) and a run is triggered when it expires;
  /// at the limit it is marked stuck.
  Future<void> _recordFailedAttempt(SyncQueueEntry entry, String error) async {
    final retryCount = entry.retryCount + 1;
    final stuck = retryCount >= _config.maxRetries;
    await _syncQueueDao.recordFailedAttempt(
      entry.id,
      error: error,
      retryCount: retryCount,
      stuck: stuck,
    );

    if (stuck) {
      AppLogger.error(
        'Queue entry ${entry.id} (${entry.entityType}/${entry.entityId}) '
        'is stuck after $retryCount attempts: $error',
        tag: 'SyncEngine',
      );
      return;
    }

    _backoffs[entry.id] = _clock.timer(
      _config.backoffFor(entry.retryCount),
      () {
        _backoffs.remove(entry.id);
        processQueue();
      },
    );
  }

  Future<void> _refreshCounts() async {
    if (_disposed) return;
    final counts = await _syncQueueDao.getCounts();
    _update(
      _status.copyWith(pendingCount: counts.pending, stuckCount: counts.stuck),
    );
  }

  void _update(BackupStatus status) {
    if (status == _status) return;
    _status = status;
    if (!_statusController.isClosed) _statusController.add(status);
  }
}
