import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/sync/backup_status.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/core/sync/sync_providers.dart';
import 'package:kale/features/more/presentation/pages/settings_page.dart';
import 'package:kale/features/more/presentation/widgets/backup_status_tile.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helpers.dart';

class _MockSyncEngine extends Mock implements SyncEngine {}

void main() {
  late _MockSyncEngine engine;

  setUp(() {
    engine = _MockSyncEngine();
    when(() => engine.retry()).thenAnswer((_) async {});
  });

  List<Override> overridesFor(BackupStatus status) => [
        backupStatusProvider.overrideWith((ref) => Stream.value(status)),
        syncEngineProvider.overrideWithValue(engine),
      ];

  Future<void> pumpTile(WidgetTester tester, BackupStatus status) async {
    await tester.pumpWidget(
      createTestApp(
        child: const Scaffold(body: BackupStatusTile()),
        overrides: overridesFor(status),
      ),
    );
    await tester.pump();
  }

  testWidgets('everything backed up shows the last backup time',
      (tester) async {
    await pumpTile(
      tester,
      BackupStatus(lastBackupAt: DateTime(2026, 10, 13, 9, 30)),
    );

    expect(find.text('All changes backed up'), findsOneWidget);
    expect(find.text('Last backup: Oct 13, 2026 09:30'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('pending changes are counted; never backed up is said',
      (tester) async {
    await pumpTile(tester, const BackupStatus(pendingCount: 4));

    expect(find.text('4 changes waiting to back up'), findsOneWidget);
    expect(find.text('Not backed up yet'), findsOneWidget);
  });

  testWidgets('stuck changes are shown with a Retry that retries',
      (tester) async {
    await pumpTile(
      tester,
      BackupStatus(
        stuckCount: 1,
        pendingCount: 2,
        lastBackupAt: DateTime(2026, 10, 12, 18, 5),
      ),
    );

    expect(find.text('1 change not backed up'), findsOneWidget);
    expect(find.text('Last backup: Oct 12, 2026 18:05'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    verify(() => engine.retry()).called(1);
  });

  testWidgets('Settings shows the backup status', (tester) async {
    final overrides = await createTestOverrides();
    await tester.pumpWidget(
      createTestApp(
        child: const SettingsPage(),
        overrides: [
          ...overrides,
          ...overridesFor(const BackupStatus(stuckCount: 2)),
        ],
      ),
    );
    await tester.pump();

    expect(find.text('Backup'), findsOneWidget);
    expect(find.text('2 changes not backed up'), findsOneWidget);
  });
}
