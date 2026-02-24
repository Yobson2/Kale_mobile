// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardRepositoryHash() =>
    r'7294b66db3dae306621d5be023fc95789a899fdc';

/// Provides the [DashboardRepository] implementation.
///
/// Copied from [dashboardRepository].
@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider =
    AutoDisposeProvider<DashboardRepository>.internal(
  dashboardRepository,
  name: r'dashboardRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardRepositoryRef = AutoDisposeProviderRef<DashboardRepository>;
String _$categoryNamesHash() => r'6b40114147cd865cc17f38e549c78c67a9c38af9';

/// Provides a category ID to display name lookup map.
///
/// Used by the budget page and other screens that need to resolve
/// category IDs to human-readable names.
///
/// Copied from [categoryNames].
@ProviderFor(categoryNames)
final categoryNamesProvider =
    AutoDisposeFutureProvider<Map<String, String>>.internal(
  categoryNames,
  name: r'categoryNamesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoryNamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryNamesRef = AutoDisposeFutureProviderRef<Map<String, String>>;
String _$dashboardSummaryHash() => r'e3413ff017a0ad6daa8b4a5a841d81fb54386959';

/// Provides the [DashboardSummary] for the currently selected period.
///
/// Copied from [dashboardSummary].
@ProviderFor(dashboardSummary)
final dashboardSummaryProvider =
    AutoDisposeFutureProvider<DashboardSummary>.internal(
  dashboardSummary,
  name: r'dashboardSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardSummaryRef = AutoDisposeFutureProviderRef<DashboardSummary>;
String _$dashboardPeriodNotifierHash() =>
    r'dbb3ffbadb0df776a1556f818dbbf083662851a5';

/// Manages the selected dashboard period.
///
/// Copied from [DashboardPeriodNotifier].
@ProviderFor(DashboardPeriodNotifier)
final dashboardPeriodNotifierProvider = AutoDisposeNotifierProvider<
    DashboardPeriodNotifier, DashboardPeriod>.internal(
  DashboardPeriodNotifier.new,
  name: r'dashboardPeriodNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardPeriodNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DashboardPeriodNotifier = AutoDisposeNotifier<DashboardPeriod>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
