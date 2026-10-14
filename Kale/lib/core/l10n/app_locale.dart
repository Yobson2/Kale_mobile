import 'package:flutter/widgets.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_locale.g.dart';

/// The languages Kalé is written in. French first: it is the primary
/// language and the fallback (decisions Q1, Q14).
const appLanguages = ['fr', 'en'];

/// The fallback when the device's language is not one of [appLanguages].
const fallbackLocale = Locale('fr');

/// The locale the app runs in for [device]: its language if Kalé speaks it,
/// otherwise French. Region and script are dropped, so formatting is the
/// language's default (`fr` → `10 000 FCFA`, `13 oct. 2026`).
Locale resolveAppLocale(Locale? device) {
  final language = device?.languageCode;
  return language != null && appLanguages.contains(language)
      ? Locale(language)
      : fallbackLocale;
}

/// The language the user picked in Settings, or null to follow the device.
@Riverpod(keepAlive: true)
class AppLanguage extends _$AppLanguage {
  static const _followDevice = 'system';

  @override
  String? build() {
    final stored = ref.read(localStorageProvider).getLocale();
    return appLanguages.contains(stored) ? stored : null;
  }

  /// Uses [language] (one of [appLanguages]), or follows the device when
  /// null. Persisted across restarts.
  Future<void> select(String? language) async {
    assert(language == null || appLanguages.contains(language), language);
    state = language;
    await ref.read(localStorageProvider).setLocale(language ?? _followDevice);
  }
}
