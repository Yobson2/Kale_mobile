import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Kale'**
  String get appTitle;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get commonNoResults;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonOr.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get commonOr;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get commonUser;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get errorValidation;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errorTimeout;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authRegister;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get authLogout;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authName;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Your financial journey continues here.'**
  String get authLoginSubtitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take control of your finances. Start your journey today.'**
  String get authRegisterSubtitle;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a code to reset your password.'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authHaveAccount;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {email}'**
  String authOtpSubtitle(String email);

  /// No description provided for @authOtpResend.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? Resend'**
  String get authOtpResend;

  /// No description provided for @authLoginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authLoginWithGoogle;

  /// No description provided for @authLoginWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authLoginWithApple;

  /// No description provided for @authCreatePassword.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get authCreatePassword;

  /// No description provided for @authCreatePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a secure password for your account.'**
  String get authCreatePasswordSubtitle;

  /// No description provided for @authTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy.'**
  String get authTerms;

  /// No description provided for @authTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get authTermsPrefix;

  /// No description provided for @authTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get authTermsOfService;

  /// No description provided for @authTermsAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get authTermsAnd;

  /// No description provided for @authPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get authPrivacyPolicy;

  /// No description provided for @authTryFirst.
  ///
  /// In en, this message translates to:
  /// **'Try Kale First'**
  String get authTryFirst;

  /// No description provided for @authTryFirstSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore the app without an account'**
  String get authTryFirstSubtitle;

  /// No description provided for @guestBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an account to sync your data'**
  String get guestBannerMessage;

  /// No description provided for @guestBannerAction.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get guestBannerAction;

  /// No description provided for @authRegisterStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get authRegisterStep1Title;

  /// No description provided for @authRegisterStep1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to get started'**
  String get authRegisterStep1Subtitle;

  /// No description provided for @authRegisterStep2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to finish signing up'**
  String get authRegisterStep2Subtitle;

  /// No description provided for @authRegisterContinueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get authRegisterContinueWithEmail;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationEmail;

  /// No description provided for @validationPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validationPasswordLength;

  /// No description provided for @validationPasswordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMatch;

  /// No description provided for @validationTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'You must accept the Terms of Service and Privacy Policy'**
  String get validationTermsRequired;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get passwordStrengthFair;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// No description provided for @passwordStrengthVeryStrong.
  ///
  /// In en, this message translates to:
  /// **'Very strong'**
  String get passwordStrengthVeryStrong;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Track Every Penny'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Log your expenses and income in seconds. See exactly where your money goes with clear, instant insights.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Budget Smarter'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Set custom budgets for each category and get notified before you overspend. Stay in control, effortlessly.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Reach Your Goals'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Create savings goals, track your progress, and watch your money grow. Your financial future starts here.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get navBudget;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String homeGreeting(String name);

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @dashboardCashFlow.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow'**
  String get dashboardCashFlow;

  /// No description provided for @dashboardIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get dashboardIncome;

  /// No description provided for @dashboardExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get dashboardExpenses;

  /// No description provided for @dashboardCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load summary'**
  String get dashboardCouldNotLoad;

  /// No description provided for @dashboardBudgetHealth.
  ///
  /// In en, this message translates to:
  /// **'Budget Health'**
  String get dashboardBudgetHealth;

  /// No description provided for @dashboardViewBudget.
  ///
  /// In en, this message translates to:
  /// **'View budget'**
  String get dashboardViewBudget;

  /// No description provided for @dashboardOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get dashboardOnTrack;

  /// No description provided for @dashboardGettingClose.
  ///
  /// In en, this message translates to:
  /// **'Getting close'**
  String get dashboardGettingClose;

  /// No description provided for @dashboardOverBudget.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get dashboardOverBudget;

  /// No description provided for @dashboardSpent.
  ///
  /// In en, this message translates to:
  /// **' spent'**
  String get dashboardSpent;

  /// No description provided for @dashboardSavingsGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get dashboardSavingsGoals;

  /// No description provided for @dashboardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get dashboardViewAll;

  /// No description provided for @dashboardSavedOf.
  ///
  /// In en, this message translates to:
  /// **' saved of '**
  String get dashboardSavedOf;

  /// No description provided for @dashboardRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get dashboardRecentTransactions;

  /// No description provided for @dashboardNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get dashboardNoTransactions;

  /// No description provided for @dashboardNoTransactionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first transaction'**
  String get dashboardNoTransactionsSubtitle;

  /// No description provided for @dashboardDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get dashboardDaily;

  /// No description provided for @dashboardWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get dashboardWeekly;

  /// No description provided for @dashboardMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get dashboardMonthly;

  /// No description provided for @transactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTitle;

  /// No description provided for @transactionsAddTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get transactionsAddTransaction;

  /// No description provided for @transactionsEditTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get transactionsEditTransaction;

  /// No description provided for @transactionsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get transactionsAll;

  /// No description provided for @transactionsIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transactionsIncome;

  /// No description provided for @transactionsExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get transactionsExpense;

  /// No description provided for @transactionsNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get transactionsNoTransactions;

  /// No description provided for @transactionsNoTransactionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first transaction'**
  String get transactionsNoTransactionsSubtitle;

  /// No description provided for @transactionsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get transactionsSaved;

  /// No description provided for @transactionsAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transactionsAmount;

  /// No description provided for @transactionsAmountHint.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get transactionsAmountHint;

  /// No description provided for @transactionsAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get transactionsAmountRequired;

  /// No description provided for @transactionsAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get transactionsAmountInvalid;

  /// No description provided for @transactionsCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transactionsCategory;

  /// No description provided for @transactionsCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get transactionsCategoryRequired;

  /// No description provided for @transactionsNoCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get transactionsNoCategoriesAvailable;

  /// No description provided for @transactionsDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transactionsDate;

  /// No description provided for @transactionsPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get transactionsPaymentMethod;

  /// No description provided for @transactionsPaymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get transactionsPaymentCash;

  /// No description provided for @transactionsPaymentMobileMoney.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money'**
  String get transactionsPaymentMobileMoney;

  /// No description provided for @transactionsPaymentBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get transactionsPaymentBank;

  /// No description provided for @transactionsPaymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get transactionsPaymentCard;

  /// No description provided for @transactionsMobileMoneyProvider.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money Provider'**
  String get transactionsMobileMoneyProvider;

  /// No description provided for @transactionsSelectProvider.
  ///
  /// In en, this message translates to:
  /// **'Select provider'**
  String get transactionsSelectProvider;

  /// No description provided for @transactionsSelectProviderRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a provider'**
  String get transactionsSelectProviderRequired;

  /// No description provided for @transactionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get transactionsDescription;

  /// No description provided for @transactionsDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Lunch at market, Uber to work'**
  String get transactionsDescriptionHint;

  /// No description provided for @transactionsSaveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get transactionsSaveTransaction;

  /// No description provided for @transactionsUpdateTransaction.
  ///
  /// In en, this message translates to:
  /// **'Update Transaction'**
  String get transactionsUpdateTransaction;

  /// No description provided for @transactionsUncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get transactionsUncategorized;

  /// No description provided for @transactionsValidAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get transactionsValidAmountRequired;

  /// No description provided for @transactionsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search transactions...'**
  String get transactionsSearchHint;

  /// No description provided for @transactionsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get transactionsToday;

  /// No description provided for @transactionsYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get transactionsYesterday;

  /// No description provided for @transactionsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get transactionsThisWeek;

  /// No description provided for @transactionsEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get transactionsEarlier;

  /// No description provided for @transactionsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this transaction?'**
  String get transactionsDeleteConfirm;

  /// No description provided for @transactionsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionsDeleted;

  /// No description provided for @dashboardQuickAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get dashboardQuickAdd;

  /// No description provided for @dashboardQuickBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get dashboardQuickBudget;

  /// No description provided for @dashboardQuickSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get dashboardQuickSavings;

  /// No description provided for @dashboardIncomeVsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Income vs Expenses'**
  String get dashboardIncomeVsExpenses;

  /// No description provided for @dashboardExpenseBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Expense Breakdown'**
  String get dashboardExpenseBreakdown;

  /// No description provided for @dashboardNoChartData.
  ///
  /// In en, this message translates to:
  /// **'No transaction data yet'**
  String get dashboardNoChartData;

  /// No description provided for @dashboardNoChartDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first transaction to see the chart'**
  String get dashboardNoChartDataSubtitle;

  /// No description provided for @budgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budgetTitle;

  /// No description provided for @budgetNoActiveBudget.
  ///
  /// In en, this message translates to:
  /// **'No Active Budget'**
  String get budgetNoActiveBudget;

  /// No description provided for @budgetNoActiveBudgetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a budget to start tracking your spending and stay on top of your finances.'**
  String get budgetNoActiveBudgetSubtitle;

  /// No description provided for @budgetCreateBudget.
  ///
  /// In en, this message translates to:
  /// **'Create Budget'**
  String get budgetCreateBudget;

  /// No description provided for @budgetEditBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit Budget'**
  String get budgetEditBudget;

  /// No description provided for @budgetNewBudget.
  ///
  /// In en, this message translates to:
  /// **'New Budget'**
  String get budgetNewBudget;

  /// No description provided for @budgetTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get budgetTotalSpent;

  /// No description provided for @budgetOfBudget.
  ///
  /// In en, this message translates to:
  /// **'of {amount} budget'**
  String budgetOfBudget(String amount);

  /// No description provided for @budgetWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get budgetWeekly;

  /// No description provided for @budgetBiWeekly.
  ///
  /// In en, this message translates to:
  /// **'Bi-weekly'**
  String get budgetBiWeekly;

  /// No description provided for @budgetMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get budgetMonthly;

  /// No description provided for @budgetStrategy5030.
  ///
  /// In en, this message translates to:
  /// **'50/30/20'**
  String get budgetStrategy5030;

  /// No description provided for @budgetStrategy8020.
  ///
  /// In en, this message translates to:
  /// **'80/20'**
  String get budgetStrategy8020;

  /// No description provided for @budgetStrategyEnvelope.
  ///
  /// In en, this message translates to:
  /// **'Envelope'**
  String get budgetStrategyEnvelope;

  /// No description provided for @budgetStrategyCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get budgetStrategyCustom;

  /// No description provided for @budgetSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Budget'**
  String get budgetSetupTitle;

  /// No description provided for @budgetSetupStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String budgetSetupStep(int current, int total);

  /// No description provided for @budgetSetupChooseStrategy.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Strategy'**
  String get budgetSetupChooseStrategy;

  /// No description provided for @budgetSetupChooseStrategySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a budgeting method that fits your lifestyle.'**
  String get budgetSetupChooseStrategySubtitle;

  /// No description provided for @budgetSetupSetPeriod.
  ///
  /// In en, this message translates to:
  /// **'Set Your Period'**
  String get budgetSetupSetPeriod;

  /// No description provided for @budgetSetupSetPeriodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How often do you want to budget?'**
  String get budgetSetupSetPeriodSubtitle;

  /// No description provided for @budgetSetupExpectedIncome.
  ///
  /// In en, this message translates to:
  /// **'Expected Income (optional)'**
  String get budgetSetupExpectedIncome;

  /// No description provided for @budgetSetupExpectedIncomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your expected income to auto-calculate allocations.'**
  String get budgetSetupExpectedIncomeSubtitle;

  /// No description provided for @budgetSetupExpectedIncomeHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get budgetSetupExpectedIncomeHint;

  /// No description provided for @budgetSetupBiWeekly.
  ///
  /// In en, this message translates to:
  /// **'Bi-weekly (Every 2 weeks)'**
  String get budgetSetupBiWeekly;

  /// No description provided for @budgetSetupCustomize.
  ///
  /// In en, this message translates to:
  /// **'Customize Allocations'**
  String get budgetSetupCustomize;

  /// No description provided for @budgetSetupCustomizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust amounts for each spending category.'**
  String get budgetSetupCustomizeSubtitle;

  /// No description provided for @budgetSetupReview.
  ///
  /// In en, this message translates to:
  /// **'Review Your Budget'**
  String get budgetSetupReview;

  /// No description provided for @budgetSetupReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm the details below to create your budget.'**
  String get budgetSetupReviewSubtitle;

  /// No description provided for @budgetSetupStrategy.
  ///
  /// In en, this message translates to:
  /// **'Strategy'**
  String get budgetSetupStrategy;

  /// No description provided for @budgetSetupPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get budgetSetupPeriod;

  /// No description provided for @budgetSetupIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get budgetSetupIncome;

  /// No description provided for @budgetSetupTotalBudget.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get budgetSetupTotalBudget;

  /// No description provided for @budgetSetupCategoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Category Breakdown'**
  String get budgetSetupCategoryBreakdown;

  /// No description provided for @budgetSetupContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get budgetSetupContinue;

  /// No description provided for @budgetStrategy5030Name.
  ///
  /// In en, this message translates to:
  /// **'50/30/20 Rule'**
  String get budgetStrategy5030Name;

  /// No description provided for @budgetStrategy5030Desc.
  ///
  /// In en, this message translates to:
  /// **'A balanced approach that splits your income into needs, wants, and savings.'**
  String get budgetStrategy5030Desc;

  /// No description provided for @budgetStrategy5030Formula.
  ///
  /// In en, this message translates to:
  /// **'50% Needs - 30% Wants - 20% Savings'**
  String get budgetStrategy5030Formula;

  /// No description provided for @budgetStrategy8020Name.
  ///
  /// In en, this message translates to:
  /// **'80/20 Entrepreneur'**
  String get budgetStrategy8020Name;

  /// No description provided for @budgetStrategy8020Desc.
  ///
  /// In en, this message translates to:
  /// **'For business owners: reinvest 80% into essentials and business, save 20%.'**
  String get budgetStrategy8020Desc;

  /// No description provided for @budgetStrategy8020Formula.
  ///
  /// In en, this message translates to:
  /// **'80% Essentials & Business - 20% Savings'**
  String get budgetStrategy8020Formula;

  /// No description provided for @budgetStrategyEnvelopeName.
  ///
  /// In en, this message translates to:
  /// **'Envelope System'**
  String get budgetStrategyEnvelopeName;

  /// No description provided for @budgetStrategyEnvelopeDesc.
  ///
  /// In en, this message translates to:
  /// **'Assign fixed amounts to each category. When the envelope is empty, stop spending.'**
  String get budgetStrategyEnvelopeDesc;

  /// No description provided for @budgetStrategyEnvelopeFormula.
  ///
  /// In en, this message translates to:
  /// **'Fixed amounts per category'**
  String get budgetStrategyEnvelopeFormula;

  /// No description provided for @budgetStrategyCustomName.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get budgetStrategyCustomName;

  /// No description provided for @budgetStrategyCustomDesc.
  ///
  /// In en, this message translates to:
  /// **'Set your own percentages and amounts for full control over your budget.'**
  String get budgetStrategyCustomDesc;

  /// No description provided for @budgetStrategyCustomFormula.
  ///
  /// In en, this message translates to:
  /// **'You decide the split'**
  String get budgetStrategyCustomFormula;

  /// No description provided for @categoryFoodGroceries.
  ///
  /// In en, this message translates to:
  /// **'Food & Groceries'**
  String get categoryFoodGroceries;

  /// No description provided for @categoryRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get categoryRent;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryUtilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get categoryUtilities;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryClothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get categoryClothing;

  /// No description provided for @categoryAirtimeData.
  ///
  /// In en, this message translates to:
  /// **'Airtime & Data'**
  String get categoryAirtimeData;

  /// No description provided for @categoryPersonalCare.
  ///
  /// In en, this message translates to:
  /// **'Personal Care'**
  String get categoryPersonalCare;

  /// No description provided for @categoryFamilySupport.
  ///
  /// In en, this message translates to:
  /// **'Family Support'**
  String get categoryFamilySupport;

  /// No description provided for @categorySavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get categorySavings;

  /// No description provided for @categoryDebtRepayment.
  ///
  /// In en, this message translates to:
  /// **'Debt Repayment'**
  String get categoryDebtRepayment;

  /// No description provided for @categoryReligiousGiving.
  ///
  /// In en, this message translates to:
  /// **'Religious Giving'**
  String get categoryReligiousGiving;

  /// No description provided for @categoryBusinessExpenses.
  ///
  /// In en, this message translates to:
  /// **'Business Expenses'**
  String get categoryBusinessExpenses;

  /// No description provided for @categoryMobileMoneyFees.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money Fees'**
  String get categoryMobileMoneyFees;

  /// No description provided for @categoryGroupNeeds.
  ///
  /// In en, this message translates to:
  /// **'Needs'**
  String get categoryGroupNeeds;

  /// No description provided for @categoryGroupWants.
  ///
  /// In en, this message translates to:
  /// **'Wants'**
  String get categoryGroupWants;

  /// No description provided for @categoryGroupSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get categoryGroupSavings;

  /// No description provided for @categoryGroupEssentialsBusiness.
  ///
  /// In en, this message translates to:
  /// **'Essentials & Business'**
  String get categoryGroupEssentialsBusiness;

  /// No description provided for @savingsGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get savingsGoalsTitle;

  /// No description provided for @savingsAddGoal.
  ///
  /// In en, this message translates to:
  /// **'Add goal'**
  String get savingsAddGoal;

  /// No description provided for @savingsNoGoals.
  ///
  /// In en, this message translates to:
  /// **'No savings goals yet'**
  String get savingsNoGoals;

  /// No description provided for @savingsNoGoalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What are you saving for? Set a goal to start tracking.'**
  String get savingsNoGoalsSubtitle;

  /// No description provided for @savingsCreateGoal.
  ///
  /// In en, this message translates to:
  /// **'Create Goal'**
  String get savingsCreateGoal;

  /// No description provided for @savingsNewGoal.
  ///
  /// In en, this message translates to:
  /// **'New Savings Goal'**
  String get savingsNewGoal;

  /// No description provided for @savingsGoalName.
  ///
  /// In en, this message translates to:
  /// **'Goal Name'**
  String get savingsGoalName;

  /// No description provided for @savingsGoalNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Emergency Fund, New Laptop'**
  String get savingsGoalNameHint;

  /// No description provided for @savingsGoalNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a goal name'**
  String get savingsGoalNameRequired;

  /// No description provided for @savingsTargetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target Amount ({currency})'**
  String savingsTargetAmount(String currency);

  /// No description provided for @savingsTargetAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a target amount'**
  String get savingsTargetAmountRequired;

  /// No description provided for @savingsTargetAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get savingsTargetAmountInvalid;

  /// No description provided for @savingsDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get savingsDescriptionOptional;

  /// No description provided for @savingsDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What are you saving for?'**
  String get savingsDescriptionHint;

  /// No description provided for @savingsDeadlineOptional.
  ///
  /// In en, this message translates to:
  /// **'Deadline (optional)'**
  String get savingsDeadlineOptional;

  /// No description provided for @savingsNoDeadline.
  ///
  /// In en, this message translates to:
  /// **'No deadline set'**
  String get savingsNoDeadline;

  /// No description provided for @savingsGoalDetails.
  ///
  /// In en, this message translates to:
  /// **'Goal Details'**
  String get savingsGoalDetails;

  /// No description provided for @savingsGoalNotFound.
  ///
  /// In en, this message translates to:
  /// **'Goal not found'**
  String get savingsGoalNotFound;

  /// No description provided for @savingsDeleteGoal.
  ///
  /// In en, this message translates to:
  /// **'Delete Goal'**
  String get savingsDeleteGoal;

  /// No description provided for @savingsAddMoney.
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get savingsAddMoney;

  /// No description provided for @savingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savingsSaved;

  /// No description provided for @savingsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get savingsRemaining;

  /// No description provided for @savingsTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get savingsTarget;

  /// No description provided for @savingsDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get savingsDeadline;

  /// No description provided for @savingsNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get savingsNotes;

  /// No description provided for @savingsContributionHistory.
  ///
  /// In en, this message translates to:
  /// **'Contribution History'**
  String get savingsContributionHistory;

  /// No description provided for @savingsNoContributions.
  ///
  /// In en, this message translates to:
  /// **'No contributions yet. Tap \"Add Money\" to start!'**
  String get savingsNoContributions;

  /// No description provided for @savingsAddMoneyTo.
  ///
  /// In en, this message translates to:
  /// **'Add Money to \"{name}\"'**
  String savingsAddMoneyTo(String name);

  /// No description provided for @savingsNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get savingsNoteOptional;

  /// No description provided for @savingsAddContribution.
  ///
  /// In en, this message translates to:
  /// **'Add Contribution'**
  String get savingsAddContribution;

  /// No description provided for @savingsDeleteGoalConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String savingsDeleteGoalConfirm(String name);

  /// No description provided for @savingsSavedLabel.
  ///
  /// In en, this message translates to:
  /// **'saved'**
  String get savingsSavedLabel;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @moreAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get moreAccountSection;

  /// No description provided for @moreFeaturesSection.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get moreFeaturesSection;

  /// No description provided for @moreSupportSection.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get moreSupportSection;

  /// No description provided for @moreProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get moreProfile;

  /// No description provided for @moreSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get moreSettings;

  /// No description provided for @moreSavingsGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get moreSavingsGoals;

  /// No description provided for @moreTontineGroups.
  ///
  /// In en, this message translates to:
  /// **'Tontine Groups'**
  String get moreTontineGroups;

  /// No description provided for @moreInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get moreInsights;

  /// No description provided for @moreHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get moreHelpSupport;

  /// No description provided for @moreRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get moreRateApp;

  /// No description provided for @moreShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share with Friends'**
  String get moreShareApp;

  /// No description provided for @moreShareAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out Kale - a smart budget and expense tracker app!'**
  String get moreShareAppMessage;

  /// No description provided for @moreComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get moreComingSoon;

  /// No description provided for @moreComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Coming soon! Stay tuned.'**
  String get moreComingSoonMessage;

  /// No description provided for @tontineGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Savings'**
  String get tontineGroupsTitle;

  /// No description provided for @tontineGroupsDescription.
  ///
  /// In en, this message translates to:
  /// **'Join or create a tontine group to save together with friends and family. Pool contributions and take turns receiving the pot.'**
  String get tontineGroupsDescription;

  /// No description provided for @tontineGroupsHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get tontineGroupsHowItWorks;

  /// No description provided for @tontineGroupsStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Create or Join a Group'**
  String get tontineGroupsStep1Title;

  /// No description provided for @tontineGroupsStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Start a new tontine group or join an existing one with an invite.'**
  String get tontineGroupsStep1Desc;

  /// No description provided for @tontineGroupsStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Contribute Regularly'**
  String get tontineGroupsStep2Title;

  /// No description provided for @tontineGroupsStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Each member contributes a fixed amount on a set schedule.'**
  String get tontineGroupsStep2Desc;

  /// No description provided for @tontineGroupsStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Receive the Pot'**
  String get tontineGroupsStep3Title;

  /// No description provided for @tontineGroupsStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Members take turns receiving the full pooled amount.'**
  String get tontineGroupsStep3Desc;

  /// No description provided for @tontineGroupsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Groups Yet'**
  String get tontineGroupsEmpty;

  /// No description provided for @tontineGroupsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first tontine group and start saving together.'**
  String get tontineGroupsEmptySubtitle;

  /// No description provided for @tontineGroupsCreateGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get tontineGroupsCreateGroup;

  /// No description provided for @helpFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get helpFaqTitle;

  /// No description provided for @helpFaq1Question.
  ///
  /// In en, this message translates to:
  /// **'How do I add a transaction?'**
  String get helpFaq1Question;

  /// No description provided for @helpFaq1Answer.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button on the home screen to add a new income or expense transaction. Fill in the amount, category, and optional notes.'**
  String get helpFaq1Answer;

  /// No description provided for @helpFaq2Question.
  ///
  /// In en, this message translates to:
  /// **'How do budgets work?'**
  String get helpFaq2Question;

  /// No description provided for @helpFaq2Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to the Budget tab to set up monthly spending limits by category. Kale will track your spending and notify you when you\'re close to your limit.'**
  String get helpFaq2Answer;

  /// No description provided for @helpFaq3Question.
  ///
  /// In en, this message translates to:
  /// **'Can I set savings goals?'**
  String get helpFaq3Question;

  /// No description provided for @helpFaq3Answer.
  ///
  /// In en, this message translates to:
  /// **'Yes! Go to More > Savings Goals to create targets for things like vacations, emergencies, or big purchases. Track your progress over time.'**
  String get helpFaq3Answer;

  /// No description provided for @helpFaq4Question.
  ///
  /// In en, this message translates to:
  /// **'Is my data secure?'**
  String get helpFaq4Question;

  /// No description provided for @helpFaq4Answer.
  ///
  /// In en, this message translates to:
  /// **'Your data is encrypted and stored securely. We never share your financial information with third parties. You can clear local data anytime from Settings.'**
  String get helpFaq4Answer;

  /// No description provided for @helpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get helpContactTitle;

  /// No description provided for @helpContactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get helpContactEmail;

  /// No description provided for @helpContactChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get helpContactChat;

  /// No description provided for @helpContactChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Available Mon-Fri, 9am-5pm'**
  String get helpContactChatSubtitle;

  /// No description provided for @helpLegalTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get helpLegalTitle;

  /// No description provided for @rateAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying Kale?'**
  String get rateAppTitle;

  /// No description provided for @rateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve. Let us know how we\'re doing!'**
  String get rateAppSubtitle;

  /// No description provided for @rateAppSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get rateAppSubmit;

  /// No description provided for @rateAppLabel1.
  ///
  /// In en, this message translates to:
  /// **'Needs Work'**
  String get rateAppLabel1;

  /// No description provided for @rateAppLabel2.
  ///
  /// In en, this message translates to:
  /// **'Could Be Better'**
  String get rateAppLabel2;

  /// No description provided for @rateAppLabel3.
  ///
  /// In en, this message translates to:
  /// **'It\'s Okay'**
  String get rateAppLabel3;

  /// No description provided for @rateAppLabel4.
  ///
  /// In en, this message translates to:
  /// **'Great App!'**
  String get rateAppLabel4;

  /// No description provided for @rateAppLabel5.
  ///
  /// In en, this message translates to:
  /// **'Love It!'**
  String get rateAppLabel5;

  /// No description provided for @rateAppThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank You!'**
  String get rateAppThankYou;

  /// No description provided for @rateAppThankYouMessage.
  ///
  /// In en, this message translates to:
  /// **'We appreciate your feedback. It helps us make Kale even better for you.'**
  String get rateAppThankYouMessage;

  /// No description provided for @shareAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Kale'**
  String get shareAppTitle;

  /// No description provided for @shareAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Help your friends and family take control of their finances with Kale.'**
  String get shareAppDescription;

  /// No description provided for @shareAppShareVia.
  ///
  /// In en, this message translates to:
  /// **'SHARE VIA'**
  String get shareAppShareVia;

  /// No description provided for @shareAppCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Download Link'**
  String get shareAppCopyLink;

  /// No description provided for @shareAppCopyMessage.
  ///
  /// In en, this message translates to:
  /// **'Copy Share Message'**
  String get shareAppCopyMessage;

  /// No description provided for @shareAppLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get shareAppLinkCopied;

  /// No description provided for @shareAppMessageCopied.
  ///
  /// In en, this message translates to:
  /// **'Message copied to clipboard'**
  String get shareAppMessageCopied;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Personalize Your Experience'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferences to get the most out of Kale.'**
  String get onboardingDesc4;

  /// No description provided for @onboardingCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get onboardingCurrency;

  /// No description provided for @onboardingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get onboardingLanguage;

  /// No description provided for @onboardingGoal.
  ///
  /// In en, this message translates to:
  /// **'What\'s your primary goal?'**
  String get onboardingGoal;

  /// No description provided for @onboardingGoalTrackSpending.
  ///
  /// In en, this message translates to:
  /// **'Track Spending'**
  String get onboardingGoalTrackSpending;

  /// No description provided for @onboardingGoalSaveMore.
  ///
  /// In en, this message translates to:
  /// **'Save More'**
  String get onboardingGoalSaveMore;

  /// No description provided for @onboardingGoalManageBudgets.
  ///
  /// In en, this message translates to:
  /// **'Manage Budgets'**
  String get onboardingGoalManageBudgets;

  /// No description provided for @coachMarkFab.
  ///
  /// In en, this message translates to:
  /// **'Tap here to add your first transaction'**
  String get coachMarkFab;

  /// No description provided for @coachMarkBudget.
  ///
  /// In en, this message translates to:
  /// **'Set up your monthly budget'**
  String get coachMarkBudget;

  /// No description provided for @coachMarkPeriod.
  ///
  /// In en, this message translates to:
  /// **'Switch between daily, weekly, and monthly views'**
  String get coachMarkPeriod;

  /// No description provided for @coachMarkGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get coachMarkGotIt;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profileChangePassword;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// No description provided for @profileAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profileAchievements;

  /// No description provided for @profileLevel.
  ///
  /// In en, this message translates to:
  /// **'Level: {level}'**
  String profileLevel(String level);

  /// No description provided for @profileBadgesUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} badges unlocked'**
  String profileBadgesUnlocked(int count, int total);

  /// No description provided for @achievementFirstTransaction.
  ///
  /// In en, this message translates to:
  /// **'First Transaction'**
  String get achievementFirstTransaction;

  /// No description provided for @achievementStreak7.
  ///
  /// In en, this message translates to:
  /// **'7-Day Streak'**
  String get achievementStreak7;

  /// No description provided for @achievementStreak30.
  ///
  /// In en, this message translates to:
  /// **'30-Day Streak'**
  String get achievementStreak30;

  /// No description provided for @achievementFirstBudget.
  ///
  /// In en, this message translates to:
  /// **'First Budget'**
  String get achievementFirstBudget;

  /// No description provided for @achievementUnderBudget.
  ///
  /// In en, this message translates to:
  /// **'Under Budget'**
  String get achievementUnderBudget;

  /// No description provided for @achievementFirstGoalCompleted.
  ///
  /// In en, this message translates to:
  /// **'Goal Completed'**
  String get achievementFirstGoalCompleted;

  /// No description provided for @achievementTransactions100.
  ///
  /// In en, this message translates to:
  /// **'100 Transactions'**
  String get achievementTransactions100;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelExplorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get levelExplorer;

  /// No description provided for @levelPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get levelPro;

  /// No description provided for @levelMaster.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get levelMaster;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get settingsLanguageFr;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// No description provided for @settingsSelectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get settingsSelectCurrency;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settingsPushNotifications;

  /// No description provided for @settingsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get settingsEnabled;

  /// No description provided for @settingsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get settingsDisabled;

  /// No description provided for @settingsDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get settingsDailyReminder;

  /// No description provided for @settingsDailyReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remind me to log transactions'**
  String get settingsDailyReminderSubtitle;

  /// No description provided for @settingsBudgetAlertThreshold.
  ///
  /// In en, this message translates to:
  /// **'Budget Alert Threshold'**
  String get settingsBudgetAlertThreshold;

  /// No description provided for @settingsBudgetAlertThresholdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Alert when spending reaches {percentage}% of budget'**
  String settingsBudgetAlertThresholdSubtitle(int percentage);

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @settingsClearLocalData.
  ///
  /// In en, this message translates to:
  /// **'Clear Local Data'**
  String get settingsClearLocalData;

  /// No description provided for @settingsClearLocalDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove all cached data from this device'**
  String get settingsClearLocalDataSubtitle;

  /// No description provided for @settingsClearLocalDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will remove all cached data from this device. Your account and synced data on the server will not be affected.\n\nAre you sure?'**
  String get settingsClearLocalDataConfirm;

  /// No description provided for @settingsClearLocalDataSuccess.
  ///
  /// In en, this message translates to:
  /// **'Local data cleared'**
  String get settingsClearLocalDataSuccess;

  /// No description provided for @legalLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: February 20, 2026'**
  String get legalLastUpdated;

  /// No description provided for @legalContactFooter.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions, contact us at support@kale.app'**
  String get legalContactFooter;

  /// No description provided for @legalTosTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get legalTosTitle;

  /// No description provided for @legalTosIntroHeading.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get legalTosIntroHeading;

  /// No description provided for @legalTosIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Kale. These Terms of Service govern your use of the Kale mobile application and related services. By creating an account or using Kale, you agree to be bound by these terms. If you do not agree, please do not use the app.'**
  String get legalTosIntroBody;

  /// No description provided for @legalTosAccountHeading.
  ///
  /// In en, this message translates to:
  /// **'2. Account Registration'**
  String get legalTosAccountHeading;

  /// No description provided for @legalTosAccountBody.
  ///
  /// In en, this message translates to:
  /// **'To use Kale, you must create an account with accurate and complete information. You are responsible for maintaining the confidentiality of your login credentials and for all activity under your account. You must be at least 13 years old to create an account. If you are under 18, you confirm that you have your parent or guardian\'s consent.'**
  String get legalTosAccountBody;

  /// No description provided for @legalTosServicesHeading.
  ///
  /// In en, this message translates to:
  /// **'3. Services Provided'**
  String get legalTosServicesHeading;

  /// No description provided for @legalTosServicesBody.
  ///
  /// In en, this message translates to:
  /// **'Kale provides personal finance management tools including expense and income tracking, budget creation and monitoring, savings goal management, and financial insights. These tools are designed to help you organize and understand your personal finances.'**
  String get legalTosServicesBody;

  /// No description provided for @legalTosResponsibilitiesHeading.
  ///
  /// In en, this message translates to:
  /// **'4. User Responsibilities'**
  String get legalTosResponsibilitiesHeading;

  /// No description provided for @legalTosResponsibilitiesBody.
  ///
  /// In en, this message translates to:
  /// **'You are solely responsible for the accuracy of the financial data you enter into Kale. Kale is a tracking and organizational tool and does not provide professional financial, investment, tax, or legal advice. You agree to use the app in compliance with all applicable laws and regulations.'**
  String get legalTosResponsibilitiesBody;

  /// No description provided for @legalTosFinancialDataHeading.
  ///
  /// In en, this message translates to:
  /// **'5. Financial Data'**
  String get legalTosFinancialDataHeading;

  /// No description provided for @legalTosFinancialDataBody.
  ///
  /// In en, this message translates to:
  /// **'Kale is not a bank, payment processor, or financial institution. We do not hold, transfer, or have custody of your funds. All financial data within Kale is user-entered information intended for personal tracking purposes only. We do not verify the accuracy of transactions, balances, or other financial information you enter.'**
  String get legalTosFinancialDataBody;

  /// No description provided for @legalTosIpHeading.
  ///
  /// In en, this message translates to:
  /// **'6. Intellectual Property'**
  String get legalTosIpHeading;

  /// No description provided for @legalTosIpBody.
  ///
  /// In en, this message translates to:
  /// **'The Kale app, including its design, code, features, and branding, is owned by Kale and protected by intellectual property laws. You retain full ownership of the personal data and financial information you enter into the app. You grant Kale a limited license to process your data solely to provide and improve the services.'**
  String get legalTosIpBody;

  /// No description provided for @legalTosLiabilityHeading.
  ///
  /// In en, this message translates to:
  /// **'7. Limitation of Liability'**
  String get legalTosLiabilityHeading;

  /// No description provided for @legalTosLiabilityBody.
  ///
  /// In en, this message translates to:
  /// **'Kale is provided on an \"as is\" basis. We are not liable for any financial decisions you make based on information displayed in the app. We do not guarantee the accuracy of calculations, summaries, or insights derived from your data. To the maximum extent permitted by law, Kale shall not be liable for any indirect, incidental, or consequential damages.'**
  String get legalTosLiabilityBody;

  /// No description provided for @legalTosTerminationHeading.
  ///
  /// In en, this message translates to:
  /// **'8. Termination'**
  String get legalTosTerminationHeading;

  /// No description provided for @legalTosTerminationBody.
  ///
  /// In en, this message translates to:
  /// **'You may delete your account at any time through the app settings. We may suspend or terminate your account if you violate these terms. Upon termination, your data will be deleted from our servers within 30 days unless retention is required by law.'**
  String get legalTosTerminationBody;

  /// No description provided for @legalTosChangesHeading.
  ///
  /// In en, this message translates to:
  /// **'9. Changes to These Terms'**
  String get legalTosChangesHeading;

  /// No description provided for @legalTosChangesBody.
  ///
  /// In en, this message translates to:
  /// **'We may update these Terms of Service from time to time. We will notify you of material changes through the app or by email. Your continued use of Kale after changes are posted constitutes your acceptance of the updated terms.'**
  String get legalTosChangesBody;

  /// No description provided for @legalTosContactHeading.
  ///
  /// In en, this message translates to:
  /// **'10. Contact Us'**
  String get legalTosContactHeading;

  /// No description provided for @legalTosContactBody.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about these Terms of Service, please contact us at support@kale.app.'**
  String get legalTosContactBody;

  /// No description provided for @legalPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get legalPrivacyTitle;

  /// No description provided for @legalPrivacyIntroHeading.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get legalPrivacyIntroHeading;

  /// No description provided for @legalPrivacyIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important to us. This Privacy Policy explains how Kale collects, uses, stores, and protects your personal and financial information. We are committed to handling your data with transparency and care.'**
  String get legalPrivacyIntroBody;

  /// No description provided for @legalPrivacyCollectionHeading.
  ///
  /// In en, this message translates to:
  /// **'2. Information We Collect'**
  String get legalPrivacyCollectionHeading;

  /// No description provided for @legalPrivacyCollectionBody.
  ///
  /// In en, this message translates to:
  /// **'We collect the following types of information:\n\nAccount Information: Your name, email address, and authentication credentials when you create an account.\n\nFinancial Data: Transaction records, budget configurations, savings goals, and category preferences that you enter into the app.\n\nUsage Data: Anonymous analytics about how you interact with the app, including screen views and feature usage, to help us improve the experience.\n\nDevice Information: Device type, operating system version, and app version for compatibility and troubleshooting purposes.'**
  String get legalPrivacyCollectionBody;

  /// No description provided for @legalPrivacyUsageHeading.
  ///
  /// In en, this message translates to:
  /// **'3. How We Use Your Data'**
  String get legalPrivacyUsageHeading;

  /// No description provided for @legalPrivacyUsageBody.
  ///
  /// In en, this message translates to:
  /// **'We use your information to:\n\n- Provide, maintain, and improve Kale\'s features and services\n- Generate personalized financial summaries, charts, and insights\n- Send you notifications such as budget alerts and daily reminders (when enabled)\n- Authenticate your identity and secure your account\n- Analyze aggregate usage patterns to improve the app experience'**
  String get legalPrivacyUsageBody;

  /// No description provided for @legalPrivacyStorageHeading.
  ///
  /// In en, this message translates to:
  /// **'4. Data Storage & Security'**
  String get legalPrivacyStorageHeading;

  /// No description provided for @legalPrivacyStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored securely using industry-standard practices. All data is encrypted in transit using TLS and at rest on our servers. We use Supabase as our backend infrastructure, which provides enterprise-grade security, access controls, and data isolation. We regularly review our security practices and limit access to your data to authorized personnel only.'**
  String get legalPrivacyStorageBody;

  /// No description provided for @legalPrivacyThirdPartyHeading.
  ///
  /// In en, this message translates to:
  /// **'5. Third-Party Services'**
  String get legalPrivacyThirdPartyHeading;

  /// No description provided for @legalPrivacyThirdPartyBody.
  ///
  /// In en, this message translates to:
  /// **'Kale integrates with the following third-party services:\n\n- Google Sign-In and Apple Sign-In for authentication\n- Analytics services for anonymous usage tracking\n- Crash reporting services to identify and fix app issues\n\nWe do not sell, rent, or share your personal or financial data with third parties for marketing purposes. Third-party services only receive the minimum data necessary to perform their function.'**
  String get legalPrivacyThirdPartyBody;

  /// No description provided for @legalPrivacyRightsHeading.
  ///
  /// In en, this message translates to:
  /// **'6. Your Rights'**
  String get legalPrivacyRightsHeading;

  /// No description provided for @legalPrivacyRightsBody.
  ///
  /// In en, this message translates to:
  /// **'You have the right to:\n\n- Access the personal data we hold about you\n- Correct inaccurate information in your account\n- Delete your account and all associated data\n- Export your financial data\n- Restrict or object to certain processing of your data\n\nTo exercise any of these rights, contact us at privacy@kale.app or use the account management features within the app.'**
  String get legalPrivacyRightsBody;

  /// No description provided for @legalPrivacyRetentionHeading.
  ///
  /// In en, this message translates to:
  /// **'7. Data Retention'**
  String get legalPrivacyRetentionHeading;

  /// No description provided for @legalPrivacyRetentionBody.
  ///
  /// In en, this message translates to:
  /// **'We retain your data for as long as your account is active. If you delete your account, we will remove your personal and financial data from our servers within 30 days. Some anonymized, aggregate data may be retained for analytical purposes. We may also retain certain data as required by law.'**
  String get legalPrivacyRetentionBody;

  /// No description provided for @legalPrivacyChildrenHeading.
  ///
  /// In en, this message translates to:
  /// **'8. Children\'s Privacy'**
  String get legalPrivacyChildrenHeading;

  /// No description provided for @legalPrivacyChildrenBody.
  ///
  /// In en, this message translates to:
  /// **'Kale is not directed at children under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware that we have collected data from a child under 13 without parental consent, we will take steps to delete that information promptly.'**
  String get legalPrivacyChildrenBody;

  /// No description provided for @legalPrivacyChangesHeading.
  ///
  /// In en, this message translates to:
  /// **'9. Changes to This Policy'**
  String get legalPrivacyChangesHeading;

  /// No description provided for @legalPrivacyChangesBody.
  ///
  /// In en, this message translates to:
  /// **'We may update this Privacy Policy from time to time. We will notify you of material changes through an in-app notice or by email. We encourage you to review this policy periodically. Your continued use of Kale after changes are posted constitutes your acceptance of the updated policy.'**
  String get legalPrivacyChangesBody;

  /// No description provided for @legalPrivacyContactHeading.
  ///
  /// In en, this message translates to:
  /// **'10. Contact Us'**
  String get legalPrivacyContactHeading;

  /// No description provided for @legalPrivacyContactBody.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about this Privacy Policy or how your data is handled, please contact us at privacy@kale.app.'**
  String get legalPrivacyContactBody;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get offlineBanner;

  /// No description provided for @emptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check back later for updates.'**
  String get emptyStateSubtitle;

  /// No description provided for @budgetEmptyRecommendation.
  ///
  /// In en, this message translates to:
  /// **'We recommend the 50/30/20 rule to get started'**
  String get budgetEmptyRecommendation;

  /// No description provided for @budgetStartWith5030.
  ///
  /// In en, this message translates to:
  /// **'Start with 50/30/20'**
  String get budgetStartWith5030;

  /// No description provided for @budgetCustomBudget.
  ///
  /// In en, this message translates to:
  /// **'Custom Budget'**
  String get budgetCustomBudget;

  /// No description provided for @budgetEmptyQuickTip.
  ///
  /// In en, this message translates to:
  /// **'It only takes a minute to set up'**
  String get budgetEmptyQuickTip;

  /// No description provided for @savingsEmptyTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular goals to get you started'**
  String get savingsEmptyTemplateTitle;

  /// No description provided for @savingsTemplateEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency Fund'**
  String get savingsTemplateEmergency;

  /// No description provided for @savingsTemplateVacation.
  ///
  /// In en, this message translates to:
  /// **'Vacation'**
  String get savingsTemplateVacation;

  /// No description provided for @savingsTemplateNewPhone.
  ///
  /// In en, this message translates to:
  /// **'New Phone'**
  String get savingsTemplateNewPhone;

  /// No description provided for @savingsEmptyOrCreate.
  ///
  /// In en, this message translates to:
  /// **'Or create your own goal'**
  String get savingsEmptyOrCreate;

  /// No description provided for @transactionsEmptyQuickTip.
  ///
  /// In en, this message translates to:
  /// **'It takes just 10 seconds'**
  String get transactionsEmptyQuickTip;

  /// No description provided for @dashboardEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Kale!'**
  String get dashboardEmptyTitle;

  /// No description provided for @dashboardEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete these steps to get the most out of your finances:'**
  String get dashboardEmptySubtitle;

  /// No description provided for @dashboardEmptyStep1.
  ///
  /// In en, this message translates to:
  /// **'Add your first transaction'**
  String get dashboardEmptyStep1;

  /// No description provided for @dashboardEmptyStep2.
  ///
  /// In en, this message translates to:
  /// **'Set up a budget'**
  String get dashboardEmptyStep2;

  /// No description provided for @dashboardEmptyStep3.
  ///
  /// In en, this message translates to:
  /// **'Create a savings goal'**
  String get dashboardEmptyStep3;

  /// No description provided for @dashboardStreak.
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak'**
  String dashboardStreak(int count);

  /// No description provided for @dashboardStreakStart.
  ///
  /// In en, this message translates to:
  /// **'Start your streak!'**
  String get dashboardStreakStart;

  /// No description provided for @dashboardFinancialHealth.
  ///
  /// In en, this message translates to:
  /// **'Financial Health'**
  String get dashboardFinancialHealth;

  /// No description provided for @dashboardHealthExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get dashboardHealthExcellent;

  /// No description provided for @dashboardHealthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get dashboardHealthGood;

  /// No description provided for @dashboardHealthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get dashboardHealthFair;

  /// No description provided for @dashboardHealthNeedsWork.
  ///
  /// In en, this message translates to:
  /// **'Needs work'**
  String get dashboardHealthNeedsWork;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up! Notifications about your budgets, savings, and reminders will appear here.'**
  String get notificationsEmptySubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
