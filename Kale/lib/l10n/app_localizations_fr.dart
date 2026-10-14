// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Kalé';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonSkip => 'Passer';

  @override
  String get commonDone => 'Terminé';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get commonNoResults => 'Aucun résultat trouvé';

  @override
  String get commonSeeAll => 'Voir tout';

  @override
  String get commonOr => 'Ou';

  @override
  String get commonClear => 'Effacer';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonUser => 'Utilisateur';

  @override
  String get errorGeneric => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get errorNetwork =>
      'Pas de connexion Internet. Vérifiez votre réseau.';

  @override
  String get errorServer => 'Erreur serveur. Veuillez réessayer plus tard.';

  @override
  String get errorUnauthorized => 'Session expirée. Veuillez vous reconnecter.';

  @override
  String get errorValidation =>
      'Veuillez vérifier vos informations et réessayer.';

  @override
  String get errorTimeout => 'La requête a expiré. Veuillez réessayer.';

  @override
  String get authLogin => 'Se connecter';

  @override
  String get authRegister => 'S\'inscrire';

  @override
  String get authLogout => 'Se déconnecter';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authResetPassword => 'Réinitialiser le mot de passe';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authName => 'Nom complet';

  @override
  String get authLoginSubtitle =>
      'Bon retour ! Votre parcours financier continue ici.';

  @override
  String get authRegisterSubtitle =>
      'Prenez le contrôle de vos finances. Commencez votre parcours aujourd\'hui.';

  @override
  String get authForgotPasswordSubtitle =>
      'Entrez votre e-mail et nous vous enverrons un code pour réinitialiser votre mot de passe.';

  @override
  String get authNoAccount => 'Pas encore de compte ? ';

  @override
  String get authHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get authOtpTitle => 'Vérifiez votre e-mail';

  @override
  String authOtpSubtitle(String email) {
    return 'Entrez le code à 6 chiffres envoyé à $email';
  }

  @override
  String get authOtpResend => 'Vous n\'avez pas reçu le code ? Renvoyer';

  @override
  String get authLoginWithGoogle => 'Continuer avec Google';

  @override
  String get authLoginWithApple => 'Continuer avec Apple';

  @override
  String get authCreatePassword => 'Créer un mot de passe';

  @override
  String get authCreatePasswordSubtitle =>
      'Définissez un mot de passe sécurisé pour votre compte.';

  @override
  String get authTerms =>
      'En continuant, vous acceptez nos Conditions d\'utilisation et notre Politique de confidentialité.';

  @override
  String get authTermsPrefix => 'J\'accepte les ';

  @override
  String get authTermsOfService => 'Conditions d\'utilisation';

  @override
  String get authTermsAnd => ' et la ';

  @override
  String get authPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get authTryFirst => 'Essayer Kalé d\'abord';

  @override
  String get authTryFirstSubtitle => 'Explorez l\'application sans compte';

  @override
  String get anonymousSaveDataCta =>
      'Créez un compte pour sauvegarder vos données';

  @override
  String get anonymousBannerAction => 'S\'inscrire';

  @override
  String get authRegisterStep1Title => 'Créez votre compte';

  @override
  String get authRegisterStep1Subtitle => 'Entrez votre e-mail pour commencer';

  @override
  String get authRegisterStep2Subtitle =>
      'Complétez votre profil pour terminer l\'inscription';

  @override
  String get authRegisterContinueWithEmail => 'Continuer avec l\'e-mail';

  @override
  String get validationRequired => 'Ce champ est requis';

  @override
  String get validationEmail => 'Veuillez entrer une adresse e-mail valide';

  @override
  String get validationPasswordLength =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get validationPasswordMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get validationTermsRequired =>
      'Vous devez accepter les Conditions d\'utilisation et la Politique de confidentialité';

  @override
  String get passwordStrengthWeak => 'Faible';

  @override
  String get passwordStrengthFair => 'Moyen';

  @override
  String get passwordStrengthStrong => 'Fort';

  @override
  String get passwordStrengthVeryStrong => 'Très fort';

  @override
  String get onboardingTitle1 => 'Suivez Chaque Dépense';

  @override
  String get onboardingDesc1 =>
      'Enregistrez vos dépenses et revenus en quelques secondes. Voyez exactement où va votre argent avec des aperçus clairs et instantanés.';

  @override
  String get onboardingTitle2 => 'Budgétez Plus Malin';

  @override
  String get onboardingDesc2 =>
      'Définissez des budgets personnalisés pour chaque catégorie et soyez alerté avant de trop dépenser. Gardez le contrôle, sans effort.';

  @override
  String get onboardingTitle3 => 'Atteignez Vos Objectifs';

  @override
  String get onboardingDesc3 =>
      'Créez des objectifs d\'épargne, suivez votre progression et regardez votre argent grandir. Votre avenir financier commence ici.';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navBudget => 'Budget';

  @override
  String get navMore => 'Plus';

  @override
  String get homeTitle => 'Accueil';

  @override
  String homeGreeting(String name) {
    return 'Bonjour, $name !';
  }

  @override
  String get homeGreetingMorning => 'Bonjour';

  @override
  String get homeGreetingAfternoon => 'Bon après-midi';

  @override
  String get homeGreetingEvening => 'Bonsoir';

  @override
  String get dashboardCashFlow => 'Flux de trésorerie';

  @override
  String get dashboardIncome => 'Revenus';

  @override
  String get dashboardExpenses => 'Dépenses';

  @override
  String get dashboardCouldNotLoad => 'Impossible de charger le résumé';

  @override
  String get dashboardBudgetHealth => 'Santé du budget';

  @override
  String get dashboardViewBudget => 'Voir le budget';

  @override
  String get dashboardOnTrack => 'En bonne voie';

  @override
  String get dashboardGettingClose => 'Presque atteint';

  @override
  String get dashboardOverBudget => 'Budget dépassé';

  @override
  String get dashboardSpent => ' dépensé';

  @override
  String get dashboardSavingsGoals => 'Objectifs d\'épargne';

  @override
  String get dashboardViewAll => 'Voir tout';

  @override
  String get dashboardSavedOf => ' épargné sur ';

  @override
  String get dashboardRecentTransactions => 'Transactions récentes';

  @override
  String get dashboardNoTransactions => 'Aucune transaction';

  @override
  String get dashboardNoTransactionsSubtitle =>
      'Appuyez sur + pour ajouter votre première transaction';

  @override
  String get dashboardDaily => 'Quotidien';

  @override
  String get dashboardWeekly => 'Hebdomadaire';

  @override
  String get dashboardMonthly => 'Mensuel';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get transactionsAddTransaction => 'Ajouter une transaction';

  @override
  String get transactionsEditTransaction => 'Modifier la transaction';

  @override
  String get transactionsAll => 'Tout';

  @override
  String get transactionsIncome => 'Revenus';

  @override
  String get transactionsExpense => 'Dépense';

  @override
  String get transactionsNoTransactions => 'Aucune transaction';

  @override
  String get transactionsNoTransactionsSubtitle =>
      'Appuyez sur + pour ajouter votre première transaction';

  @override
  String get transactionsSaved => 'Enregistré';

  @override
  String get transactionsAmount => 'Montant';

  @override
  String get transactionsAmountHint => '0';

  @override
  String get transactionsAmountRequired => 'Entrez un montant';

  @override
  String get transactionsAmountInvalid => 'Entrez un montant valide';

  @override
  String get transactionsCategory => 'Catégorie';

  @override
  String get transactionsCategoryRequired =>
      'Veuillez sélectionner une catégorie';

  @override
  String get transactionsNoCategoriesAvailable => 'Aucune catégorie disponible';

  @override
  String get transactionsDate => 'Date';

  @override
  String get transactionsPaymentMethod => 'Mode de paiement';

  @override
  String get transactionsPaymentCash => 'Espèces';

  @override
  String get transactionsPaymentMobileMoney => 'Mobile Money';

  @override
  String get transactionsPaymentBank => 'Banque';

  @override
  String get transactionsPaymentCard => 'Carte';

  @override
  String get transactionsMobileMoneyProvider => 'Fournisseur Mobile Money';

  @override
  String get transactionsSelectProvider => 'Sélectionner un fournisseur';

  @override
  String get transactionsSelectProviderRequired =>
      'Veuillez sélectionner un fournisseur';

  @override
  String get transactionsDescription => 'Description (optionnel)';

  @override
  String get transactionsDescriptionHint =>
      'ex. Déjeuner au marché, Uber au travail';

  @override
  String get transactionsSaveTransaction => 'Enregistrer la transaction';

  @override
  String get transactionsUpdateTransaction => 'Mettre à jour la transaction';

  @override
  String get transactionsUncategorized => 'Non catégorisé';

  @override
  String get transactionsValidAmountRequired =>
      'Veuillez entrer un montant valide';

  @override
  String get transactionsSearchHint => 'Rechercher des transactions...';

  @override
  String get transactionsToday => 'Aujourd\'hui';

  @override
  String get transactionsYesterday => 'Hier';

  @override
  String get transactionsThisWeek => 'Cette semaine';

  @override
  String get transactionsEarlier => 'Plus ancien';

  @override
  String get transactionsDeleteConfirm => 'Supprimer cette transaction ?';

  @override
  String get transactionsDeleted => 'Transaction supprimée';

  @override
  String get dashboardQuickAdd => 'Ajouter';

  @override
  String get dashboardQuickBudget => 'Budget';

  @override
  String get dashboardQuickSavings => 'Épargne';

  @override
  String get dashboardIncomeVsExpenses => 'Revenus vs Dépenses';

  @override
  String get dashboardExpenseBreakdown => 'Répartition des dépenses';

  @override
  String get dashboardNoChartData => 'Aucune donnée de transaction';

  @override
  String get dashboardNoChartDataSubtitle =>
      'Ajoutez votre première transaction pour voir le graphique';

  @override
  String get budgetTitle => 'Budget';

  @override
  String get budgetNoActiveBudget => 'Aucun budget actif';

  @override
  String get budgetNoActiveBudgetSubtitle =>
      'Créez un budget pour commencer à suivre vos dépenses et garder le contrôle de vos finances.';

  @override
  String get budgetCreateBudget => 'Créer un budget';

  @override
  String get budgetEditBudget => 'Modifier le budget';

  @override
  String get budgetNewBudget => 'Nouveau budget';

  @override
  String get budgetTotalSpent => 'Total dépensé';

  @override
  String budgetOfBudget(String amount) {
    return 'sur $amount de budget';
  }

  @override
  String get budgetWeekly => 'Hebdomadaire';

  @override
  String get budgetBiWeekly => 'Bi-hebdomadaire';

  @override
  String get budgetMonthly => 'Mensuel';

  @override
  String get budgetStrategy5030 => '50/30/20';

  @override
  String get budgetStrategy8020 => '80/20';

  @override
  String get budgetStrategyEnvelope => 'Enveloppe';

  @override
  String get budgetStrategyCustom => 'Personnalisé';

  @override
  String get budgetSetupTitle => 'Créer un budget';

  @override
  String budgetSetupStep(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get budgetSetupChooseStrategy => 'Choisissez votre stratégie';

  @override
  String get budgetSetupChooseStrategySubtitle =>
      'Choisissez une méthode de budget adaptée à votre style de vie.';

  @override
  String get budgetSetupSetPeriod => 'Définissez votre période';

  @override
  String get budgetSetupSetPeriodSubtitle =>
      'À quelle fréquence souhaitez-vous budgéter ?';

  @override
  String get budgetSetupExpectedIncome => 'Revenu prévu (optionnel)';

  @override
  String get budgetSetupExpectedIncomeSubtitle =>
      'Entrez votre revenu prévu pour calculer automatiquement les allocations.';

  @override
  String get budgetSetupExpectedIncomeHint => '0,00';

  @override
  String get budgetSetupBiWeekly => 'Bi-hebdomadaire (Toutes les 2 semaines)';

  @override
  String get budgetSetupCustomize => 'Personnaliser les allocations';

  @override
  String get budgetSetupCustomizeSubtitle =>
      'Ajustez les montants pour chaque catégorie de dépenses.';

  @override
  String get budgetSetupReview => 'Vérifier votre budget';

  @override
  String get budgetSetupReviewSubtitle =>
      'Confirmez les détails ci-dessous pour créer votre budget.';

  @override
  String get budgetSetupStrategy => 'Stratégie';

  @override
  String get budgetSetupPeriod => 'Période';

  @override
  String get budgetSetupIncome => 'Revenu';

  @override
  String get budgetSetupTotalBudget => 'Budget total';

  @override
  String get budgetSetupCategoryBreakdown => 'Répartition par catégorie';

  @override
  String get budgetSetupContinue => 'Continuer';

  @override
  String get budgetStrategy5030Name => 'Règle 50/30/20';

  @override
  String get budgetStrategy5030Desc =>
      'Une approche équilibrée qui répartit votre revenu entre besoins, envies et épargne.';

  @override
  String get budgetStrategy5030Formula =>
      '50% Besoins - 30% Envies - 20% Épargne';

  @override
  String get budgetStrategy8020Name => '80/20 Entrepreneur';

  @override
  String get budgetStrategy8020Desc =>
      'Pour les entrepreneurs : réinvestissez 80% dans les essentiels et l\'entreprise, épargnez 20%.';

  @override
  String get budgetStrategy8020Formula =>
      '80% Essentiels & Business - 20% Épargne';

  @override
  String get budgetStrategyEnvelopeName => 'Système d\'enveloppes';

  @override
  String get budgetStrategyEnvelopeDesc =>
      'Attribuez des montants fixes à chaque catégorie. Quand l\'enveloppe est vide, arrêtez de dépenser.';

  @override
  String get budgetStrategyEnvelopeFormula => 'Montants fixes par catégorie';

  @override
  String get budgetStrategyCustomName => 'Personnalisé';

  @override
  String get budgetStrategyCustomDesc =>
      'Définissez vos propres pourcentages et montants pour un contrôle total de votre budget.';

  @override
  String get budgetStrategyCustomFormula => 'Vous décidez la répartition';

  @override
  String get categoryFoodGroceries => 'Alimentation & Courses';

  @override
  String get categoryRent => 'Loyer';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryUtilities => 'Services publics';

  @override
  String get categoryHealth => 'Santé';

  @override
  String get categoryEntertainment => 'Divertissement';

  @override
  String get categoryClothing => 'Vêtements';

  @override
  String get categoryAirtimeData => 'Crédit & Data';

  @override
  String get categoryPersonalCare => 'Soins personnels';

  @override
  String get categoryFamilySupport => 'Soutien familial';

  @override
  String get categorySavings => 'Épargne';

  @override
  String get categoryDebtRepayment => 'Remboursement de dettes';

  @override
  String get categoryReligiousGiving => 'Don religieux';

  @override
  String get categoryBusinessExpenses => 'Dépenses professionnelles';

  @override
  String get categoryMobileMoneyFees => 'Frais Mobile Money';

  @override
  String get categoryGroupNeeds => 'Besoins';

  @override
  String get categoryGroupWants => 'Envies';

  @override
  String get categoryGroupSavings => 'Épargne';

  @override
  String get categoryGroupEssentialsBusiness => 'Essentiels & Business';

  @override
  String get savingsGoalsTitle => 'Objectifs d\'épargne';

  @override
  String get savingsAddGoal => 'Ajouter un objectif';

  @override
  String get savingsNoGoals => 'Aucun objectif d\'épargne';

  @override
  String get savingsNoGoalsSubtitle =>
      'Pour quoi épargnez-vous ? Définissez un objectif pour commencer à suivre.';

  @override
  String get savingsCreateGoal => 'Créer un objectif';

  @override
  String get savingsNewGoal => 'Nouvel objectif d\'épargne';

  @override
  String get savingsGoalName => 'Nom de l\'objectif';

  @override
  String get savingsGoalNameHint => 'ex. Fonds d\'urgence, Nouvel ordinateur';

  @override
  String get savingsGoalNameRequired => 'Veuillez entrer un nom d\'objectif';

  @override
  String savingsTargetAmount(String currency) {
    return 'Montant cible ($currency)';
  }

  @override
  String get savingsTargetAmountRequired => 'Veuillez entrer un montant cible';

  @override
  String get savingsTargetAmountInvalid => 'Veuillez entrer un montant valide';

  @override
  String get savingsDescriptionOptional => 'Description (optionnel)';

  @override
  String get savingsDescriptionHint => 'Pour quoi épargnez-vous ?';

  @override
  String get savingsDeadlineOptional => 'Échéance (optionnel)';

  @override
  String get savingsNoDeadline => 'Aucune échéance définie';

  @override
  String get savingsGoalDetails => 'Détails de l\'objectif';

  @override
  String get savingsGoalNotFound => 'Objectif introuvable';

  @override
  String get savingsDeleteGoal => 'Supprimer l\'objectif';

  @override
  String get savingsAddMoney => 'Ajouter de l\'argent';

  @override
  String get savingsSaved => 'Épargné';

  @override
  String get savingsRemaining => 'Restant';

  @override
  String get savingsTarget => 'Cible';

  @override
  String get savingsDeadline => 'Échéance';

  @override
  String get savingsNotes => 'Notes';

  @override
  String get savingsContributionHistory => 'Historique des contributions';

  @override
  String get savingsNoContributions =>
      'Aucune contribution. Appuyez sur \"Ajouter de l\'argent\" pour commencer !';

  @override
  String savingsAddMoneyTo(String name) {
    return 'Ajouter de l\'argent à \"$name\"';
  }

  @override
  String get savingsNoteOptional => 'Note (optionnel)';

  @override
  String get savingsAddContribution => 'Ajouter une contribution';

  @override
  String savingsDeleteGoalConfirm(String name) {
    return 'Supprimer \"$name\" ? Cette action est irréversible.';
  }

  @override
  String get savingsSavedLabel => 'épargné';

  @override
  String get moreTitle => 'Plus';

  @override
  String get moreAccountSection => 'Compte';

  @override
  String get moreFeaturesSection => 'Fonctionnalités';

  @override
  String get moreSupportSection => 'Support';

  @override
  String get moreProfile => 'Profil';

  @override
  String get moreSettings => 'Paramètres';

  @override
  String get moreSavingsGoals => 'Objectifs d\'épargne';

  @override
  String get moreTontineGroups => 'Groupes de tontine';

  @override
  String get moreInsights => 'Analyses';

  @override
  String get moreHelpSupport => 'Aide & Support';

  @override
  String get moreRateApp => 'Noter l\'application';

  @override
  String get moreShareApp => 'Partager avec des amis';

  @override
  String get moreShareAppMessage =>
      'Découvrez Kalé - une application intelligente de budget et suivi des dépenses !';

  @override
  String get moreComingSoon => 'Bientôt disponible';

  @override
  String get moreComingSoonMessage => 'Bientôt disponible ! Restez connecté.';

  @override
  String get tontineGroupsTitle => 'Épargne communautaire';

  @override
  String get tontineGroupsDescription =>
      'Rejoignez ou créez un groupe de tontine pour épargner avec vos amis et votre famille. Mettez en commun vos cotisations et recevez la cagnotte à tour de rôle.';

  @override
  String get tontineGroupsHowItWorks => 'Comment ça marche';

  @override
  String get tontineGroupsStep1Title => 'Créez ou rejoignez un groupe';

  @override
  String get tontineGroupsStep1Desc =>
      'Lancez un nouveau groupe de tontine ou rejoignez-en un existant grâce à une invitation.';

  @override
  String get tontineGroupsStep2Title => 'Cotisez régulièrement';

  @override
  String get tontineGroupsStep2Desc =>
      'Chaque membre verse un montant fixe selon un calendrier défini.';

  @override
  String get tontineGroupsStep3Title => 'Recevez la cagnotte';

  @override
  String get tontineGroupsStep3Desc =>
      'Les membres reçoivent à tour de rôle la totalité de la somme mise en commun.';

  @override
  String get tontineGroupsEmpty => 'Aucun groupe pour l\'instant';

  @override
  String get tontineGroupsEmptySubtitle =>
      'Créez votre premier groupe de tontine et commencez à épargner ensemble.';

  @override
  String get tontineGroupsCreateGroup => 'Créer un groupe';

  @override
  String get helpFaqTitle => 'Questions fréquentes';

  @override
  String get helpFaq1Question => 'Comment ajouter une transaction ?';

  @override
  String get helpFaq1Answer =>
      'Appuyez sur le bouton + de l\'écran d\'accueil pour ajouter un revenu ou une dépense. Renseignez le montant, la catégorie et des notes facultatives.';

  @override
  String get helpFaq2Question => 'Comment fonctionnent les budgets ?';

  @override
  String get helpFaq2Answer =>
      'Allez dans l\'onglet Budget pour définir des limites de dépenses mensuelles par catégorie. Kalé suit vos dépenses et vous prévient lorsque vous approchez de votre limite.';

  @override
  String get helpFaq3Question => 'Puis-je définir des objectifs d\'épargne ?';

  @override
  String get helpFaq3Answer =>
      'Oui ! Allez dans Plus > Objectifs d\'épargne pour créer des objectifs comme des vacances, un fonds d\'urgence ou un gros achat. Suivez votre progression au fil du temps.';

  @override
  String get helpFaq4Question => 'Mes données sont-elles sécurisées ?';

  @override
  String get helpFaq4Answer =>
      'Vos données sont chiffrées et stockées en toute sécurité. Nous ne partageons jamais vos informations financières avec des tiers. Vous pouvez effacer les données locales à tout moment depuis les Paramètres.';

  @override
  String get helpContactTitle => 'Nous contacter';

  @override
  String get helpContactEmail => 'Assistance par e-mail';

  @override
  String get helpContactChat => 'Chat en direct';

  @override
  String get helpContactChatSubtitle =>
      'Disponible du lundi au vendredi, de 9 h à 17 h';

  @override
  String get helpLegalTitle => 'Mentions légales';

  @override
  String get rateAppTitle => 'Vous aimez Kalé ?';

  @override
  String get rateAppSubtitle =>
      'Votre avis nous aide à nous améliorer. Dites-nous ce que vous en pensez !';

  @override
  String get rateAppSubmit => 'Envoyer la note';

  @override
  String get rateAppLabel1 => 'À améliorer';

  @override
  String get rateAppLabel2 => 'Pourrait être mieux';

  @override
  String get rateAppLabel3 => 'Correct';

  @override
  String get rateAppLabel4 => 'Super appli !';

  @override
  String get rateAppLabel5 => 'J\'adore !';

  @override
  String get rateAppThankYou => 'Merci !';

  @override
  String get rateAppThankYouMessage =>
      'Nous apprécions votre avis. Il nous aide à rendre Kalé encore meilleure pour vous.';

  @override
  String get shareAppTitle => 'Partager Kalé';

  @override
  String get shareAppDescription =>
      'Aidez vos amis et votre famille à prendre le contrôle de leurs finances avec Kalé.';

  @override
  String get shareAppShareVia => 'PARTAGER VIA';

  @override
  String get shareAppCopyLink => 'Copier le lien de téléchargement';

  @override
  String get shareAppCopyMessage => 'Copier le message de partage';

  @override
  String get shareAppLinkCopied => 'Lien copié dans le presse-papiers';

  @override
  String get shareAppMessageCopied => 'Message copié dans le presse-papiers';

  @override
  String get onboardingTitle4 => 'Personnalisez votre expérience';

  @override
  String get onboardingDesc4 =>
      'Choisissez vos préférences pour tirer le meilleur parti de Kalé.';

  @override
  String get onboardingCurrency => 'Devise';

  @override
  String get onboardingLanguage => 'Langue';

  @override
  String get onboardingGoal => 'Quel est votre objectif principal ?';

  @override
  String get onboardingGoalTrackSpending => 'Suivre mes dépenses';

  @override
  String get onboardingGoalSaveMore => 'Épargner plus';

  @override
  String get onboardingGoalManageBudgets => 'Gérer mes budgets';

  @override
  String get coachMarkFab =>
      'Appuyez ici pour ajouter votre première transaction';

  @override
  String get coachMarkBudget => 'Configurez votre budget mensuel';

  @override
  String get coachMarkPeriod =>
      'Basculez entre les vues quotidienne, hebdomadaire et mensuelle';

  @override
  String get coachMarkGotIt => 'Compris';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEditProfile => 'Modifier le profil';

  @override
  String get profileChangePassword => 'Changer le mot de passe';

  @override
  String get profileLogout => 'Déconnexion';

  @override
  String get profileAchievements => 'Accomplissements';

  @override
  String profileLevel(String level) {
    return 'Niveau : $level';
  }

  @override
  String profileBadgesUnlocked(int count, int total) {
    return '$count sur $total badges débloqués';
  }

  @override
  String get achievementFirstTransaction => 'Première transaction';

  @override
  String get achievementStreak7 => 'Série de 7 jours';

  @override
  String get achievementStreak30 => 'Série de 30 jours';

  @override
  String get achievementFirstBudget => 'Premier budget';

  @override
  String get achievementUnderBudget => 'Sous le budget';

  @override
  String get achievementFirstGoalCompleted => 'Objectif atteint';

  @override
  String get achievementTransactions100 => '100 transactions';

  @override
  String get levelBeginner => 'Débutant';

  @override
  String get levelExplorer => 'Explorateur';

  @override
  String get levelPro => 'Pro';

  @override
  String get levelMaster => 'Maître';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageEn => 'Anglais';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageSystem => 'Langue de l\'appareil';

  @override
  String get settingsAbout => 'À propos';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsTerms => 'Conditions d\'utilisation';

  @override
  String get settingsPrivacy => 'Politique de confidentialité';

  @override
  String get settingsCurrency => 'Devise';

  @override
  String get settingsSelectCurrency => 'Sélectionner la devise';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPushNotifications => 'Notifications push';

  @override
  String get settingsEnabled => 'Activé';

  @override
  String get settingsDisabled => 'Désactivé';

  @override
  String get settingsDailyReminder => 'Rappel quotidien';

  @override
  String get settingsDailyReminderSubtitle =>
      'Me rappeler de saisir mes transactions';

  @override
  String get settingsData => 'Données';

  @override
  String get settingsClearLocalData => 'Effacer les données locales';

  @override
  String get settingsClearLocalDataSubtitle =>
      'Supprimer toutes les données en cache de cet appareil';

  @override
  String get settingsClearLocalDataConfirm =>
      'Cela supprimera toutes les données en cache de cet appareil. Votre compte et vos données synchronisées sur le serveur ne seront pas affectés.\n\nÊtes-vous sûr ?';

  @override
  String get settingsClearLocalDataSuccess => 'Données locales effacées';

  @override
  String get legalLastUpdated => 'Dernière mise à jour : 20 février 2026';

  @override
  String get legalContactFooter =>
      'Si vous avez des questions, contactez-nous à support@kale.app';

  @override
  String get legalTosTitle => 'Conditions d\'utilisation';

  @override
  String get legalTosIntroHeading => '1. Introduction';

  @override
  String get legalTosIntroBody =>
      'Bienvenue sur Kalé. Ces Conditions d\'utilisation régissent votre utilisation de l\'application mobile Kalé et des services associés. En créant un compte ou en utilisant Kalé, vous acceptez d\'être lié par ces conditions. Si vous n\'êtes pas d\'accord, veuillez ne pas utiliser l\'application.';

  @override
  String get legalTosAccountHeading => '2. Inscription au compte';

  @override
  String get legalTosAccountBody =>
      'Pour utiliser Kalé, vous devez créer un compte avec des informations exactes et complètes. Vous êtes responsable du maintien de la confidentialité de vos identifiants de connexion et de toute activité sous votre compte. Vous devez avoir au moins 13 ans pour créer un compte. Si vous avez moins de 18 ans, vous confirmez avoir le consentement de votre parent ou tuteur.';

  @override
  String get legalTosServicesHeading => '3. Services fournis';

  @override
  String get legalTosServicesBody =>
      'Kalé fournit des outils de gestion des finances personnelles comprenant le suivi des dépenses et des revenus, la création et le suivi de budgets, la gestion des objectifs d\'épargne et des analyses financières. Ces outils sont conçus pour vous aider à organiser et comprendre vos finances personnelles.';

  @override
  String get legalTosResponsibilitiesHeading =>
      '4. Responsabilités de l\'utilisateur';

  @override
  String get legalTosResponsibilitiesBody =>
      'Vous êtes seul responsable de l\'exactitude des données financières que vous saisissez dans Kalé. Kalé est un outil de suivi et d\'organisation et ne fournit pas de conseils financiers, d\'investissement, fiscaux ou juridiques professionnels. Vous acceptez d\'utiliser l\'application conformément à toutes les lois et réglementations applicables.';

  @override
  String get legalTosFinancialDataHeading => '5. Données financières';

  @override
  String get legalTosFinancialDataBody =>
      'Kalé n\'est pas une banque, un processeur de paiement ou une institution financière. Nous ne détenons pas, ne transférons pas et n\'avons pas la garde de vos fonds. Toutes les données financières dans Kalé sont des informations saisies par l\'utilisateur à des fins de suivi personnel uniquement. Nous ne vérifions pas l\'exactitude des transactions, soldes ou autres informations financières que vous saisissez.';

  @override
  String get legalTosIpHeading => '6. Propriété intellectuelle';

  @override
  String get legalTosIpBody =>
      'L\'application Kalé, y compris sa conception, son code, ses fonctionnalités et sa marque, est la propriété de Kalé et protégée par les lois sur la propriété intellectuelle. Vous conservez la pleine propriété des données personnelles et des informations financières que vous saisissez dans l\'application. Vous accordez à Kalé une licence limitée pour traiter vos données uniquement pour fournir et améliorer les services.';

  @override
  String get legalTosLiabilityHeading => '7. Limitation de responsabilité';

  @override
  String get legalTosLiabilityBody =>
      'Kalé est fourni \"en l\'état\". Nous ne sommes pas responsables des décisions financières que vous prenez sur la base des informations affichées dans l\'application. Nous ne garantissons pas l\'exactitude des calculs, résumés ou analyses dérivées de vos données. Dans la mesure maximale permise par la loi, Kalé ne sera pas responsable des dommages indirects, accessoires ou consécutifs.';

  @override
  String get legalTosTerminationHeading => '8. Résiliation';

  @override
  String get legalTosTerminationBody =>
      'Vous pouvez supprimer votre compte à tout moment via les paramètres de l\'application. Nous pouvons suspendre ou résilier votre compte si vous violez ces conditions. À la résiliation, vos données seront supprimées de nos serveurs dans les 30 jours, sauf si la conservation est requise par la loi.';

  @override
  String get legalTosChangesHeading => '9. Modifications de ces conditions';

  @override
  String get legalTosChangesBody =>
      'Nous pouvons mettre à jour ces Conditions d\'utilisation de temps en temps. Nous vous informerons des modifications importantes via l\'application ou par e-mail. Votre utilisation continue de Kalé après la publication des modifications constitue votre acceptation des conditions mises à jour.';

  @override
  String get legalTosContactHeading => '10. Nous contacter';

  @override
  String get legalTosContactBody =>
      'Si vous avez des questions sur ces Conditions d\'utilisation, veuillez nous contacter à support@kale.app.';

  @override
  String get legalPrivacyTitle => 'Politique de confidentialité';

  @override
  String get legalPrivacyIntroHeading => '1. Introduction';

  @override
  String get legalPrivacyIntroBody =>
      'Votre vie privée est importante pour nous. Cette Politique de confidentialité explique comment Kalé collecte, utilise, stocke et protège vos informations personnelles et financières. Nous nous engageons à traiter vos données avec transparence et soin.';

  @override
  String get legalPrivacyCollectionHeading =>
      '2. Informations que nous collectons';

  @override
  String get legalPrivacyCollectionBody =>
      'Nous collectons les types d\'informations suivants :\n\nInformations de compte : Votre nom, adresse e-mail et identifiants d\'authentification lors de la création de votre compte.\n\nDonnées financières : Enregistrements de transactions, configurations de budget, objectifs d\'épargne et préférences de catégories que vous saisissez dans l\'application.\n\nDonnées d\'utilisation : Analyses anonymes de la façon dont vous interagissez avec l\'application, y compris les vues d\'écran et l\'utilisation des fonctionnalités, pour nous aider à améliorer l\'expérience.\n\nInformations sur l\'appareil : Type d\'appareil, version du système d\'exploitation et version de l\'application à des fins de compatibilité et de dépannage.';

  @override
  String get legalPrivacyUsageHeading =>
      '3. Comment nous utilisons vos données';

  @override
  String get legalPrivacyUsageBody =>
      'Nous utilisons vos informations pour :\n\n- Fournir, maintenir et améliorer les fonctionnalités et services de Kalé\n- Générer des résumés financiers personnalisés, des graphiques et des analyses\n- Vous envoyer des notifications telles que des alertes de budget et des rappels quotidiens (lorsqu\'ils sont activés)\n- Authentifier votre identité et sécuriser votre compte\n- Analyser les tendances d\'utilisation agrégées pour améliorer l\'expérience de l\'application';

  @override
  String get legalPrivacyStorageHeading =>
      '4. Stockage et sécurité des données';

  @override
  String get legalPrivacyStorageBody =>
      'Vos données sont stockées de manière sécurisée en utilisant des pratiques conformes aux normes de l\'industrie. Toutes les données sont chiffrées en transit via TLS et au repos sur nos serveurs. Nous utilisons Supabase comme infrastructure backend, qui fournit une sécurité de niveau entreprise, des contrôles d\'accès et une isolation des données. Nous révisons régulièrement nos pratiques de sécurité et limitons l\'accès à vos données au personnel autorisé uniquement.';

  @override
  String get legalPrivacyThirdPartyHeading => '5. Services tiers';

  @override
  String get legalPrivacyThirdPartyBody =>
      'Kalé s\'intègre aux services tiers suivants :\n\n- Google Sign-In et Apple Sign-In pour l\'authentification\n- Services d\'analyse pour le suivi anonyme de l\'utilisation\n- Services de signalement de crash pour identifier et corriger les problèmes de l\'application\n\nNous ne vendons pas, ne louons pas et ne partageons pas vos données personnelles ou financières avec des tiers à des fins de marketing. Les services tiers ne reçoivent que les données minimales nécessaires pour remplir leur fonction.';

  @override
  String get legalPrivacyRightsHeading => '6. Vos droits';

  @override
  String get legalPrivacyRightsBody =>
      'Vous avez le droit de :\n\n- Accéder aux données personnelles que nous détenons sur vous\n- Corriger les informations inexactes de votre compte\n- Supprimer votre compte et toutes les données associées\n- Exporter vos données financières\n- Restreindre ou vous opposer à certains traitements de vos données\n\nPour exercer l\'un de ces droits, contactez-nous à privacy@kale.app ou utilisez les fonctionnalités de gestion de compte dans l\'application.';

  @override
  String get legalPrivacyRetentionHeading => '7. Conservation des données';

  @override
  String get legalPrivacyRetentionBody =>
      'Nous conservons vos données aussi longtemps que votre compte est actif. Si vous supprimez votre compte, nous supprimerons vos données personnelles et financières de nos serveurs dans les 30 jours. Certaines données anonymisées et agrégées peuvent être conservées à des fins d\'analyse. Nous pouvons également conserver certaines données comme requis par la loi.';

  @override
  String get legalPrivacyChildrenHeading => '8. Vie privée des enfants';

  @override
  String get legalPrivacyChildrenBody =>
      'Kalé ne s\'adresse pas aux enfants de moins de 13 ans. Nous ne collectons pas sciemment d\'informations personnelles auprès d\'enfants de moins de 13 ans. Si nous apprenons que nous avons collecté des données d\'un enfant de moins de 13 ans sans le consentement parental, nous prendrons des mesures pour supprimer ces informations rapidement.';

  @override
  String get legalPrivacyChangesHeading =>
      '9. Modifications de cette politique';

  @override
  String get legalPrivacyChangesBody =>
      'Nous pouvons mettre à jour cette Politique de confidentialité de temps en temps. Nous vous informerons des modifications importantes via une notification dans l\'application ou par e-mail. Nous vous encourageons à consulter cette politique périodiquement. Votre utilisation continue de Kalé après la publication des modifications constitue votre acceptation de la politique mise à jour.';

  @override
  String get legalPrivacyContactHeading => '10. Nous contacter';

  @override
  String get legalPrivacyContactBody =>
      'Si vous avez des questions sur cette Politique de confidentialité ou sur la façon dont vos données sont traitées, veuillez nous contacter à privacy@kale.app.';

  @override
  String get offlineBanner => 'Vous êtes hors ligne';

  @override
  String get emptyStateTitle => 'Rien ici pour le moment';

  @override
  String get emptyStateSubtitle => 'Revenez plus tard pour les mises à jour.';

  @override
  String get budgetEmptyRecommendation =>
      'Nous recommandons la règle 50/30/20 pour commencer';

  @override
  String get budgetStartWith5030 => 'Commencer avec 50/30/20';

  @override
  String get budgetCustomBudget => 'Budget personnalise';

  @override
  String get budgetEmptyQuickTip => 'Cela ne prend qu\'une minute à configurer';

  @override
  String get savingsEmptyTemplateTitle =>
      'Objectifs populaires pour vous inspirer';

  @override
  String get savingsTemplateEmergency => 'Fonds d\'urgence';

  @override
  String get savingsTemplateVacation => 'Vacances';

  @override
  String get savingsTemplateNewPhone => 'Nouveau téléphone';

  @override
  String get savingsEmptyOrCreate => 'Ou créez votre propre objectif';

  @override
  String get transactionsEmptyQuickTip => 'Cela ne prend que 10 secondes';

  @override
  String get dashboardEmptyTitle => 'Bienvenue sur Kalé !';

  @override
  String get dashboardEmptySubtitle =>
      'Complétez ces étapes pour tirer le meilleur parti de vos finances :';

  @override
  String get dashboardEmptyStep1 => 'Ajoutez votre première transaction';

  @override
  String get dashboardEmptyStep2 => 'Configurez un budget';

  @override
  String get dashboardEmptyStep3 => 'Créez un objectif d\'épargne';

  @override
  String dashboardStreak(int count) {
    return 'Série de $count jours';
  }

  @override
  String get dashboardStreakStart => 'Commencez votre série !';

  @override
  String get dashboardFinancialHealth => 'Santé financière';

  @override
  String get dashboardHealthExcellent => 'Excellent';

  @override
  String get dashboardHealthGood => 'Bien';

  @override
  String get dashboardHealthFair => 'Moyen';

  @override
  String get dashboardHealthNeedsWork => 'À améliorer';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'Aucune notification';

  @override
  String get notificationsEmptySubtitle =>
      'Vous êtes à jour ! Les notifications concernant vos budgets, épargnes et rappels apparaîtront ici.';

  @override
  String get baseCurrencyStepTitle => 'Choisissez votre devise';

  @override
  String get baseCurrencyStepDescription =>
      'Tous les montants dans Kalé sont enregistrés dans cette devise. Vous pourrez la changer plus tard.';

  @override
  String get baseCurrencyLabel => 'Devise de base';

  @override
  String get baseCurrencyRelabelTitle => 'Changer la devise de base ?';

  @override
  String baseCurrencyRelabelMessage(String currency) {
    return 'Vos transactions existantes gardent les mêmes chiffres et seront affichées en $currency. Aucune conversion n\'est faite.';
  }

  @override
  String get baseCurrencyRelabelConfirm => 'Changer quand même';

  @override
  String get baseCurrencyChangeFailed =>
      'Impossible de changer la devise. Veuillez réessayer.';

  @override
  String backupStuck(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count modifications non sauvegardées',
      one: '1 modification non sauvegardée',
    );
    return '$_temp0';
  }

  @override
  String backupOfflinePending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hors ligne · $count modifications en attente',
      one: 'Hors ligne · 1 modification en attente',
    );
    return '$_temp0';
  }

  @override
  String get backupSyncing => 'Sauvegarde en cours…';

  @override
  String get settingsBackup => 'Sauvegarde';

  @override
  String get settingsBackupUpToDate =>
      'Toutes les modifications sont sauvegardées';

  @override
  String settingsBackupPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count modifications en attente de sauvegarde',
      one: '1 modification en attente de sauvegarde',
    );
    return '$_temp0';
  }

  @override
  String settingsBackupLast(String date) {
    return 'Dernière sauvegarde : $date';
  }

  @override
  String get settingsBackupNever => 'Pas encore sauvegardé';

  @override
  String get logoutUnsavedTitle =>
      'Se déconnecter et perdre des modifications ?';

  @override
  String logoutUnsavedMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count modifications ne sont pas encore sauvegardées. Si vous vous déconnectez maintenant, elles seront définitivement perdues.',
      one:
          '1 modification n\'est pas encore sauvegardée. Si vous vous déconnectez maintenant, elle sera définitivement perdue.',
    );
    return '$_temp0';
  }

  @override
  String get logoutUnsavedConfirm => 'Se déconnecter quand même';

  @override
  String get logoutUnsavedCancel => 'Rester connecté';

  @override
  String get logoutFailed =>
      'Impossible de vérifier votre sauvegarde. Veuillez réessayer.';

  @override
  String restoreInProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restauration de vos données… $count éléments',
      one: 'Restauration de vos données… 1 élément',
      zero: 'Restauration de vos données…',
    );
    return '$_temp0';
  }

  @override
  String get refreshOffline =>
      'Vous êtes hors ligne. Tirez pour actualiser une fois connecté.';

  @override
  String get refreshFailed =>
      'Impossible d\'actualiser depuis votre sauvegarde. Veuillez réessayer.';

  @override
  String get saveDataTitle => 'Sauvegarder vos données';

  @override
  String get saveDataSubtitle =>
      'Créez un compte pour garder tout ce que vous avez saisi, sur ce téléphone et sur les autres.';

  @override
  String get saveDataWithEmail => 'Continuer avec l\'e-mail';

  @override
  String saveDataCodeSent(String email) {
    return 'Saisissez le code à 6 chiffres envoyé à $email.';
  }

  @override
  String get saveDataVerify => 'Vérifier';

  @override
  String get saveDataDone => 'Vos données sont sauvegardées sur votre compte.';

  @override
  String get guestDataChoiceTitle => 'Ce compte existe déjà';

  @override
  String guestDataChoiceMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Vous avez $count saisies sur ce téléphone. Les ajouter à ce compte, ou les supprimer ?',
      one:
          'Vous avez 1 saisie sur ce téléphone. L\'ajouter à ce compte, ou la supprimer ?',
      zero: 'Vous n\'avez encore aucune saisie sur ce téléphone.',
    );
    return '$_temp0';
  }

  @override
  String guestDataChoiceAdd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter mes $count saisies à ce compte',
      one: 'Ajouter ma saisie à ce compte',
      zero: 'Se connecter',
    );
    return '$_temp0';
  }

  @override
  String get guestDataChoiceDiscard => 'Les supprimer et se connecter';

  @override
  String get guestDataChoiceCancel => 'Annuler';

  @override
  String get budgetSetupStartDay => 'Jour de début de période';

  @override
  String budgetSetupStartDayMonthly(int day) {
    return 'Chaque période commence le $day du mois, par exemple votre jour de paie.';
  }

  @override
  String get budgetSetupStartDayWeekly => 'Chaque semaine commence ce jour-là.';

  @override
  String get budgetRenewTitle => 'Votre budget est terminé';

  @override
  String budgetRenewMessage(String name, String start, String end) {
    return '« $name » couvrait du $start au $end. Le relancer pour la période en cours, avec les mêmes montants ?';
  }

  @override
  String get budgetRenewAction => 'Renouveler pour cette période';

  @override
  String get budgetRenewed => 'Budget renouvelé';

  @override
  String get budgetRenewFailed =>
      'Impossible de renouveler le budget. Veuillez réessayer.';

  @override
  String notifBudgetAlertTitle(String category) {
    return 'Alerte budget : $category';
  }

  @override
  String notifBudgetAlert80Body(String amount, String category) {
    return 'Vous avez utilisé 80 % de votre budget de $amount pour $category.';
  }

  @override
  String notifBudgetAlert100Body(String amount, String category) {
    return 'Vous avez utilisé tout votre budget de $amount pour $category.';
  }

  @override
  String notifSavingsMilestoneTitle(String goal) {
    return 'Étape d\'épargne : $goal';
  }

  @override
  String notifSavingsMilestoneBody(String goal, int percent) {
    return '« $goal » est financé à $percent %. Continuez !';
  }

  @override
  String notifSavingsGoalReachedTitle(String goal) {
    return 'Objectif atteint : $goal';
  }

  @override
  String notifSavingsGoalReachedBody(String goal) {
    return 'Félicitations ! Vous avez tout épargné pour « $goal ».';
  }

  @override
  String get notifDailyReminderTitle => 'Suivez vos dépenses';

  @override
  String get notifDailyReminderBody =>
      'N\'oubliez pas de noter les transactions du jour.';

  @override
  String get exportCsvTitle => 'Exporter les transactions (CSV)';

  @override
  String get exportCsvSubtitle => 'À ouvrir dans un tableur ou à garder';

  @override
  String get exportCsvAll => 'Toutes les transactions';

  @override
  String get exportCsvDateRange => 'Choisir des dates…';

  @override
  String get exportCsvEmpty => 'Aucune transaction à exporter';

  @override
  String get exportCsvFailed => 'Impossible d\'exporter. Veuillez réessayer.';

  @override
  String get csvDate => 'Date';

  @override
  String get csvType => 'Type';

  @override
  String get csvCategory => 'Catégorie';

  @override
  String get csvDescription => 'Description';

  @override
  String get csvAmount => 'Montant';

  @override
  String get csvCurrency => 'Devise';

  @override
  String get csvPaymentMethod => 'Mode de paiement';

  @override
  String get csvMobileMoneyProvider => 'Opérateur Mobile Money';
}
