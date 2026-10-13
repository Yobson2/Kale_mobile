import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/constants/currencies.dart' as legacy;
import 'package:kale/core/money/currency.dart';

void main() {
  test('covers every currency currently selectable in the app', () {
    for (final selectable in legacy.SupportedCurrencies.all) {
      final currency = Currencies.byCode(selectable.code);

      expect(currency, isNotNull, reason: selectable.code);
      expect(
        currency!.decimalPlaces,
        selectable.decimalPlaces,
        reason: selectable.code,
      );
    }
    expect(Currencies.all, hasLength(legacy.SupportedCurrencies.all.length));
  });

  test('has the agreed decimal places', () {
    expect(Currencies.byCode('XOF')!.decimalPlaces, 0);
    expect(Currencies.byCode('EUR')!.decimalPlaces, 2);
    expect(Currencies.byCode('GHS')!.decimalPlaces, 2);
    expect(Currencies.byCode('NGN')!.decimalPlaces, 2);
  });

  test('XOF is shown as FCFA', () {
    expect(Currencies.xof.symbol, 'FCFA');
  });

  test('byCode is case-insensitive and returns null for unknown codes', () {
    expect(Currencies.byCode('xof'), Currencies.xof);
    expect(Currencies.byCode('ABC'), isNull);
  });
}
