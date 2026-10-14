import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/features/profile/data/models/profile_model.dart';
import 'package:kale/features/profile/domain/usecases/change_base_currency_usecase.dart';

import '../../helpers/sync_harness.dart';

void main() {
  late SyncHarness harness;

  setUp(() => harness = SyncHarness());
  tearDown(() => harness.dispose());

  Future<BaseCurrencyChange> change(
    Currency currency, {
    bool relabelConfirmed = false,
  }) async {
    final result = await harness.changeBaseCurrency(
      ChangeBaseCurrencyParams(
        currency: currency,
        relabelConfirmed: relabelConfirmed,
      ),
    );
    return result.fold((f) => throw StateError('$f'), (c) => c);
  }

  group('the base currency chosen at onboarding', () {
    test('persists on the device across restarts', () async {
      await harness.chooseBaseCurrency(Currencies.ghs);

      harness.restartApp();

      expect(await harness.readBaseCurrency(), Currencies.ghs);
      expect(await harness.profile.watchBaseCurrency().first, Currencies.ghs);
    });

    test('is pushed to the server profile on sync', () async {
      await harness.chooseBaseCurrency(Currencies.ghs);

      await harness.sync();

      final row = harness.server.profile.rows[ProfileModel.localId]!;
      expect(row.toJson()['base_currency'], 'GHS');
    });

    test('is restored from the server on an empty device', () async {
      harness.server.profile.rows[ProfileModel.localId] = ProfileModel(
        baseCurrency: 'EUR',
        updatedAt: DateTime(2026, 10),
      );
      expect(await harness.readBaseCurrency(), isNull);

      await harness.profile.refreshFromServer();

      expect(await harness.readBaseCurrency(), Currencies.eur);
    });

    test('is not overwritten by the server before it is pushed', () async {
      harness.server.profile.rows[ProfileModel.localId] = ProfileModel(
        baseCurrency: 'EUR',
        updatedAt: DateTime(2026, 10),
      );
      await harness.chooseBaseCurrency(Currencies.ngn);

      await harness.profile.refreshFromServer();

      expect(await harness.readBaseCurrency(), Currencies.ngn);
    });
  });

  group('changing the base currency', () {
    test('is free while there are no transactions', () async {
      await harness.chooseBaseCurrency(Currencies.xof);

      expect(await change(Currencies.eur), BaseCurrencyChange.changed);
      expect(await harness.readBaseCurrency(), Currencies.eur);
    });

    test('with transactions, asks for confirmation and changes nothing',
        () async {
      await harness.chooseBaseCurrency(Currencies.xof);
      await harness.addTransaction(amountMinor: 5000);

      expect(
        await change(Currencies.eur),
        BaseCurrencyChange.needsRelabelConfirmation,
      );
      expect(await harness.readBaseCurrency(), Currencies.xof);
    });

    test('once confirmed, relabels amounts without converting them', () async {
      await harness.chooseBaseCurrency(Currencies.xof);
      final created = await harness.addTransaction(amountMinor: 5000);

      expect(
        await change(Currencies.eur, relabelConfirmed: true),
        BaseCurrencyChange.changed,
      );

      expect(await harness.readBaseCurrency(), Currencies.eur);
      final kept = await harness.readTransaction(created.id);
      expect(kept.amountMinor, 5000);
      expect(kept.amountIn(Currencies.eur).format(locale: 'fr'), '50,00 €');
    });

    test('to the same currency never needs confirmation', () async {
      await harness.chooseBaseCurrency(Currencies.xof);
      await harness.addTransaction();

      expect(await change(Currencies.xof), BaseCurrencyChange.changed);
    });
  });
}
