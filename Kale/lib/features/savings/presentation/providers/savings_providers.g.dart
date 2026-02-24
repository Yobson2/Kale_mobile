// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$savingsRemoteDataSourceHash() =>
    r'c7b3e1506c8d83628c395225d9e63ea751ef0163';

/// Provides the [SavingsRemoteDataSource].
///
/// Copied from [savingsRemoteDataSource].
@ProviderFor(savingsRemoteDataSource)
final savingsRemoteDataSourceProvider =
    AutoDisposeProvider<SavingsRemoteDataSource>.internal(
  savingsRemoteDataSource,
  name: r'savingsRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$savingsRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SavingsRemoteDataSourceRef
    = AutoDisposeProviderRef<SavingsRemoteDataSource>;
String _$savingsLocalDataSourceHash() =>
    r'b508f9e1c11091fa7bfe8b0826bfb7bbebc488c3';

/// Provides the [SavingsLocalDataSource].
///
/// Copied from [savingsLocalDataSource].
@ProviderFor(savingsLocalDataSource)
final savingsLocalDataSourceProvider =
    AutoDisposeProvider<SavingsLocalDataSource>.internal(
  savingsLocalDataSource,
  name: r'savingsLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$savingsLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SavingsLocalDataSourceRef
    = AutoDisposeProviderRef<SavingsLocalDataSource>;
String _$savingsRepositoryHash() => r'e04d62c7f85b5d92f95035a6e36ce9ba1e16d049';

/// Provides the [SavingsRepository].
///
/// Copied from [savingsRepository].
@ProviderFor(savingsRepository)
final savingsRepositoryProvider =
    AutoDisposeProvider<SavingsRepository>.internal(
  savingsRepository,
  name: r'savingsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$savingsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SavingsRepositoryRef = AutoDisposeProviderRef<SavingsRepository>;
String _$savingsGoalsStreamHash() =>
    r'f1feae25b9f0ca8e50a2a28be6982f8641bc356f';

/// Watches all savings goals reactively.
///
/// Copied from [savingsGoalsStream].
@ProviderFor(savingsGoalsStream)
final savingsGoalsStreamProvider =
    AutoDisposeStreamProvider<List<SavingsGoal>>.internal(
  savingsGoalsStream,
  name: r'savingsGoalsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$savingsGoalsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SavingsGoalsStreamRef = AutoDisposeStreamProviderRef<List<SavingsGoal>>;
String _$savingsContributionsStreamHash() =>
    r'26da702d25fa601aac62af769c3a16a063476785';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Watches contributions for a specific goal.
///
/// Copied from [savingsContributionsStream].
@ProviderFor(savingsContributionsStream)
const savingsContributionsStreamProvider = SavingsContributionsStreamFamily();

/// Watches contributions for a specific goal.
///
/// Copied from [savingsContributionsStream].
class SavingsContributionsStreamFamily
    extends Family<AsyncValue<List<SavingsContribution>>> {
  /// Watches contributions for a specific goal.
  ///
  /// Copied from [savingsContributionsStream].
  const SavingsContributionsStreamFamily();

  /// Watches contributions for a specific goal.
  ///
  /// Copied from [savingsContributionsStream].
  SavingsContributionsStreamProvider call(
    String goalId,
  ) {
    return SavingsContributionsStreamProvider(
      goalId,
    );
  }

  @override
  SavingsContributionsStreamProvider getProviderOverride(
    covariant SavingsContributionsStreamProvider provider,
  ) {
    return call(
      provider.goalId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'savingsContributionsStreamProvider';
}

/// Watches contributions for a specific goal.
///
/// Copied from [savingsContributionsStream].
class SavingsContributionsStreamProvider
    extends AutoDisposeStreamProvider<List<SavingsContribution>> {
  /// Watches contributions for a specific goal.
  ///
  /// Copied from [savingsContributionsStream].
  SavingsContributionsStreamProvider(
    String goalId,
  ) : this._internal(
          (ref) => savingsContributionsStream(
            ref as SavingsContributionsStreamRef,
            goalId,
          ),
          from: savingsContributionsStreamProvider,
          name: r'savingsContributionsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$savingsContributionsStreamHash,
          dependencies: SavingsContributionsStreamFamily._dependencies,
          allTransitiveDependencies:
              SavingsContributionsStreamFamily._allTransitiveDependencies,
          goalId: goalId,
        );

  SavingsContributionsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.goalId,
  }) : super.internal();

  final String goalId;

  @override
  Override overrideWith(
    Stream<List<SavingsContribution>> Function(
            SavingsContributionsStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SavingsContributionsStreamProvider._internal(
        (ref) => create(ref as SavingsContributionsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        goalId: goalId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<SavingsContribution>> createElement() {
    return _SavingsContributionsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SavingsContributionsStreamProvider &&
        other.goalId == goalId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, goalId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SavingsContributionsStreamRef
    on AutoDisposeStreamProviderRef<List<SavingsContribution>> {
  /// The parameter `goalId` of this provider.
  String get goalId;
}

class _SavingsContributionsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<SavingsContribution>>
    with SavingsContributionsStreamRef {
  _SavingsContributionsStreamProviderElement(super.provider);

  @override
  String get goalId => (origin as SavingsContributionsStreamProvider).goalId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
