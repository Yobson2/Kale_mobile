// Guards the money contract: money is stored, sent and summed as integer
// minor units (`int`, Drift `IntColumn`), never as floating point.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Layers that hold, store or transfer money.
const _scannedDirectories = [
  'lib/core/database',
  'lib/core/money',
  'lib/core/sync',
];

/// Matches a `double`, `num` or Drift `RealColumn` declaration and captures
/// its name: fields, getters, parameters and Freezed constructor params.
final _floatDeclaration =
    RegExp(r'\b(?:double|num|RealColumn)\??\s+(?:get\s+)?(\w+)');

/// Names that hold money.
final _moneyName = RegExp(
  'amount|total|balance|price|cost|fee|spent|allocated|income|expense|'
  'saved|target|contribution|money|minor',
  caseSensitive: false,
);

/// Names that are ratios of money, not money: these may be floats.
final _ratioName = RegExp(
  'percent|progress|utilization|ratio|rate',
  caseSensitive: false,
);

/// The money-named float declarations in [source].
List<String> floatMoneyDeclarations(String source) => [
      for (final match in _floatDeclaration.allMatches(source))
        if (_moneyName.hasMatch(match[1]!) && !_ratioName.hasMatch(match[1]!))
          match[1]!,
    ];

Iterable<File> _scannedFiles() sync* {
  final roots = [
    ..._scannedDirectories.map(Directory.new),
    for (final feature
        in Directory('lib/features').listSync().whereType<Directory>())
      for (final layer in ['domain', 'data'])
        Directory('${feature.path}/$layer'),
  ];
  for (final root in roots.where((d) => d.existsSync())) {
    yield* root
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
  }
}

void main() {
  test('no money field in domain, data or database code is a float', () {
    final files = _scannedFiles().toList();
    expect(files.length, greaterThan(50), reason: 'scan found too few files');

    final offenders = [
      for (final file in files)
        for (final name in floatMoneyDeclarations(file.readAsStringSync()))
          '${file.path}: $name',
    ];

    expect(
      offenders,
      isEmpty,
      reason: 'Store money as int minor units (e.g. `int amountMinor`, '
          '`IntColumn`), and wrap it in Money for display.',
    );
  });

  test('the check flags float money and allows float ratios', () {
    expect(
      floatMoneyDeclarations('''
        final double amount;
        double? get totalSpent => 0;
        RealColumn get targetAmount => real()();
        @JsonKey(name: 'x') num balance,
        final double? allocatedPercentage;
        double get progress => 0.5;
        final int amountMinor;
      '''),
      ['amount', 'totalSpent', 'targetAmount', 'balance'],
    );
  });
}
