// Port of `.claude/skills/add-syncable-entity/check_sync_wiring.sh`, run as
// part of `flutter test`. Handler registration is checked against the real
// engine; the remaining checks scan the source like the script does.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  test('every enqueued entity type has a registered SyncHandler', () {
    final enqueued = _matches(
      _dartFiles('lib/features', endingWith: '_local_datasource.dart'),
      RegExp("_entityType = '([a-z_]+)'"),
    );
    final registered = harness.engine.handlers.map((h) => h.entityType);

    expect(
      enqueued.difference(registered.toSet()),
      isEmpty,
      reason: 'Each enqueued entityType needs a SyncHandler listed in '
          'syncHandlersProvider.',
    );
  });

  test('every SyncHandler class is registered with the engine', () {
    final declared = _matches(
      _dartFiles('lib', endingWith: '.dart'),
      RegExp(r'class (\w+) implements SyncHandler'),
    );
    final registered =
        harness.engine.handlers.map((h) => h.runtimeType.toString()).toSet();

    expect(
      registered,
      declared,
      reason: 'Add the handler to syncHandlersProvider in sync_providers.dart',
    );
  });

  test('every Drift table is registered in AppDatabase and cleared on logout',
      () {
    final db = File('lib/core/database/app_database.dart').readAsStringSync();
    final tables = _matches(
      _dartFiles('lib/features', endingWith: '_table.dart'),
      RegExp(r'^class (\w+) extends Table', multiLine: true),
    );

    for (final table in tables) {
      final getter = table[0].toLowerCase() + table.substring(1);
      expect(
        db,
        matches(RegExp('^\\s+$table,\$', multiLine: true)),
        reason: '$table missing from @DriftDatabase(tables: ...)',
      );
      expect(
        db,
        contains('delete($getter)'),
        reason: '$table missing from clearAllData()',
      );
    }
  });

  test('reads never pull: no syncable repository uses a remote datasource', () {
    final syncable =
        _dartFiles('lib/features', endingWith: '_repository_impl.dart')
            .where((f) => f.readAsStringSync().contains('enqueueSync'));

    expect(syncable, isNotEmpty);
    for (final file in syncable) {
      expect(
        file.readAsStringSync(),
        isNot(contains('RemoteDataSource')),
        reason: '${file.path}: pulling goes through the SyncHandlers '
            '(SyncPuller), never through a repository',
      );
    }
  });
}

Iterable<File> _dartFiles(String root, {required String endingWith}) =>
    Directory(root)
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith(endingWith))
        .where((f) => !f.path.endsWith('.g.dart'));

Set<String> _matches(Iterable<File> files, RegExp pattern) => {
      for (final file in files)
        for (final match in pattern.allMatches(file.readAsStringSync()))
          match.group(1)!,
    };
