import 'package:kale/core/sync/pull.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Server column every synced table is paged on, stamped by the server on
/// each write (migration `20261015000100_pull_cursor.sql`).
const serverUpdatedAtColumn = 'server_updated_at';

/// Restricts [query] to the page after [after] in
/// `(server_updated_at, id)` order, at most [limit] rows.
///
/// [limit] must stay at or below the API's `max_rows` (1000).
PostgrestTransformBuilder<PostgrestList> pullPageQuery(
  PostgrestFilterBuilder<PostgrestList> query, {
  required PullCursor? after,
  required int limit,
}) {
  var filtered = query;
  if (after != null) {
    final at = '"${after.at.toUtc().toIso8601String()}"';
    filtered = filtered.or(
      '$serverUpdatedAtColumn.gt.$at,'
      'and($serverUpdatedAtColumn.eq.$at,id.gt.${after.id})',
    );
  }
  return filtered
      .order(serverUpdatedAtColumn, ascending: true)
      .order('id', ascending: true)
      .limit(limit);
}

/// Maps the raw [rows] of a [pullPageQuery] result with [fromRow], and
/// takes the cursor from the last row.
RemotePage<M> toRemotePage<M>(
  List<Map<String, dynamic>> rows,
  M Function(Map<String, dynamic> row) fromRow,
) {
  if (rows.isEmpty) return RemotePage<M>(const []);
  final last = rows.last;
  return RemotePage<M>(
    rows.map(fromRow).toList(),
    last: PullCursor(
      DateTime.parse(last[serverUpdatedAtColumn] as String),
      last['id'] as String,
    ),
  );
}
