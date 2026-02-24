import 'package:drift/drift.dart';

/// Drift table for savings contributions.
class SavingsContributions extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();
  RealColumn get amount => real()();
  /// Enum stored as string: 'manual', 'auto', 'roundup'.
  TextColumn get source => text().withDefault(const Constant('manual'))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
