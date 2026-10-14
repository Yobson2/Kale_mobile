import 'package:drift/drift.dart';

/// Where pulling stands for each synced entity type: the cursor of the
/// last row pulled, and whether the last pull reached the end of the
/// table. Saved after every page, so an interrupted restore resumes where
/// it stopped.
@DataClassName('PullCursorRow')
class PullCursors extends Table {
  /// The sync entity type, e.g. `transaction`.
  TextColumn get entityType => text()();

  /// `server_updated_at` of the last row pulled; null before the first.
  DateTimeColumn get cursorAt => dateTime().nullable()();

  /// Id of the last row pulled; null before the first.
  TextColumn get cursorId => text().nullable()();

  /// Whether the last pull of this entity type reached the end.
  BoolColumn get caughtUp => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {entityType};
}
