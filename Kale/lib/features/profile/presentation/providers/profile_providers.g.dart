// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileRemoteDataSourceHash() =>
    r'a53da7b6420205ab6724414c4a04741c193b6c45';

/// Provides the [ProfileRemoteDataSource].
///
/// Mocked whenever auth is mocked (`USE_MOCK_AUTH`): without a real
/// Supabase user there is no `profiles` row to write.
///
/// Copied from [profileRemoteDataSource].
@ProviderFor(profileRemoteDataSource)
final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>.internal(
  profileRemoteDataSource,
  name: r'profileRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileRemoteDataSourceRef = ProviderRef<ProfileRemoteDataSource>;
String _$profileLocalDataSourceHash() =>
    r'f4f433795a9ac1bd6c00ffbe6299778a77fef4ae';

/// Provides the [ProfileLocalDataSource].
///
/// Copied from [profileLocalDataSource].
@ProviderFor(profileLocalDataSource)
final profileLocalDataSourceProvider =
    AutoDisposeProvider<ProfileLocalDataSource>.internal(
  profileLocalDataSource,
  name: r'profileLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileLocalDataSourceRef
    = AutoDisposeProviderRef<ProfileLocalDataSource>;
String _$profileSyncHandlerHash() =>
    r'77c08d58425e98f76948cabae051d390fd954758';

/// Provides the [ProfileSyncHandler].
///
/// Registered with the sync engine through `syncHandlersProvider`.
///
/// Copied from [profileSyncHandler].
@ProviderFor(profileSyncHandler)
final profileSyncHandlerProvider = Provider<ProfileSyncHandler>.internal(
  profileSyncHandler,
  name: r'profileSyncHandlerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileSyncHandlerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileSyncHandlerRef = ProviderRef<ProfileSyncHandler>;
String _$profileRepositoryHash() => r'9e98bc28ed18e857c465a682667ee38028f639a0';

/// Provides the [ProfileRepository].
///
/// Copied from [profileRepository].
@ProviderFor(profileRepository)
final profileRepositoryProvider =
    AutoDisposeProvider<ProfileRepository>.internal(
  profileRepository,
  name: r'profileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileRepositoryRef = AutoDisposeProviderRef<ProfileRepository>;
String _$changeBaseCurrencyUseCaseHash() =>
    r'a1be5055656905e486308df0140bf35c91b87ff3';

/// Provides the [ChangeBaseCurrencyUseCase].
///
/// Copied from [changeBaseCurrencyUseCase].
@ProviderFor(changeBaseCurrencyUseCase)
final changeBaseCurrencyUseCaseProvider =
    AutoDisposeProvider<ChangeBaseCurrencyUseCase>.internal(
  changeBaseCurrencyUseCase,
  name: r'changeBaseCurrencyUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$changeBaseCurrencyUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChangeBaseCurrencyUseCaseRef
    = AutoDisposeProviderRef<ChangeBaseCurrencyUseCase>;
String _$storedBaseCurrencyHash() =>
    r'576edbb60c4bcba896905ff20dd75f727893976c';

/// Watches the stored base currency; null until the user has chosen one.
///
/// Copied from [storedBaseCurrency].
@ProviderFor(storedBaseCurrency)
final storedBaseCurrencyProvider =
    AutoDisposeStreamProvider<Currency?>.internal(
  storedBaseCurrency,
  name: r'storedBaseCurrencyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storedBaseCurrencyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoredBaseCurrencyRef = AutoDisposeStreamProviderRef<Currency?>;
String _$baseCurrencyHash() => r'd78a93fbe23c753163e1bb2468d319860c39239c';

/// The account's base currency, in which every amount is entered, stored,
/// and shown. Falls back to [defaultBaseCurrency] until one is chosen.
///
/// Copied from [baseCurrency].
@ProviderFor(baseCurrency)
final baseCurrencyProvider = AutoDisposeProvider<Currency>.internal(
  baseCurrency,
  name: r'baseCurrencyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$baseCurrencyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BaseCurrencyRef = AutoDisposeProviderRef<Currency>;
String _$baseCurrencyControllerHash() =>
    r'a58aaeb91e8c7b438ebeb8d1b5deb95c53e02ccf';

/// Changes the base currency through [ChangeBaseCurrencyUseCase].
///
/// Copied from [BaseCurrencyController].
@ProviderFor(BaseCurrencyController)
final baseCurrencyControllerProvider =
    AutoDisposeAsyncNotifierProvider<BaseCurrencyController, void>.internal(
  BaseCurrencyController.new,
  name: r'baseCurrencyControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$baseCurrencyControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BaseCurrencyController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
