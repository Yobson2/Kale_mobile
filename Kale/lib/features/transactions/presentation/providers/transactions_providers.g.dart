// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsRemoteDataSourceHash() =>
    r'cde025ec48db353c77dd4e608bbb7d3739e0d61d';

/// Provides the [TransactionsRemoteDataSource].
///
/// Set `USE_MOCK_TRANSACTIONS=true` in `.env` to use mock data for testing.
///
/// Copied from [transactionsRemoteDataSource].
@ProviderFor(transactionsRemoteDataSource)
final transactionsRemoteDataSourceProvider =
    AutoDisposeProvider<TransactionsRemoteDataSource>.internal(
  transactionsRemoteDataSource,
  name: r'transactionsRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsRemoteDataSourceRef
    = AutoDisposeProviderRef<TransactionsRemoteDataSource>;
String _$transactionsLocalDataSourceHash() =>
    r'b195d47fa396bf36c81cd2da83c348fc371170cc';

/// Provides the [TransactionsLocalDataSource].
///
/// Copied from [transactionsLocalDataSource].
@ProviderFor(transactionsLocalDataSource)
final transactionsLocalDataSourceProvider =
    AutoDisposeProvider<TransactionsLocalDataSource>.internal(
  transactionsLocalDataSource,
  name: r'transactionsLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsLocalDataSourceRef
    = AutoDisposeProviderRef<TransactionsLocalDataSource>;
String _$categoriesStreamHash() => r'e485ff15e552f2f17fde2861cd47ac544f37e55a';

/// Provides a simple categories local data source from the database DAO.
///
/// Copied from [categoriesStream].
@ProviderFor(categoriesStream)
final categoriesStreamProvider =
    AutoDisposeStreamProvider<List<Category>>.internal(
  categoriesStream,
  name: r'categoriesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoriesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesStreamRef = AutoDisposeStreamProviderRef<List<Category>>;
String _$transactionsSyncHandlerHash() =>
    r'1198aefa42233cdae558a41ba9182ee6bd322c24';

/// Registers the [TransactionsSyncHandler] with the [SyncEngine].
///
/// This provider ensures the handler is registered once. It should be
/// read before using the repository to guarantee sync is wired up.
///
/// Copied from [transactionsSyncHandler].
@ProviderFor(transactionsSyncHandler)
final transactionsSyncHandlerProvider =
    AutoDisposeProvider<TransactionsSyncHandler>.internal(
  transactionsSyncHandler,
  name: r'transactionsSyncHandlerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsSyncHandlerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsSyncHandlerRef
    = AutoDisposeProviderRef<TransactionsSyncHandler>;
String _$transactionsRepositoryHash() =>
    r'5134af1fee52f9d5435407eb7a74dcd3fdb5437d';

/// Provides the [TransactionsRepository].
///
/// Ensures the sync handler is registered before returning the repository.
///
/// Copied from [transactionsRepository].
@ProviderFor(transactionsRepository)
final transactionsRepositoryProvider =
    AutoDisposeProvider<TransactionsRepository>.internal(
  transactionsRepository,
  name: r'transactionsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsRepositoryRef
    = AutoDisposeProviderRef<TransactionsRepository>;
String _$transactionsStreamHash() =>
    r'050dd0ddff0d2839761bee7997da0b32559ffb3b';

/// Watches transactions reactively from the repository stream.
///
/// Copied from [transactionsStream].
@ProviderFor(transactionsStream)
final transactionsStreamProvider =
    AutoDisposeStreamProvider<List<Transaction>>.internal(
  transactionsStream,
  name: r'transactionsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsStreamRef = AutoDisposeStreamProviderRef<List<Transaction>>;
String _$createTransactionUseCaseHash() =>
    r'438d73e6e3c2d162b7cbd95aae0ca2201faed957';

/// Provides the [CreateTransactionUseCase].
///
/// Copied from [createTransactionUseCase].
@ProviderFor(createTransactionUseCase)
final createTransactionUseCaseProvider =
    AutoDisposeProvider<CreateTransactionUseCase>.internal(
  createTransactionUseCase,
  name: r'createTransactionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createTransactionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateTransactionUseCaseRef
    = AutoDisposeProviderRef<CreateTransactionUseCase>;
String _$updateTransactionUseCaseHash() =>
    r'f6e0b420bac2809e4f4d0dde87af46a61944d838';

/// Provides the [UpdateTransactionUseCase].
///
/// Copied from [updateTransactionUseCase].
@ProviderFor(updateTransactionUseCase)
final updateTransactionUseCaseProvider =
    AutoDisposeProvider<UpdateTransactionUseCase>.internal(
  updateTransactionUseCase,
  name: r'updateTransactionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateTransactionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateTransactionUseCaseRef
    = AutoDisposeProviderRef<UpdateTransactionUseCase>;
String _$deleteTransactionUseCaseHash() =>
    r'a4f9253b631036b7207dbd476996c9120cceeb58';

/// Provides the [DeleteTransactionUseCase].
///
/// Copied from [deleteTransactionUseCase].
@ProviderFor(deleteTransactionUseCase)
final deleteTransactionUseCaseProvider =
    AutoDisposeProvider<DeleteTransactionUseCase>.internal(
  deleteTransactionUseCase,
  name: r'deleteTransactionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteTransactionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteTransactionUseCaseRef
    = AutoDisposeProviderRef<DeleteTransactionUseCase>;
String _$getTransactionsUseCaseHash() =>
    r'c37674c52d0c2c39159c98a30d5cf23fc3d614d0';

/// Provides the [GetTransactionsUseCase].
///
/// Copied from [getTransactionsUseCase].
@ProviderFor(getTransactionsUseCase)
final getTransactionsUseCaseProvider =
    AutoDisposeProvider<GetTransactionsUseCase>.internal(
  getTransactionsUseCase,
  name: r'getTransactionsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTransactionsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTransactionsUseCaseRef
    = AutoDisposeProviderRef<GetTransactionsUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
