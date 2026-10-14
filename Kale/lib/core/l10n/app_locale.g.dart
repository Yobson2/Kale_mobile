// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_locale.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appStringsHash() => r'c92b09f37043ee049f201cf283bca3b67b25fee4';

/// The app's strings in its current language, for text built outside a
/// widget (notifications): the language picked in Settings, else the
/// device's (French fallback), as [resolveAppLocale] decides for the UI.
///
/// Copied from [appStrings].
@ProviderFor(appStrings)
final appStringsProvider = Provider<AppLocalizations>.internal(
  appStrings,
  name: r'appStringsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appStringsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppStringsRef = ProviderRef<AppLocalizations>;
String _$appLanguageHash() => r'463c9b5e946d92bf883ba468034d4d414e7e1d70';

/// The language the user picked in Settings, or null to follow the device.
///
/// Copied from [AppLanguage].
@ProviderFor(AppLanguage)
final appLanguageProvider = NotifierProvider<AppLanguage, String?>.internal(
  AppLanguage.new,
  name: r'appLanguageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appLanguageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppLanguage = Notifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
