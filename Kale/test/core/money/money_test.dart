import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/money/money.dart';

void main() {
  group('arithmetic', () {
    test('adds two XOF amounts in minor units', () {
      const a = Money.fromMinorUnits(1500, Currencies.xof);
      const b = Money.fromMinorUnits(2500, Currencies.xof);

      expect(a + b, const Money.fromMinorUnits(4000, Currencies.xof));
    });

    test('refuses to add amounts in different currencies', () {
      const xof = Money.fromMinorUnits(1000, Currencies.xof);
      const eur = Money.fromMinorUnits(1000, Currencies.eur);

      expect(() => xof + eur, throwsArgumentError);
    });

    test('subtracts EUR cents and can go negative', () {
      const a = Money.fromMinorUnits(1050, Currencies.eur); // 10,50 €
      const b = Money.fromMinorUnits(1999, Currencies.eur); // 19,99 €

      expect(b - a, const Money.fromMinorUnits(949, Currencies.eur));
      expect(a - b, const Money.fromMinorUnits(-949, Currencies.eur));
      expect((a - b).isNegative, isTrue);
    });

    test('compares amounts of the same currency', () {
      const small = Money.fromMinorUnits(999, Currencies.eur);
      const large = Money.fromMinorUnits(1000, Currencies.eur);

      expect(small < large, isTrue);
      expect(large > small, isTrue);
      expect(small <= const Money.fromMinorUnits(999, Currencies.eur), isTrue);
      expect(large >= small, isTrue);
      expect(small.compareTo(large), lessThan(0));
      expect([large, small]..sort(), [small, large]);
    });

    test('refuses to compare amounts in different currencies', () {
      const xof = Money.fromMinorUnits(1000, Currencies.xof);
      const eur = Money.fromMinorUnits(1, Currencies.eur);

      expect(() => xof < eur, throwsArgumentError);
      expect(() => xof - eur, throwsArgumentError);
    });

    test('sums a list of XOF amounts', () {
      final total = Money.sum(
        const [
          Money.fromMinorUnits(10000, Currencies.xof),
          Money.fromMinorUnits(2500, Currencies.xof),
          Money.fromMinorUnits(-500, Currencies.xof),
        ],
        Currencies.xof,
      );

      expect(total, const Money.fromMinorUnits(12000, Currencies.xof));
    });

    test('sum of an empty list is zero in the given currency', () {
      expect(
        Money.sum(const [], Currencies.eur),
        const Money.zero(Currencies.eur),
      );
      expect(const Money.zero(Currencies.eur).isZero, isTrue);
    });

    test('sum refuses a list containing another currency', () {
      expect(
        () => Money.sum(
          const [Money.fromMinorUnits(100, Currencies.eur)],
          Currencies.xof,
        ),
        throwsArgumentError,
      );
    });

    test('stays exact where floating point would drift', () {
      // 0.1 + 0.2 != 0.3 in doubles; in cents it is exact.
      final total = const Money.fromMinorUnits(10, Currencies.eur) +
          const Money.fromMinorUnits(20, Currencies.eur);

      expect(total, const Money.fromMinorUnits(30, Currencies.eur));
    });
  });

  group('format', () {
    // French uses U+202F (narrow no-break space) to group thousands and
    // U+00A0 (no-break space) before the currency symbol.
    const nnbsp = '\u202F';
    const nbsp = '\u00A0';

    test('formats XOF in French with no decimals', () {
      const m = Money.fromMinorUnits(10000, Currencies.xof);

      expect(m.format(locale: 'fr'), '10${nnbsp}000${nbsp}FCFA');
    });

    test('formats EUR in French with two decimals', () {
      const m = Money.fromMinorUnits(123456, Currencies.eur);

      expect(m.format(locale: 'fr'), '1${nnbsp}234,56$nbsp€');
    });

    test('pads EUR cents', () {
      expect(
        const Money.fromMinorUnits(5, Currencies.eur).format(locale: 'fr'),
        '0,05$nbsp€',
      );
    });

    test('formats negative amounts', () {
      expect(
        const Money.fromMinorUnits(-1500, Currencies.xof).format(locale: 'fr'),
        '-1${nnbsp}500${nbsp}FCFA',
      );
      expect(
        const Money.fromMinorUnits(-123456, Currencies.eur)
            .format(locale: 'en'),
        '-€1,234.56',
      );
    });

    test('follows an English device locale', () {
      expect(
        const Money.fromMinorUnits(123456, Currencies.eur)
            .format(locale: 'en_US'),
        '€1,234.56',
      );
      expect(
        const Money.fromMinorUnits(10000, Currencies.xof).format(locale: 'en'),
        'FCFA${nbsp}10,000',
      );
    });

    test('accepts a regional French locale such as fr_CI', () {
      expect(
        const Money.fromMinorUnits(10000, Currencies.xof)
            .format(locale: 'fr_CI'),
        '10${nnbsp}000${nbsp}FCFA',
      );
    });

    test('falls back to French for a missing or unknown locale', () {
      const m = Money.fromMinorUnits(10000, Currencies.xof);

      expect(m.format(), '10${nnbsp}000${nbsp}FCFA');
      expect(m.format(locale: 'zz'), '10${nnbsp}000${nbsp}FCFA');
    });

    test('can omit the symbol', () {
      expect(
        const Money.fromMinorUnits(123456, Currencies.eur)
            .format(locale: 'fr', withSymbol: false),
        '1${nnbsp}234,56',
      );
    });
  });

  group('tryParse', () {
    Money xof(int v) => Money.fromMinorUnits(v, Currencies.xof);
    Money eur(int v) => Money.fromMinorUnits(v, Currencies.eur);

    test('parses whole XOF amounts', () {
      expect(Money.tryParse('10000', Currencies.xof), xof(10000));
      expect(Money.tryParse('  250 ', Currencies.xof), xof(250));
    });

    test('accepts French thousands separators, including no-break spaces', () {
      expect(Money.tryParse('10 000', Currencies.xof), xof(10000));
      expect(Money.tryParse('10\u202F000', Currencies.xof), xof(10000));
      expect(
        Money.tryParse('1\u00A0000\u00A0000', Currencies.xof),
        xof(1000000),
      );
    });

    test('round-trips its own formatting without the symbol', () {
      final m = eur(123456);

      expect(
        Money.tryParse(
          m.format(locale: 'fr', withSymbol: false),
          Currencies.eur,
        ),
        m,
      );
    });

    test('rejects fractional input for a 0-decimal currency', () {
      // Documented rule: XOF has no minor unit, so any fractional part is
      // rejected rather than rounded; the input field shows it as invalid.
      expect(Money.tryParse('1500,5', Currencies.xof), isNull);
      expect(Money.tryParse('1500.5', Currencies.xof), isNull);
      expect(Money.tryParse('1500,0', Currencies.xof), isNull);
    });

    test('accepts up to two decimals for EUR, with comma or dot in French', () {
      expect(Money.tryParse('10,50', Currencies.eur), eur(1050));
      expect(Money.tryParse('10.50', Currencies.eur), eur(1050));
      expect(Money.tryParse('10,5', Currencies.eur), eur(1050));
      expect(Money.tryParse('0,05', Currencies.eur), eur(5));
      expect(Money.tryParse('1 234,56', Currencies.eur), eur(123456));
      expect(Money.tryParse('7', Currencies.eur), eur(700));
    });

    test('rejects more decimals than EUR allows', () {
      expect(Money.tryParse('10,505', Currencies.eur), isNull);
    });

    test('follows an English locale', () {
      expect(
        Money.tryParse('1,234.56', Currencies.eur, locale: 'en_US'),
        eur(123456),
      );
      expect(
        Money.tryParse('10,000', Currencies.xof, locale: 'en'),
        xof(10000),
      );
    });

    test('parses negative amounts', () {
      expect(Money.tryParse('-1 500', Currencies.xof), xof(-1500));
      expect(Money.tryParse('-0,99', Currencies.eur), eur(-99));
    });

    test('rejects input that is not a number', () {
      for (final input in [
        '',
        '   ',
        'abc',
        '12a',
        '1,2,3',
        ',',
        '10,',
        '--5',
      ]) {
        expect(Money.tryParse(input, Currencies.eur), isNull, reason: input);
      }
    });
  });
}
