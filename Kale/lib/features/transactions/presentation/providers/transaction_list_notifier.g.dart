// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionListHash() => r'cb30bd6c10eabbb80818304f4df6be13c0789816';

/// The paginated transaction list (decision Q23).
///
/// Loads [pageSize] rows at a time, keyset-paged on `(date, id)`, so it
/// stays smooth at 10,000 transactions: only what the user scrolled
/// through is in memory. Whenever stored transactions change (added,
/// edited, deleted, pulled) it reloads the rows it already shows, so the
/// list is always current without a manual refresh.
///
/// Copied from [TransactionList].
@ProviderFor(TransactionList)
final transactionListProvider =
    AutoDisposeNotifierProvider<TransactionList, TransactionListState>.internal(
  TransactionList.new,
  name: r'transactionListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionList = AutoDisposeNotifier<TransactionListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
