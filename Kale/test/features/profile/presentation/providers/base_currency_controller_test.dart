import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/features/profile/domain/usecases/change_base_currency_usecase.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockChangeBaseCurrencyUseCase extends Mock
    implements ChangeBaseCurrencyUseCase {}

void main() {
  late _MockChangeBaseCurrencyUseCase useCase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const ChangeBaseCurrencyParams(currency: Currencies.xof),
    );
  });

  setUp(() {
    useCase = _MockChangeBaseCurrencyUseCase();
    container = ProviderContainer(
      overrides: [changeBaseCurrencyUseCaseProvider.overrideWithValue(useCase)],
    );
  });

  tearDown(() => container.dispose());

  test('change completes when the controller is read without a listener',
      () async {
    // Onboarding and Settings read the notifier without watching it, and the
    // use case awaits the database, so the change outlives the frame it began in.
    when(() => useCase.call(any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return const Right(BaseCurrencyChange.changed);
    });

    final controller = container.read(baseCurrencyControllerProvider.notifier);

    expect(await controller.change(Currencies.ghs), BaseCurrencyChange.changed);
  });
}
