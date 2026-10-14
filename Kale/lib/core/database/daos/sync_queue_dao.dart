import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/core/database/tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

/// Values of [SyncQueueEntries.status].
abstract final class SyncQueueStatus {
  /// Waiting to be pushed.
  static const pending = 'pending';

  /// Being pushed by the current sync run.
  static const inProgress = 'in_progress';

  /// Failed every retry this session. Kept, never skipped silently:
  /// re-attempted on manual retry and on the next app start.
  static const stuck = 'stuck';
}

/// DAO for sync queue CRUD operations.
@DriftAccessor(tables: [SyncQueueEntries])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  /// Creates a [SyncQueueDao].
  SyncQueueDao(super.db);

  /// Inserts a new pending sync operation.
  Future<int> enqueue({
    required String entityType,
    required String entityId,
    required String operation,
    String? payload,
  }) {
    return into(syncQueueEntries).insert(
      SyncQueueEntriesCompanion.insert(
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        payload: Value(payload),
      ),
    );
  }

  /// Emits whenever an entry is enqueued, i.e. after any local write.
  Stream<void> watchEnqueued() => db.tableUpdates(
        TableUpdateQuery.onTable(
          syncQueueEntries,
          limitUpdateKind: UpdateKind.insert,
        ),
      );

  /// Gets all pending entries in FIFO order.
  ///
  /// Entries enqueued within the same second keep their insertion order
  /// (by id), so a parent (a savings goal) is pushed before its children.
  Future<List<SyncQueueEntry>> getPending() {
    return (select(syncQueueEntries)
          ..where((t) => t.status.equals(SyncQueueStatus.pending))
          ..orderBy([
            (t) => OrderingTerm.asc(t.createdAt),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .get();
  }

  /// Counts the entries not yet on the server: `pending` (including any in
  /// progress) and `stuck`.
  Future<({int pending, int stuck})> getCounts() async {
    final countExpr = syncQueueEntries.id.count();
    final rows = await (selectOnly(syncQueueEntries)
          ..addColumns([syncQueueEntries.status, countExpr])
          ..groupBy([syncQueueEntries.status]))
        .get();
    var pending = 0;
    var stuck = 0;
    for (final row in rows) {
      final count = row.read(countExpr)!;
      if (row.read(syncQueueEntries.status) == SyncQueueStatus.stuck) {
        stuck += count;
      } else {
        pending += count;
      }
    }
    return (pending: pending, stuck: stuck);
  }

  /// Marks an entry as in_progress.
  Future<void> markInProgress(int id) {
    return (update(syncQueueEntries)..where((t) => t.id.equals(id))).write(
      const SyncQueueEntriesCompanion(
        status: Value(SyncQueueStatus.inProgress),
      ),
    );
  }

  /// Removes a successfully synced entry.
  Future<void> markCompleted(int id) {
    return (delete(syncQueueEntries)..where((t) => t.id.equals(id))).go();
  }

  /// Puts an entry back to pending with [error], without using a retry
  /// (e.g. the network dropped).
  Future<void> markFailed(int id, String error) {
    return (update(syncQueueEntries)..where((t) => t.id.equals(id))).write(
      SyncQueueEntriesCompanion(
        status: const Value(SyncQueueStatus.pending),
        lastError: Value(error),
      ),
    );
  }

  /// Records a failed attempt that used a retry: the entry now has
  /// [retryCount] retries and goes back to pending, or to stuck if
  /// [stuck] is true.
  Future<void> recordFailedAttempt(
    int id, {
    required String error,
    required int retryCount,
    required bool stuck,
  }) {
    return (update(syncQueueEntries)..where((t) => t.id.equals(id))).write(
      SyncQueueEntriesCompanion(
        status: Value(
          stuck ? SyncQueueStatus.stuck : SyncQueueStatus.pending,
        ),
        lastError: Value(error),
        retryCount: Value(retryCount),
      ),
    );
  }

  /// Gives every entry a fresh set of retries: stuck and interrupted
  /// (in progress) entries go back to pending with a zero retry count.
  /// Run at app start.
  Future<void> resetRetries() {
    return update(syncQueueEntries).write(
      const SyncQueueEntriesCompanion(
        status: Value(SyncQueueStatus.pending),
        retryCount: Value(0),
      ),
    );
  }

  /// Puts stuck entries back to pending with a zero retry count (manual
  /// retry).
  Future<void> releaseStuck() {
    return (update(syncQueueEntries)
          ..where((t) => t.status.equals(SyncQueueStatus.stuck)))
        .write(
      const SyncQueueEntriesCompanion(
        status: Value(SyncQueueStatus.pending),
        retryCount: Value(0),
      ),
    );
  }

  /// Ids of the [entityType] rows with a change still in the queue
  /// (pending, in progress or stuck). A pull must not overwrite them.
  Future<Set<String>> queuedEntityIds(String entityType) async {
    final query = selectOnly(syncQueueEntries, distinct: true)
      ..addColumns([syncQueueEntries.entityId])
      ..where(syncQueueEntries.entityType.equals(entityType));
    final ids =
        await query.map((r) => r.read(syncQueueEntries.entityId)!).get();
    return ids.toSet();
  }

  /// Removes all entries for a specific entity.
  Future<void> removeForEntity(String entityType, String entityId) {
    return (delete(syncQueueEntries)
          ..where(
            (t) =>
                t.entityType.equals(entityType) & t.entityId.equals(entityId),
          ))
        .go();
  }

  /// Clears the entire queue (e.g., on logout).
  Future<void> clearAll() => delete(syncQueueEntries).go();
}
