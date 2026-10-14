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
  /// In fr, this message translates to:
  /// **'Kalé'**
  String get appTitle;

  /// No description provided for @commonOk.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get commonClose;

  /// No description provided for @commonRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get commonRetry;

  /// No description provided for @commonNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get commonBack;

  /// No description provided for @commonSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get commonSkip;

  /// No description provided for @commonDone.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get commonDone;

  /// No description provided for @commonSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get commonSearch;

  /// No description provided for @commonLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get commonLoading;

  /// No description provided for @commonNoResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat trouvé'**
  String get commonNoResults;

  /// No description provided for @commonSeeAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get commonSeeAll;

  /// No description provided for @commonOr.
  ///
  /// In fr, this message translates to:
  /// **'Ou'**
  String get commonOr;

  /// No description provided for @commonClear.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get commonClear;

  /// No description provided for @commonContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get commonContinue;

  /// No description provided for @commonUser.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get commonUser;

  /// No description provided for @errorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Veuillez réessayer.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion Internet. Vérifiez votre réseau.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In fr, this message translates to:
  /// **'Erreur serveur. Veuillez réessayer plus tard.'**
  String get errorServer;

  /// No description provided for @errorUnauthorized.
  ///
  /// In fr, this message translates to:
  /// **'Session expirée. Veuillez vous reconnecter.'**
  String get errorUnauthorized;

  /// No description provided for @errorValidation.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez vérifier vos informations et réessayer.'**
  String get errorValidation;

  /// No description provided for @errorTimeout.
  ///
  /// In fr, this message translates to:
  /// **'La requête a expiré. Veuillez réessayer.'**
  String get errorTimeout;

  /// No description provided for @authLogin.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get authRegister;

  /// No description provided for @authLogout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get authLogout;

  /// No description provided for @authForgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get authForgotPassword;

  /// No description provided for @authResetPassword.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le mot de passe'**
  String get authResetPassword;

  /// No description provided for @authEmail.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get authConfirmPassword;

  /// No description provided for @authName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get authName;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour ! Votre parcours financier continue ici.'**
  String get authLoginSubtitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Prenez le contrôle de vos finances. Commencez votre parcours aujourd\'hui.'**
  String get authRegisterSubtitle;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre e-mail et nous vous enverrons un code pour réinitialiser votre mot de passe.'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? '**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez déjà un compte ? '**
  String get authHaveAccount;

  /// No description provided for @authOtpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre e-mail'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le code à 6 chiffres envoyé à {email}'**
  String authOtpSubtitle(String email);

  /// No description provided for @authOtpResend.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas reçu le code ? Renvoyer'**
  String get authOtpResend;

  /// No description provided for @authLoginWithGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get authLoginWithGoogle;

  /// No description provided for @authLoginWithApple.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Apple'**
  String get authLoginWithApple;

  /// No description provided for @authCreatePassword.
  ///
  /// In fr, this message translates to:
  /// **'Créer un mot de passe'**
  String get authCreatePassword;

  /// No description provided for @authCreatePasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Définissez un mot de passe sécurisé pour votre compte.'**
  String get authCreatePasswordSubtitle;

  /// No description provided for @authTerms.
  ///
  /// In fr, this message translates to:
  /// **'En continuant, vous acceptez nos Conditions d\'utilisation et notre Politique de confidentialité.'**
  String get authTerms;

  /// No description provided for @authTermsPrefix.
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte les '**
  String get authTermsPrefix;

  /// No description provided for @authTermsOfService.
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get authTermsOfService;

  /// No description provided for @authTermsAnd.
  ///
  /// In fr, this message translates to:
  /// **' et la '**
  String get authTermsAnd;

  /// No description provided for @authPrivacyPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get authPrivacyPolicy;

  /// No description provided for @authTryFirst.
  ///
  /// In fr, this message translates to:
  /// **'Essayer Kalé d\'abord'**
  String get authTryFirst;

  /// No description provided for @authTryFirstSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Explorez l\'application sans compte'**
  String get authTryFirstSubtitle;

  /// No description provided for @anonymousSaveDataCta.
  ///
  /// In fr, this message translates to:
  /// **'Créez un compte pour sauvegarder vos données'**
  String get anonymousSaveDataCta;

  /// No description provided for @anonymousBannerAction.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get anonymousBannerAction;

  /// No description provided for @authRegisterStep1Title.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre compte'**
  String get authRegisterStep1Title;

  /// No description provided for @authRegisterStep1Subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre e-mail pour commencer'**
  String get authRegisterStep1Subtitle;

  /// No description provided for @authRegisterStep2Subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Complétez votre profil pour terminer l\'inscription'**
  String get authRegisterStep2Subtitle;

  /// No description provided for @authRegisterContinueWithEmail.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec l\'e-mail'**
  String get authRegisterContinueWithEmail;

  /// No description provided for @validationRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est requis'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer une adresse e-mail valide'**
  String get validationEmail;

  /// No description provided for @validationPasswordLength.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 8 caractères'**
  String get validationPasswordLength;

  /// No description provided for @validationPasswordMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get validationPasswordMatch;

  /// No description provided for @validationTermsRequired.
  ///
  /// In fr, this message translates to:
  /// **'Vous devez accepter les Conditions d\'utilisation et la Politique de confidentialité'**
  String get validationTermsRequired;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In fr, this message translates to:
  /// **'Faible'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthFair.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get passwordStrengthFair;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In fr, this message translates to:
  /// **'Fort'**
  String get passwordStrengthStrong;

  /// No description provided for @passwordStrengthVeryStrong.
  ///
  /// In fr, this message translates to:
  /// **'Très fort'**
  String get passwordStrengthVeryStrong;

  /// No description provided for @onboardingTitle1.
  ///
  /// In fr, this message translates to:
  /// **'Suivez Chaque Dépense'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrez vos dépenses et revenus en quelques secondes. Voyez exactement où va votre argent avec des aperçus clairs et instantanés.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In fr, this message translates to:
  /// **'Budgétez Plus Malin'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In fr, this message translates to:
  /// **'Définissez des budgets personnalisés pour chaque catégorie et soyez alerté avant de trop dépenser. Gardez le contrôle, sans effort.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In fr, this message translates to:
  /// **'Atteignez Vos Objectifs'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In fr, this message translates to:
  /// **'Créez des objectifs d\'épargne, suivez votre progression et regardez votre argent grandir. Votre avenir financier commence ici.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardingGetStarted;

  /// No description provided for @navDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get navDashboard;

  /// No description provided for @navTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget'**
  String get navBudget;

  /// No description provided for @navMore.
  ///
  /// In fr, this message translates to:
  /// **'Plus'**
  String get navMore;

  /// No description provided for @homeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get homeTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, {name} !'**
  String homeGreeting(String name);

  /// No description provided for @homeGreetingMorning.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In fr, this message translates to:
  /// **'Bon après-midi'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In fr, this message translates to:
  /// **'Bonsoir'**
  String get homeGreetingEvening;

  /// No description provided for @dashboardCashFlow.
  ///
  /// In fr, this message translates to:
  /// **'Flux de trésorerie'**
  String get dashboardCashFlow;

  /// No description provided for @dashboardIncome.
  ///
  /// In fr, this message translates to:
  /// **'Revenus'**
  String get dashboardIncome;

  /// No description provided for @dashboardExpenses.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses'**
  String get dashboardExpenses;

  /// No description provided for @dashboardCouldNotLoad.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger le résumé'**
  String get dashboardCouldNotLoad;

  /// No description provided for @dashboardBudgetHealth.
  ///
  /// In fr, this message translates to:
  /// **'Santé du budget'**
  String get dashboardBudgetHealth;

  /// No description provided for @dashboardViewBudget.
  ///
  /// In fr, this message translates to:
  /// **'Voir le budget'**
  String get dashboardViewBudget;

  /// No description provided for @dashboardOnTrack.
  ///
  /// In fr, this message translates to:
  /// **'En bonne voie'**
  String get dashboardOnTrack;

  /// No description provided for @dashboardGettingClose.
  ///
  /// In fr, this message translates to:
  /// **'Presque atteint'**
  String get dashboardGettingClose;

  /// No description provided for @dashboardOverBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget dépassé'**
  String get dashboardOverBudget;

  /// No description provided for @dashboardSpent.
  ///
  /// In fr, this message translates to:
  /// **' dépensé'**
  String get dashboardSpent;

  /// No description provided for @dashboardSavingsGoals.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs d\'épargne'**
  String get dashboardSavingsGoals;

  /// No description provided for @dashboardViewAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get dashboardViewAll;

  /// No description provided for @dashboardSavedOf.
  ///
  /// In fr, this message translates to:
  /// **' épargné sur '**
  String get dashboardSavedOf;

  /// No description provided for @dashboardRecentTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Transactions récentes'**
  String get dashboardRecentTransactions;

  /// No description provided for @dashboardNoTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction'**
  String get dashboardNoTransactions;

  /// No description provided for @dashboardNoTransactionsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur + pour ajouter votre première transaction'**
  String get dashboardNoTransactionsSubtitle;

  /// No description provided for @dashboardDaily.
  ///
  /// In fr, this message translates to:
  /// **'Quotidien'**
  String get dashboardDaily;

  /// No description provided for @dashboardWeekly.
  ///
  /// In fr, this message translates to:
  /// **'Hebdomadaire'**
  String get dashboardWeekly;

  /// No description provided for @dashboardMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuel'**
  String get dashboardMonthly;

  /// No description provided for @transactionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Transactions'**
  String get transactionsTitle;

  /// No description provided for @transactionsAddTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une transaction'**
  String get transactionsAddTransaction;

  /// No description provided for @transactionsEditTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la transaction'**
  String get transactionsEditTransaction;

  /// No description provided for @transactionsAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get transactionsAll;

  /// No description provided for @transactionsIncome.
  ///
  /// In fr, this message translates to:
  /// **'Revenus'**
  String get transactionsIncome;

  /// No description provided for @transactionsExpense.
  ///
  /// In fr, this message translates to:
  /// **'Dépense'**
  String get transactionsExpense;

  /// No description provided for @transactionsNoTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction'**
  String get transactionsNoTransactions;

  /// No description provided for @transactionsNoTransactionsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur + pour ajouter votre première transaction'**
  String get transactionsNoTransactionsSubtitle;

  /// No description provided for @transactionsSaved.
  ///
  /// In fr, this message translates to:
  /// **'Enregistré'**
  String get transactionsSaved;

  /// No description provided for @transactionsAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get transactionsAmount;

  /// No description provided for @transactionsAmountHint.
  ///
  /// In fr, this message translates to:
  /// **'0'**
  String get transactionsAmountHint;

  /// No description provided for @transactionsAmountRequired.
  ///
  /// In fr, this message translates to:
  /// **'Entrez un montant'**
  String get transactionsAmountRequired;

  /// No description provided for @transactionsAmountInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Entrez un montant valide'**
  String get transactionsAmountInvalid;

  /// No description provided for @transactionsCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get transactionsCategory;

  /// No description provided for @transactionsCategoryRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une catégorie'**
  String get transactionsCategoryRequired;

  /// No description provided for @transactionsNoCategoriesAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune catégorie disponible'**
  String get transactionsNoCategoriesAvailable;

  /// No description provided for @transactionsDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get transactionsDate;

  /// No description provided for @transactionsPaymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Mode de paiement'**
  String get transactionsPaymentMethod;

  /// No description provided for @transactionsPaymentCash.
  ///
  /// In fr, this message translates to:
  /// **'Espèces'**
  String get transactionsPaymentCash;

  /// No description provided for @transactionsPaymentMobileMoney.
  ///
  /// In fr, this message translates to:
  /// **'Mobile Money'**
  String get transactionsPaymentMobileMoney;

  /// No description provided for @transactionsPaymentBank.
  ///
  /// In fr, this message translates to:
  /// **'Banque'**
  String get transactionsPaymentBank;

  /// No description provided for @transactionsPaymentCard.
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get transactionsPaymentCard;

  /// No description provided for @transactionsMobileMoneyProvider.
  ///
  /// In fr, this message translates to:
  /// **'Fournisseur Mobile Money'**
  String get transactionsMobileMoneyProvider;

  /// No description provided for @transactionsSelectProvider.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner un fournisseur'**
  String get transactionsSelectProvider;

  /// No description provided for @transactionsSelectProviderRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner un fournisseur'**
  String get transactionsSelectProviderRequired;

  /// No description provided for @transactionsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description (optionnel)'**
  String get transactionsDescription;

  /// No description provided for @transactionsDescriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. Déjeuner au marché, Uber au travail'**
  String get transactionsDescriptionHint;

  /// No description provided for @transactionsSaveTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer la transaction'**
  String get transactionsSaveTransaction;

  /// No description provided for @transactionsUpdateTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour la transaction'**
  String get transactionsUpdateTransaction;

  /// No description provided for @transactionsUncategorized.
  ///
  /// In fr, this message translates to:
  /// **'Non catégorisé'**
  String get transactionsUncategorized;

  /// No description provided for @transactionsValidAmountRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un montant valide'**
  String get transactionsValidAmountRequired;

  /// No description provided for @transactionsSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher des transactions...'**
  String get transactionsSearchHint;

  /// No description provided for @transactionsToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get transactionsToday;

  /// No description provided for @transactionsYesterday.
  ///
  /// In fr, this message translates to:
  /// **'Hier'**
  String get transactionsYesterday;

  /// No description provided for @transactionsThisWeek.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get transactionsThisWeek;

  /// No description provided for @transactionsEarlier.
  ///
  /// In fr, this message translates to:
  /// **'Plus ancien'**
  String get transactionsEarlier;

  /// No description provided for @transactionsDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette transaction ?'**
  String get transactionsDeleteConfirm;

  /// No description provided for @transactionsDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Transaction supprimée'**
  String get transactionsDeleted;

  /// No description provided for @dashboardQuickAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get dashboardQuickAdd;

  /// No description provided for @dashboardQuickBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget'**
  String get dashboardQuickBudget;

  /// No description provided for @dashboardQuickSavings.
  ///
  /// In fr, this message translates to:
  /// **'Épargne'**
  String get dashboardQuickSavings;

  /// No description provided for @dashboardIncomeVsExpenses.
  ///
  /// In fr, this message translates to:
  /// **'Revenus vs Dépenses'**
  String get dashboardIncomeVsExpenses;

  /// No description provided for @dashboardExpenseBreakdown.
  ///
  /// In fr, this message translates to:
  /// **'Répartition des dépenses'**
  String get dashboardExpenseBreakdown;

  /// No description provided for @dashboardNoChartData.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée de transaction'**
  String get dashboardNoChartData;

  /// No description provided for @dashboardNoChartDataSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre première transaction pour voir le graphique'**
  String get dashboardNoChartDataSubtitle;

  /// No description provided for @budgetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Budget'**
  String get budgetTitle;

  /// No description provided for @budgetNoActiveBudget.
  ///
  /// In fr, this message translates to:
  /// **'Aucun budget actif'**
  String get budgetNoActiveBudget;

  /// No description provided for @budgetNoActiveBudgetSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez un budget pour commencer à suivre vos dépenses et garder le contrôle de vos finances.'**
  String get budgetNoActiveBudgetSubtitle;

  /// No description provided for @budgetCreateBudget.
  ///
  /// In fr, this message translates to:
  /// **'Créer un budget'**
  String get budgetCreateBudget;

  /// No description provided for @budgetEditBudget.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le budget'**
  String get budgetEditBudget;

  /// No description provided for @budgetNewBudget.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau budget'**
  String get budgetNewBudget;

  /// No description provided for @budgetTotalSpent.
  ///
  /// In fr, this message translates to:
  /// **'Total dépensé'**
  String get budgetTotalSpent;

  /// No description provided for @budgetOfBudget.
  ///
  /// In fr, this message translates to:
  /// **'sur {amount} de budget'**
  String budgetOfBudget(String amount);

  /// No description provided for @budgetWeekly.
  ///
  /// In fr, this message translates to:
  /// **'Hebdomadaire'**
  String get budgetWeekly;

  /// No description provided for @budgetBiWeekly.
  ///
  /// In fr, this message translates to:
  /// **'Bi-hebdomadaire'**
  String get budgetBiWeekly;

  /// No description provided for @budgetMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuel'**
  String get budgetMonthly;

  /// No description provided for @budgetStrategy5030.
  ///
  /// In fr, this message translates to:
  /// **'50/30/20'**
  String get budgetStrategy5030;

  /// No description provided for @budgetStrategy8020.
  ///
  /// In fr, this message translates to:
  /// **'80/20'**
  String get budgetStrategy8020;

  /// No description provided for @budgetStrategyEnvelope.
  ///
  /// In fr, this message translates to:
  /// **'Enveloppe'**
  String get budgetStrategyEnvelope;

  /// No description provided for @budgetStrategyCustom.
  ///
  /// In fr, this message translates to:
  /// **'Personnalisé'**
  String get budgetStrategyCustom;

  /// No description provided for @budgetSetupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un budget'**
  String get budgetSetupTitle;

  /// No description provided for @budgetSetupStep.
  ///
  /// In fr, this message translates to:
  /// **'Étape {current} sur {total}'**
  String budgetSetupStep(int current, int total);

  /// No description provided for @budgetSetupChooseStrategy.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre stratégie'**
  String get budgetSetupChooseStrategy;

  /// No description provided for @budgetSetupChooseStrategySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une méthode de budget adaptée à votre style de vie.'**
  String get budgetSetupChooseStrategySubtitle;

  /// No description provided for @budgetSetupSetPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Définissez votre période'**
  String get budgetSetupSetPeriod;

  /// No description provided for @budgetSetupSetPeriodSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'À quelle fréquence souhaitez-vous budgéter ?'**
  String get budgetSetupSetPeriodSubtitle;

  /// No description provided for @budgetSetupExpectedIncome.
  ///
  /// In fr, this message translates to:
  /// **'Revenu prévu (optionnel)'**
  String get budgetSetupExpectedIncome;

  /// No description provided for @budgetSetupExpectedIncomeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre revenu prévu pour calculer automatiquement les allocations.'**
  String get budgetSetupExpectedIncomeSubtitle;

  /// No description provided for @budgetSetupExpectedIncomeHint.
  ///
  /// In fr, this message translates to:
  /// **'0,00'**
  String get budgetSetupExpectedIncomeHint;

  /// No description provided for @budgetSetupBiWeekly.
  ///
  /// In fr, this message translates to:
  /// **'Bi-hebdomadaire (Toutes les 2 semaines)'**
  String get budgetSetupBiWeekly;

  /// No description provided for @budgetSetupCustomize.
  ///
  /// In fr, this message translates to:
  /// **'Personnaliser les allocations'**
  String get budgetSetupCustomize;

  /// No description provided for @budgetSetupCustomizeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajustez les montants pour chaque catégorie de dépenses.'**
  String get budgetSetupCustomizeSubtitle;

  /// No description provided for @budgetSetupReview.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier votre budget'**
  String get budgetSetupReview;

  /// No description provided for @budgetSetupReviewSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez les détails ci-dessous pour créer votre budget.'**
  String get budgetSetupReviewSubtitle;

  /// No description provided for @budgetSetupStrategy.
  ///
  /// In fr, this message translates to:
  /// **'Stratégie'**
  String get budgetSetupStrategy;

  /// No description provided for @budgetSetupPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get budgetSetupPeriod;

  /// No description provided for @budgetSetupIncome.
  ///
  /// In fr, this message translates to:
  /// **'Revenu'**
  String get budgetSetupIncome;

  /// No description provided for @budgetSetupTotalBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget total'**
  String get budgetSetupTotalBudget;

  /// No description provided for @budgetSetupCategoryBreakdown.
  ///
  /// In fr, this message translates to:
  /// **'Répartition par catégorie'**
  String get budgetSetupCategoryBreakdown;

  /// No description provided for @budgetSetupContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get budgetSetupContinue;

  /// No description provided for @budgetStrategy5030Name.
  ///
  /// In fr, this message translates to:
  /// **'Règle 50/30/20'**
  String get budgetStrategy5030Name;

  /// No description provided for @budgetStrategy5030Desc.
  ///
  /// In fr, this message translates to:
  /// **'Une approche équilibrée qui répartit votre revenu entre besoins, envies et épargne.'**
  String get budgetStrategy5030Desc;

  /// No description provided for @budgetStrategy5030Formula.
  ///
  /// In fr, this message translates to:
  /// **'50% Besoins - 30% Envies - 20% Épargne'**
  String get budgetStrategy5030Formula;

  /// No description provided for @budgetStrategy8020Name.
  ///
  /// In fr, this message translates to:
  /// **'80/20 Entrepreneur'**
  String get budgetStrategy8020Name;

  /// No description provided for @budgetStrategy8020Desc.
  ///
  /// In fr, this message translates to:
  /// **'Pour les entrepreneurs : réinvestissez 80% dans les essentiels et l\'entreprise, épargnez 20%.'**
  String get budgetStrategy8020Desc;

  /// No description provided for @budgetStrategy8020Formula.
  ///
  /// In fr, this message translates to:
  /// **'80% Essentiels & Business - 20% Épargne'**
  String get budgetStrategy8020Formula;

  /// No description provided for @budgetStrategyEnvelopeName.
  ///
  /// In fr, this message translates to:
  /// **'Système d\'enveloppes'**
  String get budgetStrategyEnvelopeName;

  /// No description provided for @budgetStrategyEnvelopeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Attribuez des montants fixes à chaque catégorie. Quand l\'enveloppe est vide, arrêtez de dépenser.'**
  String get budgetStrategyEnvelopeDesc;

  /// No description provided for @budgetStrategyEnvelopeFormula.
  ///
  /// In fr, this message translates to:
  /// **'Montants fixes par catégorie'**
  String get budgetStrategyEnvelopeFormula;

  /// No description provided for @budgetStrategyCustomName.
  ///
  /// In fr, this message translates to:
  /// **'Personnalisé'**
  String get budgetStrategyCustomName;

  /// No description provided for @budgetStrategyCustomDesc.
  ///
  /// In fr, this message translates to:
  /// **'Définissez vos propres pourcentages et montants pour un contrôle total de votre budget.'**
  String get budgetStrategyCustomDesc;

  /// No description provided for @budgetStrategyCustomFormula.
  ///
  /// In fr, this message translates to:
  /// **'Vous décidez la répartition'**
  String get budgetStrategyCustomFormula;

  /// No description provided for @categoryFoodGroceries.
  ///
  /// In fr, this message translates to:
  /// **'Alimentation & Courses'**
  String get categoryFoodGroceries;

  /// No description provided for @categoryRent.
  ///
  /// In fr, this message translates to:
  /// **'Loyer'**
  String get categoryRent;

  /// No description provided for @categoryTransport.
  ///
  /// In fr, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryUtilities.
  ///
  /// In fr, this message translates to:
  /// **'Services publics'**
  String get categoryUtilities;

  /// No description provided for @categoryHealth.
  ///
  /// In fr, this message translates to:
  /// **'Santé'**
  String get categoryHealth;

  /// No description provided for @categoryEntertainment.
  ///
  /// In fr, this message translates to:
  /// **'Divertissement'**
  String get categoryEntertainment;

  /// No description provided for @categoryClothing.
  ///
  /// In fr, this message translates to:
  /// **'Vêtements'**
  String get categoryClothing;

  /// No description provided for @categoryAirtimeData.
  ///
  /// In fr, this message translates to:
  /// **'Crédit & Data'**
  String get categoryAirtimeData;

  /// No description provided for @categoryPersonalCare.
  ///
  /// In fr, this message translates to:
  /// **'Soins personnels'**
  String get categoryPersonalCare;

  /// No description provided for @categoryFamilySupport.
  ///
  /// In fr, this message translates to:
  /// **'Soutien familial'**
  String get categoryFamilySupport;

  /// No description provided for @categorySavings.
  ///
  /// In fr, this message translates to:
  /// **'Épargne'**
  String get categorySavings;

  /// No description provided for @categoryDebtRepayment.
  ///
  /// In fr, this message translates to:
  /// **'Remboursement de dettes'**
  String get categoryDebtRepayment;

  /// No description provided for @categoryReligiousGiving.
  ///
  /// In fr, this message translates to:
  /// **'Don religieux'**
  String get categoryReligiousGiving;

  /// No description provided for @categoryBusinessExpenses.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses professionnelles'**
  String get categoryBusinessExpenses;

  /// No description provided for @categoryMobileMoneyFees.
  ///
  /// In fr, this message translates to:
  /// **'Frais Mobile Money'**
  String get categoryMobileMoneyFees;

  /// No description provided for @categoryGroupNeeds.
  ///
  /// In fr, this message translates to:
  /// **'Besoins'**
  String get categoryGroupNeeds;

  /// No description provided for @categoryGroupWants.
  ///
  /// In fr, this message translates to:
  /// **'Envies'**
  String get categoryGroupWants;

  /// No description provided for @categoryGroupSavings.
  ///
  /// In fr, this message translates to:
  /// **'Épargne'**
  String get categoryGroupSavings;

  /// No description provided for @categoryGroupEssentialsBusiness.
  ///
  /// In fr, this message translates to:
  /// **'Essentiels & Business'**
  String get categoryGroupEssentialsBusiness;

  /// No description provided for @savingsGoalsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs d\'épargne'**
  String get savingsGoalsTitle;

  /// No description provided for @savingsAddGoal.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un objectif'**
  String get savingsAddGoal;

  /// No description provided for @savingsNoGoals.
  ///
  /// In fr, this message translates to:
  /// **'Aucun objectif d\'épargne'**
  String get savingsNoGoals;

  /// No description provided for @savingsNoGoalsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Pour quoi épargnez-vous ? Définissez un objectif pour commencer à suivre.'**
  String get savingsNoGoalsSubtitle;

  /// No description provided for @savingsCreateGoal.
  ///
  /// In fr, this message translates to:
  /// **'Créer un objectif'**
  String get savingsCreateGoal;

  /// No description provided for @savingsNewGoal.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel objectif d\'épargne'**
  String get savingsNewGoal;

  /// No description provided for @savingsGoalName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'objectif'**
  String get savingsGoalName;

  /// No description provided for @savingsGoalNameHint.
  ///
  /// In fr, this message translates to:
  /// **'ex. Fonds d\'urgence, Nouvel ordinateur'**
  String get savingsGoalNameHint;

  /// No description provided for @savingsGoalNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un nom d\'objectif'**
  String get savingsGoalNameRequired;

  /// No description provided for @savingsTargetAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant cible ({currency})'**
  String savingsTargetAmount(String currency);

  /// No description provided for @savingsTargetAmountRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un montant cible'**
  String get savingsTargetAmountRequired;

  /// No description provided for @savingsTargetAmountInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un montant valide'**
  String get savingsTargetAmountInvalid;

  /// No description provided for @savingsDescriptionOptional.
  ///
  /// In fr, this message translates to:
  /// **'Description (optionnel)'**
  String get savingsDescriptionOptional;

  /// No description provided for @savingsDescriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'Pour quoi épargnez-vous ?'**
  String get savingsDescriptionHint;

  /// No description provided for @savingsDeadlineOptional.
  ///
  /// In fr, this message translates to:
  /// **'Échéance (optionnel)'**
  String get savingsDeadlineOptional;

  /// No description provided for @savingsNoDeadline.
  ///
  /// In fr, this message translates to:
  /// **'Aucune échéance définie'**
  String get savingsNoDeadline;

  /// No description provided for @savingsGoalDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails de l\'objectif'**
  String get savingsGoalDetails;

  /// No description provided for @savingsGoalNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Objectif introuvable'**
  String get savingsGoalNotFound;

  /// No description provided for @savingsDeleteGoal.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'objectif'**
  String get savingsDeleteGoal;

  /// No description provided for @savingsAddMoney.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter de l\'argent'**
  String get savingsAddMoney;

  /// No description provided for @savingsSaved.
  ///
  /// In fr, this message translates to:
  /// **'Épargné'**
  String get savingsSaved;

  /// No description provided for @savingsRemaining.
  ///
  /// In fr, this message translates to:
  /// **'Restant'**
  String get savingsRemaining;

  /// No description provided for @savingsTarget.
  ///
  /// In fr, this message translates to:
  /// **'Cible'**
  String get savingsTarget;

  /// No description provided for @savingsDeadline.
  ///
  /// In fr, this message translates to:
  /// **'Échéance'**
  String get savingsDeadline;

  /// No description provided for @savingsNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get savingsNotes;

  /// No description provided for @savingsContributionHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des contributions'**
  String get savingsContributionHistory;

  /// No description provided for @savingsNoContributions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune contribution. Appuyez sur \"Ajouter de l\'argent\" pour commencer !'**
  String get savingsNoContributions;

  /// No description provided for @savingsAddMoneyTo.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter de l\'argent à \"{name}\"'**
  String savingsAddMoneyTo(String name);

  /// No description provided for @savingsNoteOptional.
  ///
  /// In fr, this message translates to:
  /// **'Note (optionnel)'**
  String get savingsNoteOptional;

  /// No description provided for @savingsAddContribution.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une contribution'**
  String get savingsAddContribution;

  /// No description provided for @savingsDeleteGoalConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer \"{name}\" ? Cette action est irréversible.'**
  String savingsDeleteGoalConfirm(String name);

  /// No description provided for @savingsSavedLabel.
  ///
  /// In fr, this message translates to:
  /// **'épargné'**
  String get savingsSavedLabel;

  /// No description provided for @moreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Plus'**
  String get moreTitle;

  /// No description provided for @moreAccountSection.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get moreAccountSection;

  /// No description provided for @moreFeaturesSection.
  ///
  /// In fr, this message translates to:
  /// **'Fonctionnalités'**
  String get moreFeaturesSection;

  /// No description provided for @moreSupportSection.
  ///
  /// In fr, this message translates to:
  /// **'Support'**
  String get moreSupportSection;

  /// No description provided for @moreProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get moreProfile;

  /// No description provided for @moreSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get moreSettings;

  /// No description provided for @moreSavingsGoals.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs d\'épargne'**
  String get moreSavingsGoals;

  /// No description provided for @moreTontineGroups.
  ///
  /// In fr, this message translates to:
  /// **'Groupes de tontine'**
  String get moreTontineGroups;

  /// No description provided for @moreInsights.
  ///
  /// In fr, this message translates to:
  /// **'Analyses'**
  String get moreInsights;

  /// No description provided for @moreHelpSupport.
  ///
  /// In fr, this message translates to:
  /// **'Aide & Support'**
  String get moreHelpSupport;

  /// No description provided for @moreRateApp.
  ///
  /// In fr, this message translates to:
  /// **'Noter l\'application'**
  String get moreRateApp;

  /// No description provided for @moreShareApp.
  ///
  /// In fr, this message translates to:
  /// **'Partager avec des amis'**
  String get moreShareApp;

  /// No description provided for @moreShareAppMessage.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez Kalé - une application intelligente de budget et suivi des dépenses !'**
  String get moreShareAppMessage;

  /// No description provided for @moreComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt disponible'**
  String get moreComingSoon;

  /// No description provided for @moreComingSoonMessage.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt disponible ! Restez connecté.'**
  String get moreComingSoonMessage;

  /// No description provided for @tontineGroupsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Épargne communautaire'**
  String get tontineGroupsTitle;

  /// No description provided for @tontineGroupsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez ou créez un groupe de tontine pour épargner avec vos amis et votre famille. Mettez en commun vos cotisations et recevez la cagnotte à tour de rôle.'**
  String get tontineGroupsDescription;

  /// No description provided for @tontineGroupsHowItWorks.
  ///
  /// In fr, this message translates to:
  /// **'Comment ça marche'**
  String get tontineGroupsHowItWorks;

  /// No description provided for @tontineGroupsStep1Title.
  ///
  /// In fr, this message translates to:
  /// **'Créez ou rejoignez un groupe'**
  String get tontineGroupsStep1Title;

  /// No description provided for @tontineGroupsStep1Desc.
  ///
  /// In fr, this message translates to:
  /// **'Lancez un nouveau groupe de tontine ou rejoignez-en un existant grâce à une invitation.'**
  String get tontineGroupsStep1Desc;

  /// No description provided for @tontineGroupsStep2Title.
  ///
  /// In fr, this message translates to:
  /// **'Cotisez régulièrement'**
  String get tontineGroupsStep2Title;

  /// No description provided for @tontineGroupsStep2Desc.
  ///
  /// In fr, this message translates to:
  /// **'Chaque membre verse un montant fixe selon un calendrier défini.'**
  String get tontineGroupsStep2Desc;

  /// No description provided for @tontineGroupsStep3Title.
  ///
  /// In fr, this message translates to:
  /// **'Recevez la cagnotte'**
  String get tontineGroupsStep3Title;

  /// No description provided for @tontineGroupsStep3Desc.
  ///
  /// In fr, this message translates to:
  /// **'Les membres reçoivent à tour de rôle la totalité de la somme mise en commun.'**
  String get tontineGroupsStep3Desc;

  /// No description provided for @tontineGroupsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun groupe pour l\'instant'**
  String get tontineGroupsEmpty;

  /// No description provided for @tontineGroupsEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre premier groupe de tontine et commencez à épargner ensemble.'**
  String get tontineGroupsEmptySubtitle;

  /// No description provided for @tontineGroupsCreateGroup.
  ///
  /// In fr, this message translates to:
  /// **'Créer un groupe'**
  String get tontineGroupsCreateGroup;

  /// No description provided for @helpFaqTitle.
  ///
  /// In fr, this message translates to:
  /// **'Questions fréquentes'**
  String get helpFaqTitle;

  /// No description provided for @helpFaq1Question.
  ///
  /// In fr, this message translates to:
  /// **'Comment ajouter une transaction ?'**
  String get helpFaq1Question;

  /// No description provided for @helpFaq1Answer.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur le bouton + de l\'écran d\'accueil pour ajouter un revenu ou une dépense. Renseignez le montant, la catégorie et des notes facultatives.'**
  String get helpFaq1Answer;

  /// No description provided for @helpFaq2Question.
  ///
  /// In fr, this message translates to:
  /// **'Comment fonctionnent les budgets ?'**
  String get helpFaq2Question;

  /// No description provided for @helpFaq2Answer.
  ///
  /// In fr, this message translates to:
  /// **'Allez dans l\'onglet Budget pour définir des limites de dépenses mensuelles par catégorie. Kalé suit vos dépenses et vous prévient lorsque vous approchez de votre limite.'**
  String get helpFaq2Answer;

  /// No description provided for @helpFaq3Question.
  ///
  /// In fr, this message translates to:
  /// **'Puis-je définir des objectifs d\'épargne ?'**
  String get helpFaq3Question;

  /// No description provided for @helpFaq3Answer.
  ///
  /// In fr, this message translates to:
  /// **'Oui ! Allez dans Plus > Objectifs d\'épargne pour créer des objectifs comme des vacances, un fonds d\'urgence ou un gros achat. Suivez votre progression au fil du temps.'**
  String get helpFaq3Answer;

  /// No description provided for @helpFaq4Question.
  ///
  /// In fr, this message translates to:
  /// **'Mes données sont-elles sécurisées ?'**
  String get helpFaq4Question;

  /// No description provided for @helpFaq4Answer.
  ///
  /// In fr, this message translates to:
  /// **'Vos données sont chiffrées et stockées en toute sécurité. Nous ne partageons jamais vos informations financières avec des tiers. Vous pouvez effacer les données locales à tout moment depuis les Paramètres.'**
  String get helpFaq4Answer;

  /// No description provided for @helpContactTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nous contacter'**
  String get helpContactTitle;

  /// No description provided for @helpContactEmail.
  ///
  /// In fr, this message translates to:
  /// **'Assistance par e-mail'**
  String get helpContactEmail;

  /// No description provided for @helpContactChat.
  ///
  /// In fr, this message translates to:
  /// **'Chat en direct'**
  String get helpContactChat;

  /// No description provided for @helpContactChatSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Disponible du lundi au vendredi, de 9 h à 17 h'**
  String get helpContactChatSubtitle;

  /// No description provided for @helpLegalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mentions légales'**
  String get helpLegalTitle;

  /// No description provided for @rateAppTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous aimez Kalé ?'**
  String get rateAppTitle;

  /// No description provided for @rateAppSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre avis nous aide à nous améliorer. Dites-nous ce que vous en pensez !'**
  String get rateAppSubtitle;

  /// No description provided for @rateAppSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer la note'**
  String get rateAppSubmit;

  /// No description provided for @rateAppLabel1.
  ///
  /// In fr, this message translates to:
  /// **'À améliorer'**
  String get rateAppLabel1;

  /// No description provided for @rateAppLabel2.
  ///
  /// In fr, this message translates to:
  /// **'Pourrait être mieux'**
  String get rateAppLabel2;

  /// No description provided for @rateAppLabel3.
  ///
  /// In fr, this message translates to:
  /// **'Correct'**
  String get rateAppLabel3;

  /// No description provided for @rateAppLabel4.
  ///
  /// In fr, this message translates to:
  /// **'Super appli !'**
  String get rateAppLabel4;

  /// No description provided for @rateAppLabel5.
  ///
  /// In fr, this message translates to:
  /// **'J\'adore !'**
  String get rateAppLabel5;

  /// No description provided for @rateAppThankYou.
  ///
  /// In fr, this message translates to:
  /// **'Merci !'**
  String get rateAppThankYou;

  /// No description provided for @rateAppThankYouMessage.
  ///
  /// In fr, this message translates to:
  /// **'Nous apprécions votre avis. Il nous aide à rendre Kalé encore meilleure pour vous.'**
  String get rateAppThankYouMessage;

  /// No description provided for @shareAppTitle.
  ///
  /// In fr, this message translates to:
  /// **'Partager Kalé'**
  String get shareAppTitle;

  /// No description provided for @shareAppDescription.
  ///
  /// In fr, this message translates to:
  /// **'Aidez vos amis et votre famille à prendre le contrôle de leurs finances avec Kalé.'**
  String get shareAppDescription;

  /// No description provided for @shareAppShareVia.
  ///
  /// In fr, this message translates to:
  /// **'PARTAGER VIA'**
  String get shareAppShareVia;

  /// No description provided for @shareAppCopyLink.
  ///
  /// In fr, this message translates to:
  /// **'Copier le lien de téléchargement'**
  String get shareAppCopyLink;

  /// No description provided for @shareAppCopyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Copier le message de partage'**
  String get shareAppCopyMessage;

  /// No description provided for @shareAppLinkCopied.
  ///
  /// In fr, this message translates to:
  /// **'Lien copié dans le presse-papiers'**
  String get shareAppLinkCopied;

  /// No description provided for @shareAppMessageCopied.
  ///
  /// In fr, this message translates to:
  /// **'Message copié dans le presse-papiers'**
  String get shareAppMessageCopied;

  /// No description provided for @onboardingTitle4.
  ///
  /// In fr, this message translates to:
  /// **'Personnalisez votre expérience'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez vos préférences pour tirer le meilleur parti de Kalé.'**
  String get onboardingDesc4;

  /// No description provided for @onboardingCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Devise'**
  String get onboardingCurrency;

  /// No description provided for @onboardingLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get onboardingLanguage;

  /// No description provided for @onboardingGoal.
  ///
  /// In fr, this message translates to:
  /// **'Quel est votre objectif principal ?'**
  String get onboardingGoal;

  /// No description provided for @onboardingGoalTrackSpending.
  ///
  /// In fr, this message translates to:
  /// **'Suivre mes dépenses'**
  String get onboardingGoalTrackSpending;

  /// No description provided for @onboardingGoalSaveMore.
  ///
  /// In fr, this message translates to:
  /// **'Épargner plus'**
  String get onboardingGoalSaveMore;

  /// No description provided for @onboardingGoalManageBudgets.
  ///
  /// In fr, this message translates to:
  /// **'Gérer mes budgets'**
  String get onboardingGoalManageBudgets;

  /// No description provided for @coachMarkFab.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez ici pour ajouter votre première transaction'**
  String get coachMarkFab;

  /// No description provided for @coachMarkBudget.
  ///
  /// In fr, this message translates to:
  /// **'Configurez votre budget mensuel'**
  String get coachMarkBudget;

  /// No description provided for @coachMarkPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Basculez entre les vues quotidienne, hebdomadaire et mensuelle'**
  String get coachMarkPeriod;

  /// No description provided for @coachMarkGotIt.
  ///
  /// In fr, this message translates to:
  /// **'Compris'**
  String get coachMarkGotIt;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileEditProfile.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get profileEditProfile;

  /// No description provided for @profileChangePassword.
  ///
  /// In fr, this message translates to:
  /// **'Changer le mot de passe'**
  String get profileChangePassword;

  /// No description provided for @profileLogout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get profileLogout;

  /// No description provided for @profileAchievements.
  ///
  /// In fr, this message translates to:
  /// **'Accomplissements'**
  String get profileAchievements;

  /// No description provided for @profileLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau : {level}'**
  String profileLevel(String level);

  /// No description provided for @profileBadgesUnlocked.
  ///
  /// In fr, this message translates to:
  /// **'{count} sur {total} badges débloqués'**
  String profileBadgesUnlocked(int count, int total);

  /// No description provided for @achievementFirstTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Première transaction'**
  String get achievementFirstTransaction;

  /// No description provided for @achievementStreak7.
  ///
  /// In fr, this message translates to:
  /// **'Série de 7 jours'**
  String get achievementStreak7;

  /// No description provided for @achievementStreak30.
  ///
  /// In fr, this message translates to:
  /// **'Série de 30 jours'**
  String get achievementStreak30;

  /// No description provided for @achievementFirstBudget.
  ///
  /// In fr, this message translates to:
  /// **'Premier budget'**
  String get achievementFirstBudget;

  /// No description provided for @achievementUnderBudget.
  ///
  /// In fr, this message translates to:
  /// **'Sous le budget'**
  String get achievementUnderBudget;

  /// No description provided for @achievementFirstGoalCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Objectif atteint'**
  String get achievementFirstGoalCompleted;

  /// No description provided for @achievementTransactions100.
  ///
  /// In fr, this message translates to:
  /// **'100 transactions'**
  String get achievementTransactions100;

  /// No description provided for @levelBeginner.
  ///
  /// In fr, this message translates to:
  /// **'Débutant'**
  String get levelBeginner;

  /// No description provided for @levelExplorer.
  ///
  /// In fr, this message translates to:
  /// **'Explorateur'**
  String get levelExplorer;

  /// No description provided for @levelPro.
  ///
  /// In fr, this message translates to:
  /// **'Pro'**
  String get levelPro;

  /// No description provided for @levelMaster.
  ///
  /// In fr, this message translates to:
  /// **'Maître'**
  String get levelMaster;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get settingsLanguageEn;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l\'appareil'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsTerms.
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get settingsPrivacy;

  /// No description provided for @settingsCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Devise'**
  String get settingsCurrency;

  /// No description provided for @settingsSelectCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner la devise'**
  String get settingsSelectCurrency;

  /// No description provided for @settingsNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications push'**
  String get settingsPushNotifications;

  /// No description provided for @settingsEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Activé'**
  String get settingsEnabled;

  /// No description provided for @settingsDisabled.
  ///
  /// In fr, this message translates to:
  /// **'Désactivé'**
  String get settingsDisabled;

  /// No description provided for @settingsDailyReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel quotidien'**
  String get settingsDailyReminder;

  /// No description provided for @settingsDailyReminderSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Me rappeler de saisir mes transactions'**
  String get settingsDailyReminderSubtitle;

  /// No description provided for @settingsBudgetAlertThreshold.
  ///
  /// In fr, this message translates to:
  /// **'Seuil d\'alerte budget'**
  String get settingsBudgetAlertThreshold;

  /// No description provided for @settingsBudgetAlertThresholdSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Alerte lorsque les dépenses atteignent {percentage} % du budget'**
  String settingsBudgetAlertThresholdSubtitle(int percentage);

  /// No description provided for @settingsData.
  ///
  /// In fr, this message translates to:
  /// **'Données'**
  String get settingsData;

  /// No description provided for @settingsClearLocalData.
  ///
  /// In fr, this message translates to:
  /// **'Effacer les données locales'**
  String get settingsClearLocalData;

  /// No description provided for @settingsClearLocalDataSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer toutes les données en cache de cet appareil'**
  String get settingsClearLocalDataSubtitle;

  /// No description provided for @settingsClearLocalDataConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Cela supprimera toutes les données en cache de cet appareil. Votre compte et vos données synchronisées sur le serveur ne seront pas affectés.\n\nÊtes-vous sûr ?'**
  String get settingsClearLocalDataConfirm;

  /// No description provided for @settingsClearLocalDataSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Données locales effacées'**
  String get settingsClearLocalDataSuccess;

  /// No description provided for @legalLastUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Dernière mise à jour : 20 février 2026'**
  String get legalLastUpdated;

  /// No description provided for @legalContactFooter.
  ///
  /// In fr, this message translates to:
  /// **'Si vous avez des questions, contactez-nous à support@kale.app'**
  String get legalContactFooter;

  /// No description provided for @legalTosTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get legalTosTitle;

  /// No description provided for @legalTosIntroHeading.
  ///
  /// In fr, this message translates to:
  /// **'1. Introduction'**
  String get legalTosIntroHeading;

  /// No description provided for @legalTosIntroBody.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur Kalé. Ces Conditions d\'utilisation régissent votre utilisation de l\'application mobile Kalé et des services associés. En créant un compte ou en utilisant Kalé, vous acceptez d\'être lié par ces conditions. Si vous n\'êtes pas d\'accord, veuillez ne pas utiliser l\'application.'**
  String get legalTosIntroBody;

  /// No description provided for @legalTosAccountHeading.
  ///
  /// In fr, this message translates to:
  /// **'2. Inscription au compte'**
  String get legalTosAccountHeading;

  /// No description provided for @legalTosAccountBody.
  ///
  /// In fr, this message translates to:
  /// **'Pour utiliser Kalé, vous devez créer un compte avec des informations exactes et complètes. Vous êtes responsable du maintien de la confidentialité de vos identifiants de connexion et de toute activité sous votre compte. Vous devez avoir au moins 13 ans pour créer un compte. Si vous avez moins de 18 ans, vous confirmez avoir le consentement de votre parent ou tuteur.'**
  String get legalTosAccountBody;

  /// No description provided for @legalTosServicesHeading.
  ///
  /// In fr, this message translates to:
  /// **'3. Services fournis'**
  String get legalTosServicesHeading;

  /// No description provided for @legalTosServicesBody.
  ///
  /// In fr, this message translates to:
  /// **'Kalé fournit des outils de gestion des finances personnelles comprenant le suivi des dépenses et des revenus, la création et le suivi de budgets, la gestion des objectifs d\'épargne et des analyses financières. Ces outils sont conçus pour vous aider à organiser et comprendre vos finances personnelles.'**
  String get legalTosServicesBody;

  /// No description provided for @legalTosResponsibilitiesHeading.
  ///
  /// In fr, this message translates to:
  /// **'4. Responsabilités de l\'utilisateur'**
  String get legalTosResponsibilitiesHeading;

  /// No description provided for @legalTosResponsibilitiesBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes seul responsable de l\'exactitude des données financières que vous saisissez dans Kalé. Kalé est un outil de suivi et d\'organisation et ne fournit pas de conseils financiers, d\'investissement, fiscaux ou juridiques professionnels. Vous acceptez d\'utiliser l\'application conformément à toutes les lois et réglementations applicables.'**
  String get legalTosResponsibilitiesBody;

  /// No description provided for @legalTosFinancialDataHeading.
  ///
  /// In fr, this message translates to:
  /// **'5. Données financières'**
  String get legalTosFinancialDataHeading;

  /// No description provided for @legalTosFinancialDataBody.
  ///
  /// In fr, this message translates to:
  /// **'Kalé n\'est pas une banque, un processeur de paiement ou une institution financière. Nous ne détenons pas, ne transférons pas et n\'avons pas la garde de vos fonds. Toutes les données financières dans Kalé sont des informations saisies par l\'utilisateur à des fins de suivi personnel uniquement. Nous ne vérifions pas l\'exactitude des transactions, soldes ou autres informations financières que vous saisissez.'**
  String get legalTosFinancialDataBody;

  /// No description provided for @legalTosIpHeading.
  ///
  /// In fr, this message translates to:
  /// **'6. Propriété intellectuelle'**
  String get legalTosIpHeading;

  /// No description provided for @legalTosIpBody.
  ///
  /// In fr, this message translates to:
  /// **'L\'application Kalé, y compris sa conception, son code, ses fonctionnalités et sa marque, est la propriété de Kalé et protégée par les lois sur la propriété intellectuelle. Vous conservez la pleine propriété des données personnelles et des informations financières que vous saisissez dans l\'application. Vous accordez à Kalé une licence limitée pour traiter vos données uniquement pour fournir et améliorer les services.'**
  String get legalTosIpBody;

  /// No description provided for @legalTosLiabilityHeading.
  ///
  /// In fr, this message translates to:
  /// **'7. Limitation de responsabilité'**
  String get legalTosLiabilityHeading;

  /// No description provided for @legalTosLiabilityBody.
  ///
  /// In fr, this message translates to:
  /// **'Kalé est fourni \"en l\'état\". Nous ne sommes pas responsables des décisions financières que vous prenez sur la base des informations affichées dans l\'application. Nous ne garantissons pas l\'exactitude des calculs, résumés ou analyses dérivées de vos données. Dans la mesure maximale permise par la loi, Kalé ne sera pas responsable des dommages indirects, accessoires ou consécutifs.'**
  String get legalTosLiabilityBody;

  /// No description provided for @legalTosTerminationHeading.
  ///
  /// In fr, this message translates to:
  /// **'8. Résiliation'**
  String get legalTosTerminationHeading;

  /// No description provided for @legalTosTerminationBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez supprimer votre compte à tout moment via les paramètres de l\'application. Nous pouvons suspendre ou résilier votre compte si vous violez ces conditions. À la résiliation, vos données seront supprimées de nos serveurs dans les 30 jours, sauf si la conservation est requise par la loi.'**
  String get legalTosTerminationBody;

  /// No description provided for @legalTosChangesHeading.
  ///
  /// In fr, this message translates to:
  /// **'9. Modifications de ces conditions'**
  String get legalTosChangesHeading;

  /// No description provided for @legalTosChangesBody.
  ///
  /// In fr, this message translates to:
  /// **'Nous pouvons mettre à jour ces Conditions d\'utilisation de temps en temps. Nous vous informerons des modifications importantes via l\'application ou par e-mail. Votre utilisation continue de Kalé après la publication des modifications constitue votre acceptation des conditions mises à jour.'**
  String get legalTosChangesBody;

  /// No description provided for @legalTosContactHeading.
  ///
  /// In fr, this message translates to:
  /// **'10. Nous contacter'**
  String get legalTosContactHeading;

  /// No description provided for @legalTosContactBody.
  ///
  /// In fr, this message translates to:
  /// **'Si vous avez des questions sur ces Conditions d\'utilisation, veuillez nous contacter à support@kale.app.'**
  String get legalTosContactBody;

  /// No description provided for @legalPrivacyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get legalPrivacyTitle;

  /// No description provided for @legalPrivacyIntroHeading.
  ///
  /// In fr, this message translates to:
  /// **'1. Introduction'**
  String get legalPrivacyIntroHeading;

  /// No description provided for @legalPrivacyIntroBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre vie privée est importante pour nous. Cette Politique de confidentialité explique comment Kalé collecte, utilise, stocke et protège vos informations personnelles et financières. Nous nous engageons à traiter vos données avec transparence et soin.'**
  String get legalPrivacyIntroBody;

  /// No description provided for @legalPrivacyCollectionHeading.
  ///
  /// In fr, this message translates to:
  /// **'2. Informations que nous collectons'**
  String get legalPrivacyCollectionHeading;

  /// No description provided for @legalPrivacyCollectionBody.
  ///
  /// In fr, this message translates to:
  /// **'Nous collectons les types d\'informations suivants :\n\nInformations de compte : Votre nom, adresse e-mail et identifiants d\'authentification lors de la création de votre compte.\n\nDonnées financières : Enregistrements de transactions, configurations de budget, objectifs d\'épargne et préférences de catégories que vous saisissez dans l\'application.\n\nDonnées d\'utilisation : Analyses anonymes de la façon dont vous interagissez avec l\'application, y compris les vues d\'écran et l\'utilisation des fonctionnalités, pour nous aider à améliorer l\'expérience.\n\nInformations sur l\'appareil : Type d\'appareil, version du système d\'exploitation et version de l\'application à des fins de compatibilité et de dépannage.'**
  String get legalPrivacyCollectionBody;

  /// No description provided for @legalPrivacyUsageHeading.
  ///
  /// In fr, this message translates to:
  /// **'3. Comment nous utilisons vos données'**
  String get legalPrivacyUsageHeading;

  /// No description provided for @legalPrivacyUsageBody.
  ///
  /// In fr, this message translates to:
  /// **'Nous utilisons vos informations pour :\n\n- Fournir, maintenir et améliorer les fonctionnalités et services de Kalé\n- Générer des résumés financiers personnalisés, des graphiques et des analyses\n- Vous envoyer des notifications telles que des alertes de budget et des rappels quotidiens (lorsqu\'ils sont activés)\n- Authentifier votre identité et sécuriser votre compte\n- Analyser les tendances d\'utilisation agrégées pour améliorer l\'expérience de l\'application'**
  String get legalPrivacyUsageBody;

  /// No description provided for @legalPrivacyStorageHeading.
  ///
  /// In fr, this message translates to:
  /// **'4. Stockage et sécurité des données'**
  String get legalPrivacyStorageHeading;

  /// No description provided for @legalPrivacyStorageBody.
  ///
  /// In fr, this message translates to:
  /// **'Vos données sont stockées de manière sécurisée en utilisant des pratiques conformes aux normes de l\'industrie. Toutes les données sont chiffrées en transit via TLS et au repos sur nos serveurs. Nous utilisons Supabase comme infrastructure backend, qui fournit une sécurité de niveau entreprise, des contrôles d\'accès et une isolation des données. Nous révisons régulièrement nos pratiques de sécurité et limitons l\'accès à vos données au personnel autorisé uniquement.'**
  String get legalPrivacyStorageBody;

  /// No description provided for @legalPrivacyThirdPartyHeading.
  ///
  /// In fr, this message translates to:
  /// **'5. Services tiers'**
  String get legalPrivacyThirdPartyHeading;

  /// No description provided for @legalPrivacyThirdPartyBody.
  ///
  /// In fr, this message translates to:
  /// **'Kalé s\'intègre aux services tiers suivants :\n\n- Google Sign-In et Apple Sign-In pour l\'authentification\n- Services d\'analyse pour le suivi anonyme de l\'utilisation\n- Services de signalement de crash pour identifier et corriger les problèmes de l\'application\n\nNous ne vendons pas, ne louons pas et ne partageons pas vos données personnelles ou financières avec des tiers à des fins de marketing. Les services tiers ne reçoivent que les données minimales nécessaires pour remplir leur fonction.'**
  String get legalPrivacyThirdPartyBody;

  /// No description provided for @legalPrivacyRightsHeading.
  ///
  /// In fr, this message translates to:
  /// **'6. Vos droits'**
  String get legalPrivacyRightsHeading;

  /// No description provided for @legalPrivacyRightsBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez le droit de :\n\n- Accéder aux données personnelles que nous détenons sur vous\n- Corriger les informations inexactes de votre compte\n- Supprimer votre compte et toutes les données associées\n- Exporter vos données financières\n- Restreindre ou vous opposer à certains traitements de vos données\n\nPour exercer l\'un de ces droits, contactez-nous à privacy@kale.app ou utilisez les fonctionnalités de gestion de compte dans l\'application.'**
  String get legalPrivacyRightsBody;

  /// No description provided for @legalPrivacyRetentionHeading.
  ///
  /// In fr, this message translates to:
  /// **'7. Conservation des données'**
  String get legalPrivacyRetentionHeading;

  /// No description provided for @legalPrivacyRetentionBody.
  ///
  /// In fr, this message translates to:
  /// **'Nous conservons vos données aussi longtemps que votre compte est actif. Si vous supprimez votre compte, nous supprimerons vos données personnelles et financières de nos serveurs dans les 30 jours. Certaines données anonymisées et agrégées peuvent être conservées à des fins d\'analyse. Nous pouvons également conserver certaines données comme requis par la loi.'**
  String get legalPrivacyRetentionBody;

  /// No description provided for @legalPrivacyChildrenHeading.
  ///
  /// In fr, this message translates to:
  /// **'8. Vie privée des enfants'**
  String get legalPrivacyChildrenHeading;

  /// No description provided for @legalPrivacyChildrenBody.
  ///
  /// In fr, this message translates to:
  /// **'Kalé ne s\'adresse pas aux enfants de moins de 13 ans. Nous ne collectons pas sciemment d\'informations personnelles auprès d\'enfants de moins de 13 ans. Si nous apprenons que nous avons collecté des données d\'un enfant de moins de 13 ans sans le consentement parental, nous prendrons des mesures pour supprimer ces informations rapidement.'**
  String get legalPrivacyChildrenBody;

  /// No description provided for @legalPrivacyChangesHeading.
  ///
  /// In fr, this message translates to:
  /// **'9. Modifications de cette politique'**
  String get legalPrivacyChangesHeading;

  /// No description provided for @legalPrivacyChangesBody.
  ///
  /// In fr, this message translates to:
  /// **'Nous pouvons mettre à jour cette Politique de confidentialité de temps en temps. Nous vous informerons des modifications importantes via une notification dans l\'application ou par e-mail. Nous vous encourageons à consulter cette politique périodiquement. Votre utilisation continue de Kalé après la publication des modifications constitue votre acceptation de la politique mise à jour.'**
  String get legalPrivacyChangesBody;

  /// No description provided for @legalPrivacyContactHeading.
  ///
  /// In fr, this message translates to:
  /// **'10. Nous contacter'**
  String get legalPrivacyContactHeading;

  /// No description provided for @legalPrivacyContactBody.
  ///
  /// In fr, this message translates to:
  /// **'Si vous avez des questions sur cette Politique de confidentialité ou sur la façon dont vos données sont traitées, veuillez nous contacter à privacy@kale.app.'**
  String get legalPrivacyContactBody;

  /// No description provided for @offlineBanner.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes hors ligne'**
  String get offlineBanner;

  /// No description provided for @emptyStateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rien ici pour le moment'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Revenez plus tard pour les mises à jour.'**
  String get emptyStateSubtitle;

  /// No description provided for @budgetEmptyRecommendation.
  ///
  /// In fr, this message translates to:
  /// **'Nous recommandons la règle 50/30/20 pour commencer'**
  String get budgetEmptyRecommendation;

  /// No description provided for @budgetStartWith5030.
  ///
  /// In fr, this message translates to:
  /// **'Commencer avec 50/30/20'**
  String get budgetStartWith5030;

  /// No description provided for @budgetCustomBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget personnalise'**
  String get budgetCustomBudget;

  /// No description provided for @budgetEmptyQuickTip.
  ///
  /// In fr, this message translates to:
  /// **'Cela ne prend qu\'une minute à configurer'**
  String get budgetEmptyQuickTip;

  /// No description provided for @savingsEmptyTemplateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs populaires pour vous inspirer'**
  String get savingsEmptyTemplateTitle;

  /// No description provided for @savingsTemplateEmergency.
  ///
  /// In fr, this message translates to:
  /// **'Fonds d\'urgence'**
  String get savingsTemplateEmergency;

  /// No description provided for @savingsTemplateVacation.
  ///
  /// In fr, this message translates to:
  /// **'Vacances'**
  String get savingsTemplateVacation;

  /// No description provided for @savingsTemplateNewPhone.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau téléphone'**
  String get savingsTemplateNewPhone;

  /// No description provided for @savingsEmptyOrCreate.
  ///
  /// In fr, this message translates to:
  /// **'Ou créez votre propre objectif'**
  String get savingsEmptyOrCreate;

  /// No description provided for @transactionsEmptyQuickTip.
  ///
  /// In fr, this message translates to:
  /// **'Cela ne prend que 10 secondes'**
  String get transactionsEmptyQuickTip;

  /// No description provided for @dashboardEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur Kalé !'**
  String get dashboardEmptyTitle;

  /// No description provided for @dashboardEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Complétez ces étapes pour tirer le meilleur parti de vos finances :'**
  String get dashboardEmptySubtitle;

  /// No description provided for @dashboardEmptyStep1.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre première transaction'**
  String get dashboardEmptyStep1;

  /// No description provided for @dashboardEmptyStep2.
  ///
  /// In fr, this message translates to:
  /// **'Configurez un budget'**
  String get dashboardEmptyStep2;

  /// No description provided for @dashboardEmptyStep3.
  ///
  /// In fr, this message translates to:
  /// **'Créez un objectif d\'épargne'**
  String get dashboardEmptyStep3;

  /// No description provided for @dashboardStreak.
  ///
  /// In fr, this message translates to:
  /// **'Série de {count} jours'**
  String dashboardStreak(int count);

  /// No description provided for @dashboardStreakStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencez votre série !'**
  String get dashboardStreakStart;

  /// No description provided for @dashboardFinancialHealth.
  ///
  /// In fr, this message translates to:
  /// **'Santé financière'**
  String get dashboardFinancialHealth;

  /// No description provided for @dashboardHealthExcellent.
  ///
  /// In fr, this message translates to:
  /// **'Excellent'**
  String get dashboardHealthExcellent;

  /// No description provided for @dashboardHealthGood.
  ///
  /// In fr, this message translates to:
  /// **'Bien'**
  String get dashboardHealthGood;

  /// No description provided for @dashboardHealthFair.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get dashboardHealthFair;

  /// No description provided for @dashboardHealthNeedsWork.
  ///
  /// In fr, this message translates to:
  /// **'À améliorer'**
  String get dashboardHealthNeedsWork;

  /// No description provided for @notificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes à jour ! Les notifications concernant vos budgets, épargnes et rappels apparaîtront ici.'**
  String get notificationsEmptySubtitle;

  /// No description provided for @baseCurrencyStepTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre devise'**
  String get baseCurrencyStepTitle;

  /// No description provided for @baseCurrencyStepDescription.
  ///
  /// In fr, this message translates to:
  /// **'Tous les montants dans Kalé sont enregistrés dans cette devise. Vous pourrez la changer plus tard.'**
  String get baseCurrencyStepDescription;

  /// No description provided for @baseCurrencyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Devise de base'**
  String get baseCurrencyLabel;

  /// No description provided for @baseCurrencyRelabelTitle.
  ///
  /// In fr, this message translates to:
  /// **'Changer la devise de base ?'**
  String get baseCurrencyRelabelTitle;

  /// No description provided for @baseCurrencyRelabelMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vos transactions existantes gardent les mêmes chiffres et seront affichées en {currency}. Aucune conversion n\'est faite.'**
  String baseCurrencyRelabelMessage(String currency);

  /// No description provided for @baseCurrencyRelabelConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Changer quand même'**
  String get baseCurrencyRelabelConfirm;

  /// No description provided for @baseCurrencyChangeFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de changer la devise. Veuillez réessayer.'**
  String get baseCurrencyChangeFailed;

  /// Sync banner and Settings: changes that failed every retry
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 modification non sauvegardée} other{{count} modifications non sauvegardées}}'**
  String backupStuck(int count);

  /// Sync banner while offline with changes not yet backed up
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Hors ligne · 1 modification en attente} other{Hors ligne · {count} modifications en attente}}'**
  String backupOfflinePending(int count);

  /// No description provided for @backupSyncing.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde en cours…'**
  String get backupSyncing;

  /// No description provided for @settingsBackup.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde'**
  String get settingsBackup;

  /// No description provided for @settingsBackupUpToDate.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les modifications sont sauvegardées'**
  String get settingsBackupUpToDate;

  /// No description provided for @settingsBackupPending.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 modification en attente de sauvegarde} other{{count} modifications en attente de sauvegarde}}'**
  String settingsBackupPending(int count);

  /// No description provided for @settingsBackupLast.
  ///
  /// In fr, this message translates to:
  /// **'Dernière sauvegarde : {date}'**
  String settingsBackupLast(String date);

  /// No description provided for @settingsBackupNever.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore sauvegardé'**
  String get settingsBackupNever;

  /// No description provided for @logoutUnsavedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter et perdre des modifications ?'**
  String get logoutUnsavedTitle;

  /// No description provided for @logoutUnsavedMessage.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 modification n\'est pas encore sauvegardée. Si vous vous déconnectez maintenant, elle sera définitivement perdue.} other{{count} modifications ne sont pas encore sauvegardées. Si vous vous déconnectez maintenant, elles seront définitivement perdues.}}'**
  String logoutUnsavedMessage(int count);

  /// No description provided for @logoutUnsavedConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter quand même'**
  String get logoutUnsavedConfirm;

  /// No description provided for @logoutUnsavedCancel.
  ///
  /// In fr, this message translates to:
  /// **'Rester connecté'**
  String get logoutUnsavedCancel;

  /// No description provided for @logoutFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de vérifier votre sauvegarde. Veuillez réessayer.'**
  String get logoutFailed;

  /// No description provided for @restoreInProgress.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Restauration de vos données…} =1{Restauration de vos données… 1 élément} other{Restauration de vos données… {count} éléments}}'**
  String restoreInProgress(int count);

  /// No description provided for @refreshOffline.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes hors ligne. Tirez pour actualiser une fois connecté.'**
  String get refreshOffline;

  /// No description provided for @refreshFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'actualiser depuis votre sauvegarde. Veuillez réessayer.'**
  String get refreshFailed;

  /// No description provided for @saveDataTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder vos données'**
  String get saveDataTitle;

  /// No description provided for @saveDataSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez un compte pour garder tout ce que vous avez saisi, sur ce téléphone et sur les autres.'**
  String get saveDataSubtitle;

  /// No description provided for @saveDataWithEmail.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec l\'e-mail'**
  String get saveDataWithEmail;

  /// No description provided for @saveDataCodeSent.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le code à 6 chiffres envoyé à {email}.'**
  String saveDataCodeSent(String email);

  /// No description provided for @saveDataVerify.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier'**
  String get saveDataVerify;

  /// No description provided for @saveDataDone.
  ///
  /// In fr, this message translates to:
  /// **'Vos données sont sauvegardées sur votre compte.'**
  String get saveDataDone;

  /// No description provided for @guestDataChoiceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce compte existe déjà'**
  String get guestDataChoiceTitle;

  /// No description provided for @guestDataChoiceMessage.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Vous n\'avez encore aucune saisie sur ce téléphone.} =1{Vous avez 1 saisie sur ce téléphone. L\'ajouter à ce compte, ou la supprimer ?} other{Vous avez {count} saisies sur ce téléphone. Les ajouter à ce compte, ou les supprimer ?}}'**
  String guestDataChoiceMessage(int count);

  /// No description provided for @guestDataChoiceAdd.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Se connecter} =1{Ajouter ma saisie à ce compte} other{Ajouter mes {count} saisies à ce compte}}'**
  String guestDataChoiceAdd(int count);

  /// No description provided for @guestDataChoiceDiscard.
  ///
  /// In fr, this message translates to:
  /// **'Les supprimer et se connecter'**
  String get guestDataChoiceDiscard;

  /// No description provided for @guestDataChoiceCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get guestDataChoiceCancel;

  /// No description provided for @budgetSetupStartDay.
  ///
  /// In fr, this message translates to:
  /// **'Jour de début de période'**
  String get budgetSetupStartDay;

  /// No description provided for @budgetSetupStartDayMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Chaque période commence le {day} du mois, par exemple votre jour de paie.'**
  String budgetSetupStartDayMonthly(int day);

  /// No description provided for @budgetSetupStartDayWeekly.
  ///
  /// In fr, this message translates to:
  /// **'Chaque semaine commence ce jour-là.'**
  String get budgetSetupStartDayWeekly;

  /// No description provided for @budgetRenewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre budget est terminé'**
  String get budgetRenewTitle;

  /// No description provided for @budgetRenewMessage.
  ///
  /// In fr, this message translates to:
  /// **'« {name} » couvrait du {start} au {end}. Le relancer pour la période en cours, avec les mêmes montants ?'**
  String budgetRenewMessage(String name, String start, String end);

  /// No description provided for @budgetRenewAction.
  ///
  /// In fr, this message translates to:
  /// **'Renouveler pour cette période'**
  String get budgetRenewAction;

  /// No description provided for @budgetRenewed.
  ///
  /// In fr, this message translates to:
  /// **'Budget renouvelé'**
  String get budgetRenewed;

  /// No description provided for @budgetRenewFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de renouveler le budget. Veuillez réessayer.'**
  String get budgetRenewFailed;

  /// No description provided for @exportCsvTitle.
  ///
  /// In fr, this message translates to:
  /// **'Exporter les transactions (CSV)'**
  String get exportCsvTitle;

  /// No description provided for @exportCsvSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'À ouvrir dans un tableur ou à garder'**
  String get exportCsvSubtitle;

  /// No description provided for @exportCsvAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les transactions'**
  String get exportCsvAll;

  /// No description provided for @exportCsvDateRange.
  ///
  /// In fr, this message translates to:
  /// **'Choisir des dates…'**
  String get exportCsvDateRange;

  /// No description provided for @exportCsvEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction à exporter'**
  String get exportCsvEmpty;

  /// No description provided for @exportCsvFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'exporter. Veuillez réessayer.'**
  String get exportCsvFailed;

  /// No description provided for @csvDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get csvDate;

  /// No description provided for @csvType.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get csvType;

  /// No description provided for @csvCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get csvCategory;

  /// No description provided for @csvDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get csvDescription;

  /// No description provided for @csvAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get csvAmount;

  /// No description provided for @csvCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Devise'**
  String get csvCurrency;

  /// No description provided for @csvPaymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Mode de paiement'**
  String get csvPaymentMethod;

  /// No description provided for @csvMobileMoneyProvider.
  ///
  /// In fr, this message translates to:
  /// **'Opérateur Mobile Money'**
  String get csvMobileMoneyProvider;
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
