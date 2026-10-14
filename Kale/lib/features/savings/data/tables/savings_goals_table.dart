import 'package:drift/drift.dart';

/// Drift table for savings goals.
///
/// Amounts are integer minor units of the account's base currency (see
/// `features/profile`). A goal carries no currency of its own.
/// [currentAmountMinor] is derived on the device from the goal's
/// contributions; the server never computes it.
class SavingsGoals extends Table {
  /// Client-generated UUID.
  TextColumn get id => text()();

  /// Server-assigned ID. Null until first sync.
  TextColumn get serverId => text().nullable()();

  TextColumn get name => text()();

  /// Target, in minor units of the base currency.
  IntColumn get targetAmountMinor => integer()();

  /// Saved so far, in minor units: the sum of the goal's contributions.
  IntColumn get currentAmountMinor =>
      integer().withDefault(const Constant(0))();

  TextColumn get description => text().nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();
  TextColumn get iconName => text().nullable()();
  TextColumn get colorHex => text().nullable()();

  /// Enum stored as string: 'active', 'completed', 'paused', 'cancelled'.
  TextColumn get status => text().withDefault(const Constant('active'))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft-delete marker. Every read excludes rows where it is set.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
