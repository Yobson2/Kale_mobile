import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/core/database/tables/pull_cursors_table.dart';
import 'package:kale/core/sync/pull.dart';

part 'pull_cursors_dao.g.dart';

/// Where pulling stands for one entity type.
typedef PullState = ({PullCursor? cursor, bool caughtUp});

/// DAO for the per-entity-type pull cursors.
@DriftAccessor(tables: [PullCursors])
class PullCursorsDao extends DatabaseAccessor<AppDatabase>
    with _$PullCursorsDaoMixin {
  /// Creates a [PullCursorsDao].
  PullCursorsDao(super.db);

  /// The saved state of every entity type pulled at least once.
  Future<Map<String, PullState>> getAll() async {
    final rows = await select(pullCursors).get();
    return {for (final row in rows) row.entityType: _toState(row)};
  }

  /// Saves where pulling [entityType] stands.
  Future<void> save(
    String entityType, {
    required PullCursor? cursor,
    required bool caughtUp,
  }) {
    return into(pullCursors).insertOnConflictUpdate(
      PullCursorsCompanion.insert(
        entityType: entityType,
        cursorAt: Value(cursor?.at),
        cursorId: Value(cursor?.id),
        caughtUp: Value(caughtUp),
      ),
    );
  }

  /// Marks [entityTypes] as not caught up, keeping their cursors: a
  /// restore has started and must finish for every one of them.
  Future<void> markRestoreStarted(Iterable<String> entityTypes) {
    return transaction(() async {
      final saved = await getAll();
      for (final type in entityTypes) {
        await save(type, cursor: saved[type]?.cursor, caughtUp: false);
      }
    });
  }

  static PullState _toState(PullCursorRow row) {
    final at = row.cursorAt;
    final id = row.cursorId;
    return (
      cursor: at != null && id != null ? PullCursor(at, id) : null,
      caughtUp: row.caughtUp,
    );
  }
}
