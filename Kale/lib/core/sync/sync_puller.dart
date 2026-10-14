import 'dart:async';

import 'package:kale/core/database/daos/pull_cursors_dao.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/network/network_info.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/core/utils/logger.dart';
import 'package:meta/meta.dart';

/// How a pull ended.
enum PullOutcome {
  /// Every entity type was pulled to the end.
  done,

  /// No connection: nothing, or only part, was pulled.
  offline,

  /// The server or the database failed: pulling stopped after the last
  /// complete page, and resumes from there next time.
  failed,
}

/// What pulling is doing right now, for the restore banner.
@immutable
class PullStatus {
  /// Creates a [PullStatus].
  const PullStatus({
    this.isPulling = false,
    this.isRestore = false,
    this.rowsPulled = 0,
  });

  /// Whether a pull is running.
  final bool isPulling;

  /// Whether the running pull restores the account on this device (the
  /// first pull after sign-in, or its resumption).
  final bool isRestore;

  /// How many rows the running pull has received so far.
  final int rowsPulled;

  @override
  bool operator ==(Object other) =>
      other is PullStatus &&
      other.isPulling == isPulling &&
      other.isRestore == isRestore &&
      other.rowsPulled == rowsPulled;

  @override
  int get hashCode => Object.hash(isPulling, isRestore, rowsPulled);
}

/// Brings server data into the local database (decision Q8).
///
/// Pulling happens only on restore ([restoreIfNeeded]: after sign-in or at
/// launch) and on pull-to-refresh ([pull]); reading data never pulls. Each
/// entity type is pulled in pages of [pageSize] rows from its saved cursor,
/// and the cursor is saved after every page, so an interrupted pull
/// resumes where it stopped. Handlers merge each page (see `rowsToApply`).
///
/// Entity types are pulled in handler order, so list parents (budgets,
/// goals) before their children (allocations, contributions).
class SyncPuller {
  /// Creates a [SyncPuller] over [handlers], in pull order.
  SyncPuller({
    required Iterable<SyncHandler> handlers,
    required PullCursorsDao cursors,
    required NetworkInfo networkInfo,
    required Future<bool> Function() hasLocalData,
    this.pageSize = defaultPageSize,
  })  : _handlers = List.unmodifiable(handlers),
        _cursors = cursors,
        _networkInfo = networkInfo,
        _hasLocalData = hasLocalData;

  /// Rows per page; below the API's `max_rows` (1000).
  static const defaultPageSize = 500;

  /// Rows requested per page.
  final int pageSize;

  final List<SyncHandler> _handlers;
  final PullCursorsDao _cursors;
  final NetworkInfo _networkInfo;
  final Future<bool> Function() _hasLocalData;

  final _statusController = StreamController<PullStatus>.broadcast();
  PullStatus _status = const PullStatus();
  Future<PullOutcome>? _inFlight;

  /// The current pull status.
  PullStatus get currentStatus => _status;

  /// Emits the current pull status, then every change.
  Stream<PullStatus> watchStatus() async* {
    yield _status;
    yield* _statusController.stream;
  }

  /// Pull-to-refresh: brings in every change made on the server since the
  /// last pull, without overwriting local changes not yet pushed.
  ///
  /// If a pull is already running, returns its outcome.
  Future<PullOutcome> pull() => _run(isRestore: false);

  /// Restores the account on this device when it needs it: the device
  /// holds none of the user's data and nothing was ever pulled (a fresh
  /// sign-in or a reinstall), or an earlier restore did not finish.
  /// Otherwise does nothing and returns null: a device with local data is
  /// never restored over (decision Q8).
  Future<PullOutcome?> restoreIfNeeded() async {
    final saved = await _cursors.getAll();
    final started = saved.isNotEmpty;
    final finished = started &&
        _handlers.every((h) => saved[h.entityType]?.caughtUp ?? false);
    if (finished) return null;
    if (!started && await _hasLocalData()) return null;
    return _run(isRestore: true);
  }

  /// Releases the status stream.
  Future<void> dispose() => _statusController.close();

  Future<PullOutcome> _run({required bool isRestore}) => _inFlight ??=
      _pullAll(isRestore: isRestore).whenComplete(() => _inFlight = null);

  Future<PullOutcome> _pullAll({required bool isRestore}) async {
    if (!await _networkInfo.isConnected) return PullOutcome.offline;
    _update(PullStatus(isPulling: true, isRestore: isRestore));
    try {
      if (isRestore) {
        await _cursors.markRestoreStarted(_handlers.map((h) => h.entityType));
      }
      final saved = await _cursors.getAll();
      var pulled = 0;
      for (final handler in _handlers) {
        var cursor = saved[handler.entityType]?.cursor;
        while (true) {
          final page = await handler.pullPage(after: cursor, limit: pageSize);
          cursor = page.last ?? cursor;
          final caughtUp = page.rowCount < pageSize || page.last == null;
          await _cursors.save(
            handler.entityType,
            cursor: cursor,
            caughtUp: caughtUp,
          );
          pulled += page.rowCount;
          _update(
            PullStatus(
              isPulling: true,
              isRestore: isRestore,
              rowsPulled: pulled,
            ),
          );
          if (caughtUp) break;
        }
      }
      return PullOutcome.done;
    } on NetworkException {
      return PullOutcome.offline;
    } catch (e) {
      AppLogger.error('Pull failed', tag: 'SyncPuller', error: e);
      return PullOutcome.failed;
    } finally {
      _update(const PullStatus());
    }
  }

  void _update(PullStatus status) {
    if (status == _status) return;
    _status = status;
    if (!_statusController.isClosed) _statusController.add(status);
  }
}
