// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budgets_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetsRemoteDataSourceHash() =>
    r'b3244ce8f85fc3e10f0d726cbce2b59e28812aa7';

/// Provides the [BudgetsRemoteDataSource].
///
/// Uses mock implementation when `USE_MOCK_BUDGETS=true` in `.env`.
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
    r'f45591dfd9e40e4b076c12d31f6059bd85912a6f';

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
String _$budgetsSyncHandlerHash() =>
    r'5de8df4423876cd50a28ca6504d42352f9acbfc5';

/// Registers the [BudgetsSyncHandler] with the [SyncEngine].
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
String _$budgetsRepositoryHash() => r'cda7e2c60e19753d1d36fcb0305bdb27816349d3';

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
String _$activeBudgetHash() => r'4f1c65a83716c53587f2a3914cf8d92fb6745d5e';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
