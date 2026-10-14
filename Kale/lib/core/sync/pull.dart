import 'package:meta/meta.dart';

/// A position in one server table's pull order: the `server_updated_at`
/// and `id` of the last row pulled. Pages are keyset-ordered on that pair.
@immutable
class PullCursor {
  /// Creates a [PullCursor].
  const PullCursor(this.at, this.id);

  /// The row's `server_updated_at`, stamped by the server on every write.
  final DateTime at;

  /// The row's id, which breaks ties between rows stamped at the same time.
  final String id;

  @override
  bool operator ==(Object other) =>
      other is PullCursor && other.at == at && other.id == id;

  @override
  int get hashCode => Object.hash(at, id);

  @override
  String toString() => 'PullCursor(${at.toIso8601String()}, $id)';
}

/// A page of rows fetched from a server table, oldest change first.
@immutable
class RemotePage<M> {
  /// Creates a [RemotePage].
  const RemotePage(this.rows, {this.last});

  /// The rows, in `(server_updated_at, id)` order.
  final List<M> rows;

  /// The cursor of the last row, or null when [rows] is empty.
  final PullCursor? last;
}

/// The result of pulling one page into the local database.
@immutable
class PulledPage {
  /// Creates a [PulledPage].
  const PulledPage({required this.rowCount, this.last});

  /// How many rows the server returned (merged or not).
  final int rowCount;

  /// Where the next page starts, or null if this page was empty or the
  /// table has no cursor (the single-row profile).
  final PullCursor? last;
}

/// A row as pulled from the server: what the merge needs to know.
abstract interface class PulledRow {
  /// Client-generated id, shared by the device and the server.
  String get id;

  /// When the row was last changed, as written by the device that changed
  /// it.
  DateTime get updatedAt;

  /// Set when the row was deleted (a tombstone).
  DateTime? get deletedAt;
}

/// What the device knows about a local row, for the merge.
typedef LocalRowState = ({DateTime updatedAt, bool isSynced});

/// The pulled rows to write locally (decision Q8). A pulled row is skipped
/// when the device has a change to that row not yet pushed: the row is
/// unsynced or still has a sync queue entry ([pendingIds]). Otherwise the
/// newer `updatedAt` wins, deletion markers included. A tombstone for a
/// row the device never had is skipped: there is nothing to delete.
List<R> rowsToApply<R extends PulledRow>(
  Iterable<R> pulled, {
  required Map<String, LocalRowState> local,
  required Set<String> pendingIds,
}) {
  return [
    for (final row in pulled)
      if (_shouldApply(row, local[row.id], pendingIds.contains(row.id))) row,
  ];
}

bool _shouldApply(PulledRow row, LocalRowState? local, bool pending) {
  if (pending) return false;
  if (local == null) return row.deletedAt == null;
  if (!local.isSynced) return false;
  return row.updatedAt.isAfter(local.updatedAt);
}
