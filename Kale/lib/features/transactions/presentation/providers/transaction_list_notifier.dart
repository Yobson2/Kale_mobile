import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_page.dart';
import 'package:kale/features/transactions/domain/usecases/get_transactions_page_usecase.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_list_notifier.g.dart';

/// What the transaction list shows: the rows loaded so far, page by page.
@immutable
class TransactionListState {
  /// Creates a [TransactionListState].
  const TransactionListState({
    this.transactions = const [],
    this.filter = const TransactionListFilter(),
    this.hasMore = false,
    this.isLoading = true,
    this.isLoadingMore = false,
    this.failed = false,
  });

  /// The rows loaded so far, newest first.
  final List<Transaction> transactions;

  /// The type filter and search in effect.
  final TransactionListFilter filter;

  /// Whether more rows may follow the loaded ones.
  final bool hasMore;

  /// Whether the first page is loading.
  final bool isLoading;

  /// Whether the next page is loading.
  final bool isLoadingMore;

  /// Whether the last load failed.
  final bool failed;

  TransactionListState _copyWith({
    List<Transaction>? transactions,
    TransactionListFilter? filter,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    bool? failed,
  }) =>
      TransactionListState(
        transactions: transactions ?? this.transactions,
        filter: filter ?? this.filter,
        hasMore: hasMore ?? this.hasMore,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        failed: failed ?? this.failed,
      );
}

/// The paginated transaction list (decision Q23).
///
/// Loads [pageSize] rows at a time, keyset-paged on `(date, id)`, so it
/// stays smooth at 10,000 transactions: only what the user scrolled
/// through is in memory. Whenever stored transactions change (added,
/// edited, deleted, pulled) it reloads the rows it already shows, so the
/// list is always current without a manual refresh.
@riverpod
class TransactionList extends _$TransactionList {
  /// Rows per page.
  static const pageSize = 50;

  /// Bumped on every reload, so a slow answer for an older request is
  /// dropped instead of overwriting a newer one.
  int _generation = 0;

  @override
  TransactionListState build() {
    final changes =
        ref.watch(watchTransactionChangesUseCaseProvider).call().listen(
              (_) => _reload(keepLoaded: true),
            );
    ref.onDispose(changes.cancel);
    Future.microtask(() => _reload(keepLoaded: false));
    return const TransactionListState();
  }

  /// Shows only [filter]'s rows, from the first page.
  Future<void> setFilter(TransactionListFilter filter) async {
    if (filter == state.filter) return;
    state = TransactionListState(filter: filter);
    await _reload(keepLoaded: false);
  }

  /// Loads the next page, if there is one and none is loading.
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading || state.isLoadingMore) return;
    final generation = _generation;
    state = state._copyWith(isLoadingMore: true);
    final result = await ref.read(getTransactionsPageUseCaseProvider).call(
          GetTransactionsPageParams(
            filter: state.filter,
            limit: pageSize,
            after: TransactionCursor.of(state.transactions.last),
          ),
        );
    if (generation != _generation) return;
    state = result.fold(
      (_) => state._copyWith(isLoadingMore: false, failed: true),
      (page) => state._copyWith(
        transactions: [...state.transactions, ...page.transactions],
        hasMore: page.hasMore,
        isLoadingMore: false,
        failed: false,
      ),
    );
  }

  /// Loads from the first row: one page, or, when [keepLoaded], every row
  /// down to the last one already shown (so a row on screen never drops
  /// off because one was added above it), plus at most one page of new
  /// rows. Rows past that stay reachable through [loadMore].
  Future<void> _reload({required bool keepLoaded}) async {
    final generation = ++_generation;
    final shown = state.transactions;
    final until = keepLoaded && shown.isNotEmpty
        ? TransactionCursor.of(shown.last)
        : null;
    final limit = until == null ? pageSize : shown.length + pageSize;
    final hadMore = state.hasMore;
    final result = await ref.read(getTransactionsPageUseCaseProvider).call(
          GetTransactionsPageParams(
            filter: state.filter,
            limit: limit,
            until: until,
          ),
        );
    if (generation != _generation) return;
    state = result.fold(
      (_) => state._copyWith(isLoading: false, failed: true),
      (page) => state._copyWith(
        transactions: page.transactions,
        // Bounded by [until], a short page still has the old rows after it.
        hasMore: page.hasMore || (until != null && hadMore),
        isLoading: false,
        isLoadingMore: false,
        failed: false,
      ),
    );
  }
}
