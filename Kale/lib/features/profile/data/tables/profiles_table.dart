import 'package:drift/drift.dart';

/// Drift table for the signed-in account's profile: a single row whose
/// [id] is `ProfileModel.localId`. Mirrors the server's `profiles` row.
class Profiles extends Table {
  /// Always `ProfileModel.localId`; the server row is keyed by the user.
  TextColumn get id => text()();

  /// ISO 4217 code of the account's base currency. Every amount in the
  /// app is in this currency.
  TextColumn get baseCurrency => text()();

  /// When the profile was last changed.
  DateTimeColumn get updatedAt => dateTime()();

  /// Whether this record has been synced to the server.
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
