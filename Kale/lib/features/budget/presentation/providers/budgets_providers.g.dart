// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budgets_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetsRemoteDataSourceHash() =>
    r'343007ab39526e6046668f453538f6b1552b2171';

/// Provides the [BudgetsRemoteDataSource].
///
/// Uses the in-memory mock when the `USE_MOCK_BUDGETS` define is true.
///
/// Copied from [budgetsRemoteDataSource].
@ProviderFor(budgetsRemoteDataSource)
final budgetsRemoteDataSourceProvider =
    AutoDisposeProvider<BudgetsRemoteDataSource>.internal(
  budgetsRemoteDataSource,
  name: r'budgetsRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetsRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetsRemoteDataSourceRef
    = AutoDisposeProviderRef<BudgetsRemoteDataSource>;
String _$budgetsLocalDataSourceHash() =>
    r'b4a8f7c4b754b9af759fb09c0f3ea20c19a9b913';

/// Provides the [BudgetsLocalDataSource].
///
/// Copied from [budgetsLocalDataSource].
@ProviderFor(budgetsLocalDataSource)
final budgetsLocalDataSourceProvider =
    AutoDisposeProvider<BudgetsLocalDataSource>.internal(
  budgetsLocalDataSource,
  name: r'budgetsLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetsLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetsLocalDataSourceRef
    = AutoDisposeProviderRef<BudgetsLocalDataSource>;
String _$budgetCategoriesRemoteDataSourceHash() =>
    r'4aebde0a88feaea058af0084db6a0e78f1b4ce70';

/// Provides the [BudgetCategoriesRemoteDataSource]; mocked with budgets
/// (`USE_MOCK_BUDGETS`).
///
/// Copied from [budgetCategoriesRemoteDataSource].
@ProviderFor(budgetCategoriesRemoteDataSource)
final budgetCategoriesRemoteDataSourceProvider =
    AutoDisposeProvider<BudgetCategoriesRemoteDataSource>.internal(
  budgetCategoriesRemoteDataSource,
  name: r'budgetCategoriesRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetCategoriesRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetCategoriesRemoteDataSourceRef
    = AutoDisposeProviderRef<BudgetCategoriesRemoteDataSource>;
String _$budgetCategoriesLocalDataSourceHash() =>
    r'440999938244a7dbd05a16f0d03592a2ddb7381b';

/// Provides the [BudgetCategoriesLocalDataSource].
///
/// Copied from [budgetCategoriesLocalDataSource].
@ProviderFor(budgetCategoriesLocalDataSource)
final budgetCategoriesLocalDataSourceProvider =
    AutoDisposeProvider<BudgetCategoriesLocalDataSource>.internal(
  budgetCategoriesLocalDataSource,
  name: r'budgetCategoriesLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetCategoriesLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetCategoriesLocalDataSourceRef
    = AutoDisposeProviderRef<BudgetCategoriesLocalDataSource>;
String _$budgetsSyncHandlerHash() =>
    r'353a4a357cdc29fba72ac7ab384a9b0c5f7d3328';

/// Provides the [BudgetsSyncHandler].
///
/// Registered with the sync engine through `syncHandlersProvider`.
///
/// Copied from [budgetsSyncHandler].
@ProviderFor(budgetsSyncHandler)
final budgetsSyncHandlerProvider = Provider<BudgetsSyncHandler>.internal(
  budgetsSyncHandler,
  name: r'budgetsSyncHandlerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetsSyncHandlerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetsSyncHandlerRef = ProviderRef<BudgetsSyncHandler>;
String _$budgetCategoriesSyncHandlerHash() =>
    r'258b7648ec4acd10c532c02b4f27ef489abb19b2';

/// Provides the [BudgetCategoriesSyncHandler].
///
/// Registered with the sync engine through `syncHandlersProvider`.
///
/// Copied from [budgetCategoriesSyncHandler].
@ProviderFor(budgetCategoriesSyncHandler)
final budgetCategoriesSyncHandlerProvider =
    Provider<BudgetCategoriesSyncHandler>.internal(
  budgetCategoriesSyncHandler,
  name: r'budgetCategoriesSyncHandlerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetCategoriesSyncHandlerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetCategoriesSyncHandlerRef
    = ProviderRef<BudgetCategoriesSyncHandler>;
String _$budgetsRepositoryHash() => r'3891f3146ae87012ebb0154de3bcf590e9c0ac09';

/// Provides the [BudgetsRepository].
///
/// Copied from [budgetsRepository].
@ProviderFor(budgetsRepository)
final budgetsRepositoryProvider =
    AutoDisposeProvider<BudgetsRepository>.internal(
  budgetsRepository,
  name: r'budgetsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetsRepositoryRef = AutoDisposeProviderRef<BudgetsRepository>;
String _$budgetsStreamHash() => r'af7fbfb8945d53c4667b6d1fee788d8fd65f3a64';

/// Watches all budgets reactively from the local database.
///
/// Copied from [budgetsStream].
@ProviderFor(budgetsStream)
final budgetsStreamProvider = AutoDisposeStreamProvider<List<Budget>>.internal(
  budgetsStream,
  name: r'budgetsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetsStreamRef = AutoDisposeStreamProviderRef<List<Budget>>;
String _$activeBudgetHash() => r'7ce02e55922afdc0ffce5246148ea5039616da99';

/// Provides the currently active budget (with enriched spent amounts).
///
/// Copied from [activeBudget].
@ProviderFor(activeBudget)
final activeBudgetProvider = AutoDisposeFutureProvider<Budget?>.internal(
  activeBudget,
  name: r'activeBudgetProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeBudgetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveBudgetRef = AutoDisposeFutureProviderRef<Budget?>;
String _$budgetToRenewHash() => r'6ab232715bde1cf2bc524a641ae46ddc7b1d5f6d';

/// The ended budget to offer renewing, when no budget covers today (see
/// `GetBudgetToRenewUseCase`).
///
/// Copied from [budgetToRenew].
@ProviderFor(budgetToRenew)
final budgetToRenewProvider = AutoDisposeFutureProvider<Budget?>.internal(
  budgetToRenew,
  name: r'budgetToRenewProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetToRenewHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetToRenewRef = AutoDisposeFutureProviderRef<Budget?>;
String _$createBudgetUseCaseHash() =>
    r'f3526a8ef64c7f98f779bb4c42091e5be5b1efe9';

/// Provides the [CreateBudgetUseCase].
///
/// Copied from [createBudgetUseCase].
@ProviderFor(createBudgetUseCase)
final createBudgetUseCaseProvider =
    AutoDisposeProvider<CreateBudgetUseCase>.internal(
  createBudgetUseCase,
  name: r'createBudgetUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createBudgetUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateBudgetUseCaseRef = AutoDisposeProviderRef<CreateBudgetUseCase>;
String _$deleteBudgetUseCaseHash() =>
    r'89548d5dd15541385e5d50ce896e8ba15e6efd17';

/// Provides the [DeleteBudgetUseCase].
///
/// Copied from [deleteBudgetUseCase].
@ProviderFor(deleteBudgetUseCase)
final deleteBudgetUseCaseProvider =
    AutoDisposeProvider<DeleteBudgetUseCase>.internal(
  deleteBudgetUseCase,
  name: r'deleteBudgetUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteBudgetUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteBudgetUseCaseRef = AutoDisposeProviderRef<DeleteBudgetUseCase>;
String _$updateBudgetUseCaseHash() =>
    r'72da0a10ffcf6d9c07d3ddb5e4abd0455d215f59';

/// Provides the [UpdateBudgetUseCase].
///
/// Copied from [updateBudgetUseCase].
@ProviderFor(updateBudgetUseCase)
final updateBudgetUseCaseProvider =
    AutoDisposeProvider<UpdateBudgetUseCase>.internal(
  updateBudgetUseCase,
  name: r'updateBudgetUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateBudgetUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateBudgetUseCaseRef = AutoDisposeProviderRef<UpdateBudgetUseCase>;
String _$getActiveBudgetUseCaseHash() =>
    r'1372b8a98e125ada94b53a86e2d324717fffda14';

/// Provides the [GetActiveBudgetUseCase].
///
/// Copied from [getActiveBudgetUseCase].
@ProviderFor(getActiveBudgetUseCase)
final getActiveBudgetUseCaseProvider =
    AutoDisposeProvider<GetActiveBudgetUseCase>.internal(
  getActiveBudgetUseCase,
  name: r'getActiveBudgetUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getActiveBudgetUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetActiveBudgetUseCaseRef
    = AutoDisposeProviderRef<GetActiveBudgetUseCase>;
String _$renewBudgetUseCaseHash() =>
    r'844be4a0c8ccc454c6a86edcb06ea0fd348337ed';

/// Provides the [RenewBudgetUseCase].
///
/// Copied from [renewBudgetUseCase].
@ProviderFor(renewBudgetUseCase)
final renewBudgetUseCaseProvider =
    AutoDisposeProvider<RenewBudgetUseCase>.internal(
  renewBudgetUseCase,
  name: r'renewBudgetUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$renewBudgetUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RenewBudgetUseCaseRef = AutoDisposeProviderRef<RenewBudgetUseCase>;
String _$getBudgetToRenewUseCaseHash() =>
    r'42c0d8483ed3ef305d84d0277bfecf33577f0e47';

/// Provides the [GetBudgetToRenewUseCase].
///
/// Copied from [getBudgetToRenewUseCase].
@ProviderFor(getBudgetToRenewUseCase)
final getBudgetToRenewUseCaseProvider =
    AutoDisposeProvider<GetBudgetToRenewUseCase>.internal(
  getBudgetToRenewUseCase,
  name: r'getBudgetToRenewUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getBudgetToRenewUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetBudgetToRenewUseCaseRef
    = AutoDisposeProviderRef<GetBudgetToRenewUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
