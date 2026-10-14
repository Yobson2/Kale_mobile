import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/core/services/budget_alert_checker.dart';
import 'package:kale/core/services/daily_reminder.dart';
import 'package:kale/core/services/notification_service.dart';
import 'package:kale/core/services/savings_milestone_checker.dart';
import 'package:kale/core/storage/local_storage.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';
import 'package:kale/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Records what would be shown or scheduled.
class _FakeNotifications implements NotificationService {
  final shown = <({String title, String body})>[];
  ({int hour, int minute, String title})? scheduled;
  int cancels = 0;

  @override
  Future<void> init() async {}

  @override
  Future<void> showBudgetAlert({
    required int id,
    required String title,
    required String body,
  }) async =>
      shown.add((title: title, body: body));

  @override
  Future<void> showSavingsMilestone({
    required int id,
    required String title,
    required String body,
  }) async =>
      shown.add((title: title, body: body));

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async =>
      scheduled = (hour: hour, minute: minute, title: title);

  @override
  Future<void> cancelDailyReminder() async {
    cancels++;
    scheduled = null;
  }

  @override
  Future<void> cancelAll() async {}
}

void main() {
  late _FakeNotifications notifications;
  late LocalStorage storage;
  final english = lookupAppLocalizations(const Locale('en'));
  final french = lookupAppLocalizations(const Locale('fr'));

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = LocalStorage(await SharedPreferences.getInstance());
    notifications = _FakeNotifications();
  });

  group('budget alerts', () {
    Budget budget({required String id, required int spentMinor}) => Budget(
          id: id,
          name: 'October',
          strategy: BudgetStrategy.custom,
          period: BudgetPeriod.monthly,
          startDate: const CalendarDate(2026, 10, 1),
          endDate: const CalendarDate(2026, 10, 31),
          categories: [
            BudgetCategoryAllocation(
              id: 'a1',
              budgetId: id,
              categoryId: 'cat_food',
              groupName: 'Needs',
              allocatedMinor: 10000,
              spentMinor: spentMinor,
              createdAt: DateTime(2026, 10),
            ),
          ],
          createdAt: DateTime(2026, 10),
          updatedAt: DateTime(2026, 10),
        );

    BudgetAlertChecker checker([AppLocalizations? strings]) =>
        BudgetAlertChecker(
          notificationService: notifications,
          localStorage: storage,
          strings: strings ?? english,
        );

    Future<void> spend(int spentMinor, {String budgetId = 'b-oct'}) =>
        checker().checkAndAlert(
          budget: budget(id: budgetId, spentMinor: spentMinor),
          categoryId: 'cat_food',
          currency: Currencies.xof,
          categoryName: 'Food',
        );

    test('alert once at 80% and once at 100%, never in between', () async {
      await spend(7900);
      expect(notifications.shown, isEmpty);

      await spend(8000);
      await spend(9000);
      await spend(9900);
      expect(notifications.shown, hasLength(1));
      expect(notifications.shown.single.body, contains('80%'));

      await spend(10000);
      await spend(12000);
      expect(notifications.shown, hasLength(2));
      expect(notifications.shown.last.body, contains('all of your'));
    });

    test('a jump past both thresholds alerts once, at 100%', () async {
      await spend(15000);
      await spend(15000);

      expect(notifications.shown, hasLength(1));
      expect(notifications.shown.single.body, contains('all of your'));
    });

    test('a new budget period alerts again', () async {
      await spend(8500);
      await spend(8500, budgetId: 'b-nov');

      expect(notifications.shown, hasLength(2));
    });

    test('what was alerted survives a restart, and logout forgets it',
        () async {
      await spend(8500);
      storage = LocalStorage(await SharedPreferences.getInstance());
      await spend(8600);
      expect(notifications.shown, hasLength(1));

      await storage.clearUserProgress();
      await spend(8700);
      expect(notifications.shown, hasLength(2));
    });

    test('nothing when notifications are off', () async {
      await storage.setNotificationsEnabled(enabled: false);
      await spend(12000);

      expect(notifications.shown, isEmpty);
    });

    test('is written in the app language', () async {
      await checker(french).checkAndAlert(
        budget: budget(id: 'b-oct', spentMinor: 8000),
        categoryId: 'cat_food',
        currency: Currencies.xof,
        categoryName: 'Alimentation',
      );

      final alert = notifications.shown.single;
      expect(alert.title, 'Alerte budget : Alimentation');
      expect(
        alert.body.replaceAll(RegExp('[  ]'), ' '),
        'Vous avez utilisé 80 % de votre budget de 10 000 FCFA pour '
        'Alimentation.',
      );
    });
  });

  group('savings milestones', () {
    SavingsGoal goal(int savedMinor) => SavingsGoal(
          id: 'g1',
          name: 'Laptop',
          targetAmountMinor: 100000,
          currentAmountMinor: savedMinor,
          status: SavingsGoalStatus.active,
          createdAt: DateTime(2026, 10),
          updatedAt: DateTime(2026, 10),
        );

    Future<void> save(int savedMinor) => SavingsMilestoneChecker(
          notificationService: notifications,
          localStorage: storage,
          strings: english,
        ).check(goal(savedMinor));

    test('each milestone notifies once per goal', () async {
      await save(10000);
      expect(notifications.shown, isEmpty);

      await save(30000);
      await save(40000);
      expect(notifications.shown, hasLength(1));
      expect(notifications.shown.last.body, contains('25%'));

      await save(80000);
      expect(notifications.shown, hasLength(2));
      expect(notifications.shown.last.body, contains('75%'));

      await save(100000);
      await save(100000);
      expect(notifications.shown, hasLength(3));
      expect(notifications.shown.last.title, 'Goal reached: Laptop');
    });
  });

  group('daily reminder', () {
    DailyReminder reminder() => DailyReminder(
          notificationService: notifications,
          localStorage: storage,
          strings: french,
        );

    test('is off by default: launching cancels any leftover schedule',
        () async {
      expect(reminder().isEnabled, isFalse);

      await reminder().restore();

      expect(notifications.scheduled, isNull);
      expect(notifications.cancels, 1);
    });

    test('turning it on schedules one daily notification at the chosen time',
        () async {
      await reminder().enable(7 * 60 + 30);

      expect(
        notifications.scheduled,
        (
          hour: 7,
          minute: 30,
          title: 'Suivez vos dépenses',
        ),
      );
      expect(reminder().isEnabled, isTrue);

      notifications.scheduled = null;
      await reminder().restore();
      expect(notifications.scheduled?.hour, 7);
    });

    test('turning it off cancels it', () async {
      await reminder().enable(20 * 60);

      await reminder().disable();

      expect(notifications.scheduled, isNull);
      expect(reminder().isEnabled, isFalse);
    });
  });
}
