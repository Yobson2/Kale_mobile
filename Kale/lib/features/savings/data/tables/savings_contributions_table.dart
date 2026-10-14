import 'package:drift/drift.dart';

/// Drift table for savings contributions, each owned through its goal.
///
/// Amounts are integer minor units of the account's base currency.
@TableIndex(name: 'idx_savings_contributions_goal', columns: {#goalId})
class SavingsContributions extends Table {
  /// Client-generated UUID.
  TextColumn get id => text()();

  /// Server-assigned ID. Null until first sync.
  TextColumn get serverId => text().nullable()();

  /// The goal this contribution belongs to.
  TextColumn get goalId => text()();

  /// Amount, in minor units of the base currency (always positive).
  IntColumn get amountMinor => integer()();

  /// Enum stored as string: 'manual', 'auto', 'roundup'.
  TextColumn get source => text().withDefault(const Constant('manual'))();

  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft-delete marker. Every read excludes rows where it is set.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
