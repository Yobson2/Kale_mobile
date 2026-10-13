import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/database/app_database.dart';

/// Pre-release only: any schema version change wipes the device database.
void main() {
  late Directory dir;
  late File file;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    dir = Directory.systemTemp.createTempSync('kale_db_');
    file = File('${dir.path}/kale.db');
  });
  tearDown(() => dir.deleteSync(recursive: true));

  /// Writes a database that looks like it came from schema [version]: an
  /// out-of-date `transactions` table, an obsolete table, and queued data.
  Future<void> writeDatabaseFromVersion(int version) async {
    final old = AppDatabase(NativeDatabase(file));
    await old.syncQueueDao.enqueue(
      entityType: 'transaction',
      entityId: 'old-1',
      operation: 'create',
    );
    await old.customStatement('DROP TABLE transactions');
    await old.customStatement(
      'CREATE TABLE transactions (id TEXT PRIMARY KEY, legacy_amount REAL)',
    );
    await old.customStatement('CREATE TABLE notes (id TEXT PRIMARY KEY)');
    await old.customStatement('PRAGMA user_version = $version');
    await old.close();
  }

  for (final (label, versionOffset) in [('older', -1), ('newer', 1)]) {
    test('a database from an $label schema version is recreated empty',
        () async {
      final probe = AppDatabase(NativeDatabase.memory());
      final current = probe.schemaVersion;
      await probe.close();
      await writeDatabaseFromVersion(current + versionOffset);

      final db = AppDatabase(NativeDatabase(file));
      addTearDown(db.close);

      expect(await db.syncQueueDao.getPending(), isEmpty);
      expect(await db.categoriesDao.getCount(), greaterThan(0));
      final tables = await db
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
          .map((row) => row.read<String>('name'))
          .get();
      expect(tables, isNot(contains('notes')));
      // The current transactions schema is usable again.
      await db.transactionsDao.upsert(
        TransactionsCompanion.insert(
          id: 't1',
          amount: 100,
          type: 'expense',
          categoryId: 'cat_food',
          date: DateTime(2026, 10),
          paymentMethod: 'cash',
          createdAt: DateTime(2026, 10),
          updatedAt: DateTime(2026, 10),
        ),
      );
      expect(await db.transactionsDao.getById('t1'), isNotNull);
    });
  }
}
