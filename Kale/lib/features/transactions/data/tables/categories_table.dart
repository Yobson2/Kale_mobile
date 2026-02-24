import 'package:drift/drift.dart';

/// Drift table definition for transaction categories.
class Categories extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// Category name.
  TextColumn get name => text()();

  /// Material icon name.
  TextColumn get icon => text()();

  /// Hex color string.
  TextColumn get color => text()();

  /// Category type: 'income', 'expense', 'both'.
  TextColumn get type => text()();

  /// Whether this is a system-provided category.
  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(true))();

  /// Display order.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// When the category was created.
  DateTimeColumn get createdAt => dateTime()();

  /// Whether synced to server.
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
