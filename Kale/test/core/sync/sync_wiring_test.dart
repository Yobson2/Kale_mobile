// Port of `.claude/skills/add-syncable-entity/check_sync_wiring.sh`, run as
// part of `flutter test`. Handler registration is checked against the real
// engine; the remaining checks scan the source like the script does.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../helpers/sync_harness.dart';

/// Entity types that are enqueued but knowingly have no handler yet.
/// Delete an entry when its ticket lands; the test fails until you do.
const knownGaps = {
  'savings_goal': 'no SavingsSyncHandler until the savings ticket (#7)',
};

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
      knownGaps.keys.toSet(),
      reason: 'Each enqueued entityType needs a SyncHandler listed in '
          'syncHandlersProvider. If a known gap was fixed, remove it from '
          'knownGaps.',
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

  test('every syncable repository is refreshed after login', () {
    final notifier = File(
      'lib/features/auth/presentation/providers/auth_notifier.dart',
    ).readAsStringSync();
    final syncable =
        _dartFiles('lib/features', endingWith: '_repository_impl.dart')
            .where((f) => f.readAsStringSync().contains('enqueueSync'));

    for (final file in syncable) {
      final repository = RegExp(r'implements (\w+Repository)')
          .firstMatch(file.readAsStringSync())!
          .group(1)!;
      final provider =
          '${repository[0].toLowerCase()}${repository.substring(1)}Provider';
      expect(
        notifier,
        contains('$provider).refreshFromServer'),
        reason: '$repository is not refreshed in auth_notifier.dart',
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
