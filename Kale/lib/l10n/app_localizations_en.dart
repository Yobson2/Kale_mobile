// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kale';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonDone => 'Done';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonNoResults => 'No results found';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonOr => 'Or';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonUser => 'User';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network.';

  @override
  String get errorServer => 'Server error. Please try again later.';

  @override
  String get errorUnauthorized => 'Session expired. Please log in again.';

  @override
  String get errorValidation => 'Please check your input and try again.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get authLogin => 'Log In';

  @override
  String get authRegister => 'Sign Up';

  @override
  String get authLogout => 'Log Out';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authResetPassword => 'Reset Password';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authName => 'Full Name';

  @override
  String get authLoginSubtitle =>
      'Welcome back! Your financial journey continues here.';

  @override
  String get authRegisterSubtitle =>
      'Take control of your finances. Start your journey today.';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your email and we\'ll send you a code to reset your password.';

  @override
  String get authNoAccount => 'Don\'t have an account? ';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get authOtpTitle => 'Verify Your Email';

  @override
  String authOtpSubtitle(String email) {
    return 'Enter the 6-digit code sent to $email';
  }

  @override
  String get authOtpResend => 'Didn\'t receive the code? Resend';

  @override
  String get authLoginWithGoogle => 'Continue with Google';

  @override
  String get authLoginWithApple => 'Continue with Apple';

  @override
  String get authCreatePassword => 'Create Password';

  @override
  String get authCreatePasswordSubtitle =>
      'Set a secure password for your account.';

  @override
  String get authTerms =>
      'By continuing, you agree to our Terms of Service and Privacy Policy.';

  @override
  String get authTermsPrefix => 'I agree to the ';

  @override
  String get authTermsOfService => 'Terms of Service';

  @override
  String get authTermsAnd => ' and ';

  @override
  String get authPrivacyPolicy => 'Privacy Policy';

  @override
  String get authTryFirst => 'Try Kale First';

  @override
  String get authTryFirstSubtitle => 'Explore the app without an account';

  @override
  String get guestBannerMessage => 'Create an account to sync your data';

  @override
  String get guestBannerAction => 'Sign Up';

  @override
  String get authRegisterStep1Title => 'Create Your Account';

  @override
  String get authRegisterStep1Subtitle => 'Enter your email to get started';

  @override
  String get authRegisterStep2Subtitle =>
      'Complete your profile to finish signing up';

  @override
  String get authRegisterContinueWithEmail => 'Continue with Email';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationEmail => 'Please enter a valid email address';

  @override
  String get validationPasswordLength =>
      'Password must be at least 8 characters';

  @override
  String get validationPasswordMatch => 'Passwords do not match';

  @override
  String get validationTermsRequired =>
      'You must accept the Terms of Service and Privacy Policy';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthFair => 'Fair';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get passwordStrengthVeryStrong => 'Very strong';

  @override
  String get onboardingTitle1 => 'Track Every Penny';

  @override
  String get onboardingDesc1 =>
      'Log your expenses and income in seconds. See exactly where your money goes with clear, instant insights.';

  @override
  String get onboardingTitle2 => 'Budget Smarter';

  @override
  String get onboardingDesc2 =>
      'Set custom budgets for each category and get notified before you overspend. Stay in control, effortlessly.';

  @override
  String get onboardingTitle3 => 'Reach Your Goals';

  @override
  String get onboardingDesc3 =>
      'Create savings goals, track your progress, and watch your money grow. Your financial future starts here.';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navBudget => 'Budget';

  @override
  String get navMore => 'More';

  @override
  String get homeTitle => 'Home';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name!';
  }

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String get dashboardCashFlow => 'Cash Flow';

  @override
  String get dashboardIncome => 'Income';

  @override
  String get dashboardExpenses => 'Expenses';

  @override
  String get dashboardCouldNotLoad => 'Could not load summary';

  @override
  String get dashboardBudgetHealth => 'Budget Health';

  @override
  String get dashboardViewBudget => 'View budget';

  @override
  String get dashboardOnTrack => 'On track';

  @override
  String get dashboardGettingClose => 'Getting close';

  @override
  String get dashboardOverBudget => 'Over budget';

  @override
  String get dashboardSpent => ' spent';

  @override
  String get dashboardSavingsGoals => 'Savings Goals';

  @override
  String get dashboardViewAll => 'View all';

  @override
  String get dashboardSavedOf => ' saved of ';

  @override
  String get dashboardRecentTransactions => 'Recent Transactions';

  @override
  String get dashboardNoTransactions => 'No transactions yet';

  @override
  String get dashboardNoTransactionsSubtitle =>
      'Tap the + button to add your first transaction';

  @override
  String get dashboardDaily => 'Daily';

  @override
  String get dashboardWeekly => 'Weekly';

  @override
  String get dashboardMonthly => 'Monthly';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get transactionsAddTransaction => 'Add Transaction';

  @override
  String get transactionsEditTransaction => 'Edit Transaction';

  @override
  String get transactionsAll => 'All';

  @override
  String get transactionsIncome => 'Income';

  @override
  String get transactionsExpense => 'Expense';

  @override
  String get transactionsNoTransactions => 'No transactions yet';

  @override
  String get transactionsNoTransactionsSubtitle =>
      'Tap + to add your first transaction';

  @override
  String get transactionsSaved => 'Saved';

  @override
  String get transactionsAmount => 'Amount';

  @override
  String get transactionsAmountHint => '0';

  @override
  String get transactionsAmountRequired => 'Enter an amount';

  @override
  String get transactionsAmountInvalid => 'Enter a valid amount';

  @override
  String get transactionsCategory => 'Category';

  @override
  String get transactionsCategoryRequired => 'Please select a category';

  @override
  String get transactionsNoCategoriesAvailable => 'No categories available';

  @override
  String get transactionsDate => 'Date';

  @override
  String get transactionsPaymentMethod => 'Payment Method';

  @override
  String get transactionsPaymentCash => 'Cash';

  @override
  String get transactionsPaymentMobileMoney => 'Mobile Money';

  @override
  String get transactionsPaymentBank => 'Bank';

  @override
  String get transactionsPaymentCard => 'Card';

  @override
  String get transactionsMobileMoneyProvider => 'Mobile Money Provider';

  @override
  String get transactionsSelectProvider => 'Select provider';

  @override
  String get transactionsSelectProviderRequired => 'Please select a provider';

  @override
  String get transactionsDescription => 'Description (optional)';

  @override
  String get transactionsDescriptionHint =>
      'e.g. Lunch at market, Uber to work';

  @override
  String get transactionsSaveTransaction => 'Save Transaction';

  @override
  String get transactionsUpdateTransaction => 'Update Transaction';

  @override
  String get transactionsUncategorized => 'Uncategorized';

  @override
  String get transactionsValidAmountRequired => 'Please enter a valid amount';

  @override
  String get transactionsSearchHint => 'Search transactions...';

  @override
  String get transactionsToday => 'Today';

  @override
  String get transactionsYesterday => 'Yesterday';

  @override
  String get transactionsThisWeek => 'This Week';

  @override
  String get transactionsEarlier => 'Earlier';

  @override
  String get transactionsDeleteConfirm => 'Delete this transaction?';

  @override
  String get transactionsDeleted => 'Transaction deleted';

  @override
  String get dashboardQuickAdd => 'Add';

  @override
  String get dashboardQuickBudget => 'Budget';

  @override
  String get dashboardQuickSavings => 'Savings';

  @override
  String get dashboardIncomeVsExpenses => 'Income vs Expenses';

  @override
  String get dashboardExpenseBreakdown => 'Expense Breakdown';

  @override
  String get dashboardNoChartData => 'No transaction data yet';

  @override
  String get dashboardNoChartDataSubtitle =>
      'Add your first transaction to see the chart';

  @override
  String get budgetTitle => 'Budget';

  @override
  String get budgetNoActiveBudget => 'No Active Budget';

  @override
  String get budgetNoActiveBudgetSubtitle =>
      'Create a budget to start tracking your spending and stay on top of your finances.';

  @override
  String get budgetCreateBudget => 'Create Budget';

  @override
  String get budgetEditBudget => 'Edit Budget';

  @override
  String get budgetNewBudget => 'New Budget';

  @override
  String get budgetTotalSpent => 'Total Spent';

  @override
  String budgetOfBudget(String amount) {
    return 'of $amount budget';
  }

  @override
  String get budgetWeekly => 'Weekly';

  @override
  String get budgetBiWeekly => 'Bi-weekly';

  @override
  String get budgetMonthly => 'Monthly';

  @override
  String get budgetStrategy5030 => '50/30/20';

  @override
  String get budgetStrategy8020 => '80/20';

  @override
  String get budgetStrategyEnvelope => 'Envelope';

  @override
  String get budgetStrategyCustom => 'Custom';

  @override
  String get budgetSetupTitle => 'Create Budget';

  @override
  String budgetSetupStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get budgetSetupChooseStrategy => 'Choose Your Strategy';

  @override
  String get budgetSetupChooseStrategySubtitle =>
      'Pick a budgeting method that fits your lifestyle.';

  @override
  String get budgetSetupSetPeriod => 'Set Your Period';

  @override
  String get budgetSetupSetPeriodSubtitle => 'How often do you want to budget?';

  @override
  String get budgetSetupExpectedIncome => 'Expected Income (optional)';

  @override
  String get budgetSetupExpectedIncomeSubtitle =>
      'Enter your expected income to auto-calculate allocations.';

  @override
  String get budgetSetupExpectedIncomeHint => '0.00';

  @override
  String get budgetSetupBiWeekly => 'Bi-weekly (Every 2 weeks)';

  @override
  String get budgetSetupCustomize => 'Customize Allocations';

  @override
  String get budgetSetupCustomizeSubtitle =>
      'Adjust amounts for each spending category.';

  @override
  String get budgetSetupReview => 'Review Your Budget';

  @override
  String get budgetSetupReviewSubtitle =>
      'Confirm the details below to create your budget.';

  @override
  String get budgetSetupStrategy => 'Strategy';

  @override
  String get budgetSetupPeriod => 'Period';

  @override
  String get budgetSetupIncome => 'Income';

  @override
  String get budgetSetupTotalBudget => 'Total Budget';

  @override
  String get budgetSetupCategoryBreakdown => 'Category Breakdown';

  @override
  String get budgetSetupContinue => 'Continue';

  @override
  String get budgetStrategy5030Name => '50/30/20 Rule';

  @override
  String get budgetStrategy5030Desc =>
      'A balanced approach that splits your income into needs, wants, and savings.';

  @override
  String get budgetStrategy5030Formula => '50% Needs - 30% Wants - 20% Savings';

  @override
  String get budgetStrategy8020Name => '80/20 Entrepreneur';

  @override
  String get budgetStrategy8020Desc =>
      'For business owners: reinvest 80% into essentials and business, save 20%.';

  @override
  String get budgetStrategy8020Formula =>
      '80% Essentials & Business - 20% Savings';

  @override
  String get budgetStrategyEnvelopeName => 'Envelope System';

  @override
  String get budgetStrategyEnvelopeDesc =>
      'Assign fixed amounts to each category. When the envelope is empty, stop spending.';

  @override
  String get budgetStrategyEnvelopeFormula => 'Fixed amounts per category';

  @override
  String get budgetStrategyCustomName => 'Custom';

  @override
  String get budgetStrategyCustomDesc =>
      'Set your own percentages and amounts for full control over your budget.';

  @override
  String get budgetStrategyCustomFormula => 'You decide the split';

  @override
  String get categoryFoodGroceries => 'Food & Groceries';

  @override
  String get categoryRent => 'Rent';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryUtilities => 'Utilities';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryClothing => 'Clothing';

  @override
  String get categoryAirtimeData => 'Airtime & Data';

  @override
  String get categoryPersonalCare => 'Personal Care';

  @override
  String get categoryFamilySupport => 'Family Support';

  @override
  String get categorySavings => 'Savings';

  @override
  String get categoryDebtRepayment => 'Debt Repayment';

  @override
  String get categoryReligiousGiving => 'Religious Giving';

  @override
  String get categoryBusinessExpenses => 'Business Expenses';

  @override
  String get categoryMobileMoneyFees => 'Mobile Money Fees';

  @override
  String get categoryGroupNeeds => 'Needs';

  @override
  String get categoryGroupWants => 'Wants';

  @override
  String get categoryGroupSavings => 'Savings';

  @override
  String get categoryGroupEssentialsBusiness => 'Essentials & Business';

  @override
  String get savingsGoalsTitle => 'Savings Goals';

  @override
  String get savingsAddGoal => 'Add goal';

  @override
  String get savingsNoGoals => 'No savings goals yet';

  @override
  String get savingsNoGoalsSubtitle =>
      'What are you saving for? Set a goal to start tracking.';

  @override
  String get savingsCreateGoal => 'Create Goal';

  @override
  String get savingsNewGoal => 'New Savings Goal';

  @override
  String get savingsGoalName => 'Goal Name';

  @override
  String get savingsGoalNameHint => 'e.g. Emergency Fund, New Laptop';

  @override
  String get savingsGoalNameRequired => 'Please enter a goal name';

  @override
  String savingsTargetAmount(String currency) {
    return 'Target Amount ($currency)';
  }

  @override
  String get savingsTargetAmountRequired => 'Please enter a target amount';

  @override
  String get savingsTargetAmountInvalid => 'Please enter a valid amount';

  @override
  String get savingsDescriptionOptional => 'Description (optional)';

  @override
  String get savingsDescriptionHint => 'What are you saving for?';

  @override
  String get savingsDeadlineOptional => 'Deadline (optional)';

  @override
  String get savingsNoDeadline => 'No deadline set';

  @override
  String get savingsGoalDetails => 'Goal Details';

  @override
  String get savingsGoalNotFound => 'Goal not found';

  @override
  String get savingsDeleteGoal => 'Delete Goal';

  @override
  String get savingsAddMoney => 'Add Money';

  @override
  String get savingsSaved => 'Saved';

  @override
  String get savingsRemaining => 'Remaining';

  @override
  String get savingsTarget => 'Target';

  @override
  String get savingsDeadline => 'Deadline';

  @override
  String get savingsNotes => 'Notes';

  @override
  String get savingsContributionHistory => 'Contribution History';

  @override
  String get savingsNoContributions =>
      'No contributions yet. Tap \"Add Money\" to start!';

  @override
  String savingsAddMoneyTo(String name) {
    return 'Add Money to \"$name\"';
  }

  @override
  String get savingsNoteOptional => 'Note (optional)';

  @override
  String get savingsAddContribution => 'Add Contribution';

  @override
  String savingsDeleteGoalConfirm(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get savingsSavedLabel => 'saved';

  @override
  String get moreTitle => 'More';

  @override
  String get moreAccountSection => 'Account';

  @override
  String get moreFeaturesSection => 'Features';

  @override
  String get moreSupportSection => 'Support';

  @override
  String get moreProfile => 'Profile';

  @override
  String get moreSettings => 'Settings';

  @override
  String get moreSavingsGoals => 'Savings Goals';

  @override
  String get moreTontineGroups => 'Tontine Groups';

  @override
  String get moreInsights => 'Insights';

  @override
  String get moreHelpSupport => 'Help & Support';

  @override
  String get moreRateApp => 'Rate the App';

  @override
  String get moreShareApp => 'Share with Friends';

  @override
  String get moreShareAppMessage =>
      'Check out Kale - a smart budget and expense tracker app!';

  @override
  String get moreComingSoon => 'Coming Soon';

  @override
  String get moreComingSoonMessage => 'Coming soon! Stay tuned.';

  @override
  String get tontineGroupsTitle => 'Community Savings';

  @override
  String get tontineGroupsDescription =>
      'Join or create a tontine group to save together with friends and family. Pool contributions and take turns receiving the pot.';

  @override
  String get tontineGroupsHowItWorks => 'How It Works';

  @override
  String get tontineGroupsStep1Title => 'Create or Join a Group';

  @override
  String get tontineGroupsStep1Desc =>
      'Start a new tontine group or join an existing one with an invite.';

  @override
  String get tontineGroupsStep2Title => 'Contribute Regularly';

  @override
  String get tontineGroupsStep2Desc =>
      'Each member contributes a fixed amount on a set schedule.';

  @override
  String get tontineGroupsStep3Title => 'Receive the Pot';

  @override
  String get tontineGroupsStep3Desc =>
      'Members take turns receiving the full pooled amount.';

  @override
  String get tontineGroupsEmpty => 'No Groups Yet';

  @override
  String get tontineGroupsEmptySubtitle =>
      'Create your first tontine group and start saving together.';

  @override
  String get tontineGroupsCreateGroup => 'Create Group';

  @override
  String get helpFaqTitle => 'Frequently Asked Questions';

  @override
  String get helpFaq1Question => 'How do I add a transaction?';

  @override
  String get helpFaq1Answer =>
      'Tap the + button on the home screen to add a new income or expense transaction. Fill in the amount, category, and optional notes.';

  @override
  String get helpFaq2Question => 'How do budgets work?';

  @override
  String get helpFaq2Answer =>
      'Go to the Budget tab to set up monthly spending limits by category. Kale will track your spending and notify you when you\'re close to your limit.';

  @override
  String get helpFaq3Question => 'Can I set savings goals?';

  @override
  String get helpFaq3Answer =>
      'Yes! Go to More > Savings Goals to create targets for things like vacations, emergencies, or big purchases. Track your progress over time.';

  @override
  String get helpFaq4Question => 'Is my data secure?';

  @override
  String get helpFaq4Answer =>
      'Your data is encrypted and stored securely. We never share your financial information with third parties. You can clear local data anytime from Settings.';

  @override
  String get helpContactTitle => 'Contact Us';

  @override
  String get helpContactEmail => 'Email Support';

  @override
  String get helpContactChat => 'Live Chat';

  @override
  String get helpContactChatSubtitle => 'Available Mon-Fri, 9am-5pm';

  @override
  String get helpLegalTitle => 'Legal';

  @override
  String get rateAppTitle => 'Enjoying Kale?';

  @override
  String get rateAppSubtitle =>
      'Your feedback helps us improve. Let us know how we\'re doing!';

  @override
  String get rateAppSubmit => 'Submit Rating';

  @override
  String get rateAppLabel1 => 'Needs Work';

  @override
  String get rateAppLabel2 => 'Could Be Better';

  @override
  String get rateAppLabel3 => 'It\'s Okay';

  @override
  String get rateAppLabel4 => 'Great App!';

  @override
  String get rateAppLabel5 => 'Love It!';

  @override
  String get rateAppThankYou => 'Thank You!';

  @override
  String get rateAppThankYouMessage =>
      'We appreciate your feedback. It helps us make Kale even better for you.';

  @override
  String get shareAppTitle => 'Share Kale';

  @override
  String get shareAppDescription =>
      'Help your friends and family take control of their finances with Kale.';

  @override
  String get shareAppShareVia => 'SHARE VIA';

  @override
  String get shareAppCopyLink => 'Copy Download Link';

  @override
  String get shareAppCopyMessage => 'Copy Share Message';

  @override
  String get shareAppLinkCopied => 'Link copied to clipboard';

  @override
  String get shareAppMessageCopied => 'Message copied to clipboard';

  @override
  String get onboardingTitle4 => 'Personalize Your Experience';

  @override
  String get onboardingDesc4 =>
      'Choose your preferences to get the most out of Kale.';

  @override
  String get onboardingCurrency => 'Currency';

  @override
  String get onboardingLanguage => 'Language';

  @override
  String get onboardingGoal => 'What\'s your primary goal?';

  @override
  String get onboardingGoalTrackSpending => 'Track Spending';

  @override
  String get onboardingGoalSaveMore => 'Save More';

  @override
  String get onboardingGoalManageBudgets => 'Manage Budgets';

  @override
  String get coachMarkFab => 'Tap here to add your first transaction';

  @override
  String get coachMarkBudget => 'Set up your monthly budget';

  @override
  String get coachMarkPeriod =>
      'Switch between daily, weekly, and monthly views';

  @override
  String get coachMarkGotIt => 'Got it';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileChangePassword => 'Change Password';

  @override
  String get profileLogout => 'Logout';

  @override
  String get profileAchievements => 'Achievements';

  @override
  String profileLevel(String level) {
    return 'Level: $level';
  }

  @override
  String profileBadgesUnlocked(int count, int total) {
    return '$count of $total badges unlocked';
  }

  @override
  String get achievementFirstTransaction => 'First Transaction';

  @override
  String get achievementStreak7 => '7-Day Streak';

  @override
  String get achievementStreak30 => '30-Day Streak';

  @override
  String get achievementFirstBudget => 'First Budget';

  @override
  String get achievementUnderBudget => 'Under Budget';

  @override
  String get achievementFirstGoalCompleted => 'Goal Completed';

  @override
  String get achievementTransactions100 => '100 Transactions';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelExplorer => 'Explorer';

  @override
  String get levelPro => 'Pro';

  @override
  String get levelMaster => 'Master';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageFr => 'French';

  @override
  String get settingsAbout => 'About';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsTerms => 'Terms of Service';

  @override
  String get settingsPrivacy => 'Privacy Policy';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsSelectCurrency => 'Select Currency';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPushNotifications => 'Push Notifications';

  @override
  String get settingsEnabled => 'Enabled';

  @override
  String get settingsDisabled => 'Disabled';

  @override
  String get settingsDailyReminder => 'Daily Reminder';

  @override
  String get settingsDailyReminderSubtitle => 'Remind me to log transactions';

  @override
  String get settingsBudgetAlertThreshold => 'Budget Alert Threshold';

  @override
  String settingsBudgetAlertThresholdSubtitle(int percentage) {
    return 'Alert when spending reaches $percentage% of budget';
  }

  @override
  String get settingsData => 'Data';

  @override
  String get settingsClearLocalData => 'Clear Local Data';

  @override
  String get settingsClearLocalDataSubtitle =>
      'Remove all cached data from this device';

  @override
  String get settingsClearLocalDataConfirm =>
      'This will remove all cached data from this device. Your account and synced data on the server will not be affected.\n\nAre you sure?';

  @override
  String get settingsClearLocalDataSuccess => 'Local data cleared';

  @override
  String get legalLastUpdated => 'Last updated: February 20, 2026';

  @override
  String get legalContactFooter =>
      'If you have any questions, contact us at support@kale.app';

  @override
  String get legalTosTitle => 'Terms of Service';

  @override
  String get legalTosIntroHeading => '1. Introduction';

  @override
  String get legalTosIntroBody =>
      'Welcome to Kale. These Terms of Service govern your use of the Kale mobile application and related services. By creating an account or using Kale, you agree to be bound by these terms. If you do not agree, please do not use the app.';

  @override
  String get legalTosAccountHeading => '2. Account Registration';

  @override
  String get legalTosAccountBody =>
      'To use Kale, you must create an account with accurate and complete information. You are responsible for maintaining the confidentiality of your login credentials and for all activity under your account. You must be at least 13 years old to create an account. If you are under 18, you confirm that you have your parent or guardian\'s consent.';

  @override
  String get legalTosServicesHeading => '3. Services Provided';

  @override
  String get legalTosServicesBody =>
      'Kale provides personal finance management tools including expense and income tracking, budget creation and monitoring, savings goal management, and financial insights. These tools are designed to help you organize and understand your personal finances.';

  @override
  String get legalTosResponsibilitiesHeading => '4. User Responsibilities';

  @override
  String get legalTosResponsibilitiesBody =>
      'You are solely responsible for the accuracy of the financial data you enter into Kale. Kale is a tracking and organizational tool and does not provide professional financial, investment, tax, or legal advice. You agree to use the app in compliance with all applicable laws and regulations.';

  @override
  String get legalTosFinancialDataHeading => '5. Financial Data';

  @override
  String get legalTosFinancialDataBody =>
      'Kale is not a bank, payment processor, or financial institution. We do not hold, transfer, or have custody of your funds. All financial data within Kale is user-entered information intended for personal tracking purposes only. We do not verify the accuracy of transactions, balances, or other financial information you enter.';

  @override
  String get legalTosIpHeading => '6. Intellectual Property';

  @override
  String get legalTosIpBody =>
      'The Kale app, including its design, code, features, and branding, is owned by Kale and protected by intellectual property laws. You retain full ownership of the personal data and financial information you enter into the app. You grant Kale a limited license to process your data solely to provide and improve the services.';

  @override
  String get legalTosLiabilityHeading => '7. Limitation of Liability';

  @override
  String get legalTosLiabilityBody =>
      'Kale is provided on an \"as is\" basis. We are not liable for any financial decisions you make based on information displayed in the app. We do not guarantee the accuracy of calculations, summaries, or insights derived from your data. To the maximum extent permitted by law, Kale shall not be liable for any indirect, incidental, or consequential damages.';

  @override
  String get legalTosTerminationHeading => '8. Termination';

  @override
  String get legalTosTerminationBody =>
      'You may delete your account at any time through the app settings. We may suspend or terminate your account if you violate these terms. Upon termination, your data will be deleted from our servers within 30 days unless retention is required by law.';

  @override
  String get legalTosChangesHeading => '9. Changes to These Terms';

  @override
  String get legalTosChangesBody =>
      'We may update these Terms of Service from time to time. We will notify you of material changes through the app or by email. Your continued use of Kale after changes are posted constitutes your acceptance of the updated terms.';

  @override
  String get legalTosContactHeading => '10. Contact Us';

  @override
  String get legalTosContactBody =>
      'If you have questions about these Terms of Service, please contact us at support@kale.app.';

  @override
  String get legalPrivacyTitle => 'Privacy Policy';

  @override
  String get legalPrivacyIntroHeading => '1. Introduction';

  @override
  String get legalPrivacyIntroBody =>
      'Your privacy is important to us. This Privacy Policy explains how Kale collects, uses, stores, and protects your personal and financial information. We are committed to handling your data with transparency and care.';

  @override
  String get legalPrivacyCollectionHeading => '2. Information We Collect';

  @override
  String get legalPrivacyCollectionBody =>
      'We collect the following types of information:\n\nAccount Information: Your name, email address, and authentication credentials when you create an account.\n\nFinancial Data: Transaction records, budget configurations, savings goals, and category preferences that you enter into the app.\n\nUsage Data: Anonymous analytics about how you interact with the app, including screen views and feature usage, to help us improve the experience.\n\nDevice Information: Device type, operating system version, and app version for compatibility and troubleshooting purposes.';

  @override
  String get legalPrivacyUsageHeading => '3. How We Use Your Data';

  @override
  String get legalPrivacyUsageBody =>
      'We use your information to:\n\n- Provide, maintain, and improve Kale\'s features and services\n- Generate personalized financial summaries, charts, and insights\n- Send you notifications such as budget alerts and daily reminders (when enabled)\n- Authenticate your identity and secure your account\n- Analyze aggregate usage patterns to improve the app experience';

  @override
  String get legalPrivacyStorageHeading => '4. Data Storage & Security';

  @override
  String get legalPrivacyStorageBody =>
      'Your data is stored securely using industry-standard practices. All data is encrypted in transit using TLS and at rest on our servers. We use Supabase as our backend infrastructure, which provides enterprise-grade security, access controls, and data isolation. We regularly review our security practices and limit access to your data to authorized personnel only.';

  @override
  String get legalPrivacyThirdPartyHeading => '5. Third-Party Services';

  @override
  String get legalPrivacyThirdPartyBody =>
      'Kale integrates with the following third-party services:\n\n- Google Sign-In and Apple Sign-In for authentication\n- Analytics services for anonymous usage tracking\n- Crash reporting services to identify and fix app issues\n\nWe do not sell, rent, or share your personal or financial data with third parties for marketing purposes. Third-party services only receive the minimum data necessary to perform their function.';

  @override
  String get legalPrivacyRightsHeading => '6. Your Rights';

  @override
  String get legalPrivacyRightsBody =>
      'You have the right to:\n\n- Access the personal data we hold about you\n- Correct inaccurate information in your account\n- Delete your account and all associated data\n- Export your financial data\n- Restrict or object to certain processing of your data\n\nTo exercise any of these rights, contact us at privacy@kale.app or use the account management features within the app.';

  @override
  String get legalPrivacyRetentionHeading => '7. Data Retention';

  @override
  String get legalPrivacyRetentionBody =>
      'We retain your data for as long as your account is active. If you delete your account, we will remove your personal and financial data from our servers within 30 days. Some anonymized, aggregate data may be retained for analytical purposes. We may also retain certain data as required by law.';

  @override
  String get legalPrivacyChildrenHeading => '8. Children\'s Privacy';

  @override
  String get legalPrivacyChildrenBody =>
      'Kale is not directed at children under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware that we have collected data from a child under 13 without parental consent, we will take steps to delete that information promptly.';

  @override
  String get legalPrivacyChangesHeading => '9. Changes to This Policy';

  @override
  String get legalPrivacyChangesBody =>
      'We may update this Privacy Policy from time to time. We will notify you of material changes through an in-app notice or by email. We encourage you to review this policy periodically. Your continued use of Kale after changes are posted constitutes your acceptance of the updated policy.';

  @override
  String get legalPrivacyContactHeading => '10. Contact Us';

  @override
  String get legalPrivacyContactBody =>
      'If you have questions about this Privacy Policy or how your data is handled, please contact us at privacy@kale.app.';

  @override
  String get offlineBanner => 'You are offline';

  @override
  String get emptyStateTitle => 'Nothing here yet';

  @override
  String get emptyStateSubtitle => 'Check back later for updates.';

  @override
  String get budgetEmptyRecommendation =>
      'We recommend the 50/30/20 rule to get started';

  @override
  String get budgetStartWith5030 => 'Start with 50/30/20';

  @override
  String get budgetCustomBudget => 'Custom Budget';

  @override
  String get budgetEmptyQuickTip => 'It only takes a minute to set up';

  @override
  String get savingsEmptyTemplateTitle => 'Popular goals to get you started';

  @override
  String get savingsTemplateEmergency => 'Emergency Fund';

  @override
  String get savingsTemplateVacation => 'Vacation';

  @override
  String get savingsTemplateNewPhone => 'New Phone';

  @override
  String get savingsEmptyOrCreate => 'Or create your own goal';

  @override
  String get transactionsEmptyQuickTip => 'It takes just 10 seconds';

  @override
  String get dashboardEmptyTitle => 'Welcome to Kale!';

  @override
  String get dashboardEmptySubtitle =>
      'Complete these steps to get the most out of your finances:';

  @override
  String get dashboardEmptyStep1 => 'Add your first transaction';

  @override
  String get dashboardEmptyStep2 => 'Set up a budget';

  @override
  String get dashboardEmptyStep3 => 'Create a savings goal';

  @override
  String dashboardStreak(int count) {
    return '$count-day streak';
  }

  @override
  String get dashboardStreakStart => 'Start your streak!';

  @override
  String get dashboardFinancialHealth => 'Financial Health';

  @override
  String get dashboardHealthExcellent => 'Excellent';

  @override
  String get dashboardHealthGood => 'Good';

  @override
  String get dashboardHealthFair => 'Fair';

  @override
  String get dashboardHealthNeedsWork => 'Needs work';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No notifications yet';

  @override
  String get notificationsEmptySubtitle =>
      'You\'re all caught up! Notifications about your budgets, savings, and reminders will appear here.';
}
