import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/money/currency.dart';

void main() {
  test('lists each currency once, with a name and a flag', () {
    expect(Currencies.all.map((c) => c.code).toSet(), hasLength(14));
    for (final currency in Currencies.all) {
      expect(currency.name, isNotEmpty, reason: currency.code);
      expect(currency.flag, isNotEmpty, reason: currency.code);
      expect(Currencies.byCode(currency.code), same(currency));
    }
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
