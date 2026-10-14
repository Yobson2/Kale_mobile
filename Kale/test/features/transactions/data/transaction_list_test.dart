import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/features/transactions/data/models/transaction_model.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/entities/transaction_page.dart';
import 'package:kale/features/transactions/presentation/providers/transaction_list_notifier.dart';

import '../../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  /// Stores [count] transactions straight in the database: 10 per day,
  /// so many rows share a date and page boundaries fall inside a day.
  Future<List<String>> seed(int count) async {
    final ids = <String>[];
    final rows = [
      for (var i = 0; i < count; i++)
        TransactionModel(
          id: 'tx-${i.toString().padLeft(5, '0')}',
          amountMinor: 100 + i,
          type: i.isEven ? 'expense' : 'income',
          categoryId: i % 3 == 0 ? 'cat_food' : 'cat_transport',
          description: i % 7 == 0 ? 'Marché du soir' : null,
          date: DateTime(2026).add(Duration(days: i ~/ 10)),
          paymentMethod: 'cash',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
    ];
    for (final row in rows) {
      ids.add(row.id);
    }
    await harness.db.transactionsDao.upsertAll([
      for (final row in rows) row.toDriftCompanion(isSynced: true),
    ]);
    return ids;
  }

  group('keyset pages over (date, id)', () {
    test('return every live transaction exactly once, newest first', () async {
      final ids = await seed(10000);
      final dao = harness.db.transactionsDao;

      final seen = <String>[];
      DateTime? afterDate;
      String? afterId;
      var pages = 0;
      while (true) {
        final page = await dao.getPage(
          limit: 50,
          afterDate: afterDate,
          afterId: afterId,
        );
        if (page.isEmpty) break;
        pages++;
        seen.addAll(page.map((t) => t.id));
        afterDate = page.last.date;
        afterId = page.last.id;
      }

      expect(pages, 200);
      expect(seen, hasLength(10000));
      expect(seen.toSet(), ids.toSet());
      // Newest date first; within a date, highest id first.
      final rows = await dao.getPage(limit: 12);
      expect(rows.map((r) => r.id).take(10), [
        for (var i = 9999; i >= 9990; i--) 'tx-${i.toString().padLeft(5, '0')}',
      ]);
    });

    test('skip deleted transactions', () async {
      await seed(30);
      await harness.db.transactionsDao.markDeleted('tx-00029', DateTime(2026));

      final page = await harness.db.transactionsDao.getPage(limit: 100);

      expect(page, hasLength(29));
      expect(page.map((t) => t.id), isNot(contains('tx-00029')));
    });
  });

  group('the transaction list', () {
    late ProviderSubscription<TransactionListState> list;

    Future<TransactionListState> settled() async {
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      return list.read();
    }

    Future<void> openList() async {
      list = harness.listen(transactionListProvider);
      await settled();
    }

    TransactionList notifier() =>
        harness.read(transactionListProvider.notifier);

    test('opens with one page of 10,000, and scrolling loads them all',
        () async {
      await seed(10000);
      await openList();

      expect(list.read().transactions, hasLength(TransactionList.pageSize));
      expect(list.read().hasMore, isTrue);

      while (list.read().hasMore) {
        await notifier().loadMore();
      }

      final all = list.read().transactions.map((t) => t.id).toList();
      expect(all, hasLength(10000));
      expect(all.toSet(), hasLength(10000));
    });

    test('a new transaction appears without a refresh', () async {
      await seed(120);
      await openList();
      await notifier().loadMore();
      expect(list.read().transactions, hasLength(100));

      final created = await harness.addTransaction(date: DateTime(2027));
      final state = await settled();

      expect(state.transactions.first.id, created.id);
      // The rows already shown stay shown.
      expect(state.transactions, hasLength(101));
    });

    test('a deleted transaction disappears without a refresh', () async {
      await seed(20);
      await openList();

      await harness.transactions.deleteTransaction('tx-00019');
      final state = await settled();

      expect(state.transactions.map((t) => t.id), isNot(contains('tx-00019')));
      expect(state.transactions, hasLength(19));
    });

    test('filters by type and by search, across pages', () async {
      await seed(300);
      await openList();

      await notifier().setFilter(
        const TransactionListFilter(type: TransactionType.expense),
      );
      while (list.read().hasMore) {
        await notifier().loadMore();
      }
      expect(list.read().transactions, hasLength(150));
      expect(
        list.read().transactions.map((t) => t.type),
        everyElement(TransactionType.expense),
      );

      await notifier().setFilter(
        const TransactionListFilter(search: 'marché'),
      );
      while (list.read().hasMore) {
        await notifier().loadMore();
      }
      // i % 7 == 0 for i in 0..299: 43 rows.
      expect(list.read().transactions, hasLength(43));

      await notifier().setFilter(
        const TransactionListFilter(
          search: 'food',
          searchCategoryIds: {'cat_food'},
        ),
      );
      while (list.read().hasMore) {
        await notifier().loadMore();
      }
      // i % 3 == 0: 100 rows.
      expect(list.read().transactions, hasLength(100));
    });
  });
}
