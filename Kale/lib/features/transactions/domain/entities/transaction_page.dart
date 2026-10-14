import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:meta/meta.dart';

/// Where a page of the transaction list ends: the `(date, id)` of its last
/// row. The next page starts strictly after it (newest first).
@immutable
class TransactionCursor {
  /// Creates a [TransactionCursor].
  const TransactionCursor(this.date, this.id);

  /// The cursor of [transaction].
  TransactionCursor.of(Transaction transaction)
      : this(transaction.date, transaction.id);

  /// The row's date.
  final DateTime date;

  /// The row's id, which orders rows on the same date.
  final String id;

  @override
  bool operator ==(Object other) =>
      other is TransactionCursor && other.date == date && other.id == id;

  @override
  int get hashCode => Object.hash(date, id);
}

/// What the transaction list shows.
@immutable
class TransactionListFilter {
  /// Creates a [TransactionListFilter].
  const TransactionListFilter({
    this.type,
    this.search = '',
    this.searchCategoryIds = const {},
  });

  /// Only this type, or every type when null.
  final TransactionType? type;

  /// Text the description must contain (case-insensitive), unless the
  /// category is one of [searchCategoryIds]. Empty: no search.
  final String search;

  /// Categories whose name matches [search].
  final Set<String> searchCategoryIds;

  @override
  bool operator ==(Object other) =>
      other is TransactionListFilter &&
      other.type == type &&
      other.search == search &&
      other.searchCategoryIds.length == searchCategoryIds.length &&
      other.searchCategoryIds.containsAll(searchCategoryIds);

  @override
  int get hashCode => Object.hash(type, search, searchCategoryIds.length);
}

/// One page of the transaction list.
@immutable
class TransactionPage {
  /// Creates a [TransactionPage].
  const TransactionPage(this.transactions, {required this.hasMore});

  /// The page's rows, newest first.
  final List<Transaction> transactions;

  /// Whether more rows may follow (the page was full).
  final bool hasMore;
}
