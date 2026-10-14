import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/l10n/app_locale.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/l10n/app_localizations.dart';

/// Replaces the no-break spaces `intl` uses as French separators with plain
/// spaces, so expectations read naturally.
String plainSpaces(String text) => text.replaceAll(RegExp('[  ]'), ' ');

void main() {
  group('resolveAppLocale', () {
    test('keeps a language Kalé speaks, without its region', () {
      expect(resolveAppLocale(const Locale('fr', 'SN')), const Locale('fr'));
      expect(resolveAppLocale(const Locale('en', 'GH')), const Locale('en'));
    });

    test('falls back to French for any other language, or none', () {
      expect(resolveAppLocale(const Locale('wo', 'SN')), const Locale('fr'));
      expect(resolveAppLocale(const Locale('de')), const Locale('fr'));
      expect(resolveAppLocale(null), const Locale('fr'));
    });
  });

  group('ARB files', () {
    Map<String, dynamic> read(String name) =>
        jsonDecode(File('lib/l10n/$name').readAsStringSync())
            as Map<String, dynamic>;

    Set<String> placeholders(Map<String, dynamic> arb, String key) {
      final meta = arb['@$key'] as Map<String, dynamic>?;
      final declared = meta?['placeholders'] as Map<String, dynamic>?;
      if (declared != null) return declared.keys.toSet();
      // Undeclared placeholders, read from the message itself.
      return RegExp(r'\{(\w+)[,}]')
          .allMatches(arb[key] as String)
          .map((m) => m[1]!)
          .toSet();
    }

    test('French is the template', () {
      expect(
        File('l10n.yaml').readAsStringSync(),
        contains('template-arb-file: app_fr.arb'),
      );
    });

    test('EN and FR have exactly the same keys and placeholders', () {
      final fr = read('app_fr.arb');
      final en = read('app_en.arb');
      Set<String> messages(Map<String, dynamic> arb) =>
          arb.keys.where((k) => !k.startsWith('@')).toSet();

      expect(
        messages(en).difference(messages(fr)),
        isEmpty,
        reason: 'keys missing from app_fr.arb',
      );
      expect(
        messages(fr).difference(messages(en)),
        isEmpty,
        reason: 'keys missing from app_en.arb',
      );
      for (final key in messages(fr)) {
        expect(placeholders(en, key), placeholders(fr, key), reason: key);
      }
    });

    test(
      'the template declares every placeholder with its type, and English '
      'agrees',
      () {
        final fr = read('app_fr.arb');
        final en = read('app_en.arb');
        Map<String, dynamic> declared(Map<String, dynamic> arb, String key) =>
            ((arb['@$key'] as Map<String, dynamic>?)?['placeholders']
                as Map<String, dynamic>?) ??
            const {};
        String? typeOf(Map<String, dynamic> arb, String key, String name) =>
            (declared(arb, key)[name] as Map<String, dynamic>?)?['type']
                as String?;

        for (final key in fr.keys.where((k) => !k.startsWith('@'))) {
          // Plural selectors ({count, plural, ...}) and simple {name}s.
          final used = RegExp(r'\{(\w+)[,}]')
              .allMatches(fr[key] as String)
              .map((m) => m[1]!)
              .toSet();
          for (final name in used) {
            final templateType = typeOf(fr, key, name);
            expect(
              templateType,
              isNotNull,
              reason: '@$key in app_fr.arb (the template) must declare '
                  '"$name" with a type',
            );
            final englishType = typeOf(en, key, name);
            if (englishType != null) {
              expect(englishType, templateType, reason: '$key.$name');
            }
          }
        }
      },
    );
  });

  group('on a device in a language Kalé does not speak', () {
    Future<BuildContext> pumpApp(WidgetTester tester, Locale device) async {
      tester.platformDispatcher.localesTestValue = [device];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      late BuildContext captured;
      await tester.pumpWidget(
        MaterialApp(
          localeResolutionCallback: (device, _) => resolveAppLocale(device),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            Intl.defaultLocale =
                Localizations.localeOf(context).toLanguageTag();
            return child!;
          },
          home: Builder(
            builder: (context) {
              captured = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      return captured;
    }

    testWidgets('shows French, and formats money and dates in French',
        (tester) async {
      final context = await pumpApp(tester, const Locale('wo', 'SN'));

      expect(Localizations.localeOf(context), const Locale('fr'));
      expect(context.l10n.commonRetry, 'Réessayer');
      expect(
        plainSpaces(
          context.formatMoney(
            const Money.fromMinorUnits(10000, Currencies.xof),
          ),
        ),
        '10 000 FCFA',
      );
      expect(DateFormat.yMMMd().format(DateTime(2026, 10, 13)), '13 oct. 2026');
    });

    testWidgets('an English device still gets English', (tester) async {
      final context = await pumpApp(tester, const Locale('en', 'GH'));

      expect(context.l10n.commonRetry, 'Retry');
      expect(DateFormat.yMMMd().format(DateTime(2026, 10, 13)), 'Oct 13, 2026');
    });
  });
}
