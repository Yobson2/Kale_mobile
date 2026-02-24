import 'package:drift/drift.dart';

/// Drift table for savings goals.
class SavingsGoals extends Table {
  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get name => text()();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real().withDefault(const Constant(0.0))();
  TextColumn get currencyCode => text().withDefault(const Constant('XOF'))();
  TextColumn get description => text().nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();
  TextColumn get iconName => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  /// Enum stored as string: 'active', 'completed', 'paused', 'cancelled'.
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
