import 'package:drift/drift.dart';

/// Drift table definition for financial transactions.
class Transactions extends Table {
  /// Client-generated UUID.
  TextColumn get id => text()();

  /// Server-assigned ID. Null until first sync.
  TextColumn get serverId => text().nullable()();

  /// Transaction amount (always positive).
  RealColumn get amount => real()();

  /// Transaction type: 'income', 'expense', 'transfer'.
  TextColumn get type => text()();

  /// FK to category ID.
  TextColumn get categoryId => text()();

  /// Optional description/note.
  TextColumn get description => text().nullable()();

  /// When the transaction occurred.
  DateTimeColumn get date => dateTime()();

  /// Payment method: 'cash', 'mobileMoney', 'bank', 'card'.
  TextColumn get paymentMethod => text()();

  /// ISO 4217 currency code.
  TextColumn get currencyCode => text().withDefault(const Constant('XOF'))();

  /// Whether this is a recurring transaction.
  BoolColumn get isRecurring =>
      boolean().withDefault(const Constant(false))();

  /// FK to recurring rule ID.
  TextColumn get recurringRuleId => text().nullable()();

  /// Mobile money provider name.
  TextColumn get mobileMoneyProvider => text().nullable()();

  /// Mobile money transaction reference.
  TextColumn get mobileMoneyRef => text().nullable()();

  /// FK to account ID (future multi-account support).
  TextColumn get accountId => text().nullable()();

  /// When the record was created.
  DateTimeColumn get createdAt => dateTime()();

  /// When the record was last updated.
  DateTimeColumn get updatedAt => dateTime()();

  /// Whether this record has been synced to the server.
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
