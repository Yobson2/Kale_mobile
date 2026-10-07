// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Kale';

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
  String get commonRetry => 'Reessayer';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonSkip => 'Passer';

  @override
  String get commonDone => 'Termine';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get commonNoResults => 'Aucun resultat trouve';

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
  String get errorGeneric => 'Une erreur est survenue. Veuillez reessayer.';

  @override
  String get errorNetwork =>
      'Pas de connexion Internet. Verifiez votre reseau.';

  @override
  String get errorServer => 'Erreur serveur. Veuillez reessayer plus tard.';

  @override
  String get errorUnauthorized => 'Session expiree. Veuillez vous reconnecter.';

  @override
  String get errorValidation =>
      'Veuillez verifier vos informations et reessayer.';

  @override
  String get errorTimeout => 'La requete a expire. Veuillez reessayer.';

  @override
  String get authLogin => 'Se connecter';

  @override
  String get authRegister => 'S\'inscrire';

  @override
  String get authLogout => 'Se deconnecter';

  @override
  String get authForgotPassword => 'Mot de passe oublie ?';

  @override
  String get authResetPassword => 'Reinitialiser le mot de passe';

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
      'Prenez le controle de vos finances. Commencez votre parcours aujourd\'hui.';

  @override
  String get authForgotPasswordSubtitle =>
      'Entrez votre e-mail et nous vous enverrons un code pour reinitialiser votre mot de passe.';

  @override
  String get authNoAccount => 'Pas encore de compte ? ';

  @override
  String get authHaveAccount => 'Vous avez deja un compte ? ';

  @override
  String get authOtpTitle => 'Verifiez votre e-mail';

  @override
  String authOtpSubtitle(String email) {
    return 'Entrez le code a 6 chiffres envoye a $email';
  }

  @override
  String get authOtpResend => 'Vous n\'avez pas recu le code ? Renvoyer';

  @override
  String get authLoginWithGoogle => 'Continuer avec Google';

  @override
  String get authLoginWithApple => 'Continuer avec Apple';

  @override
  String get authCreatePassword => 'Creer un mot de passe';

  @override
  String get authCreatePasswordSubtitle =>
      'Definissez un mot de passe securise pour votre compte.';

  @override
  String get authTerms =>
      'En continuant, vous acceptez nos Conditions d\'utilisation et notre Politique de confidentialite.';

  @override
  String get authTermsPrefix => 'J\'accepte les ';

  @override
  String get authTermsOfService => 'Conditions d\'utilisation';

  @override
  String get authTermsAnd => ' et la ';

  @override
  String get authPrivacyPolicy => 'Politique de confidentialite';

  @override
  String get authTryFirst => 'Essayer Kale d\'abord';

  @override
  String get authTryFirstSubtitle => 'Explorez l\'application sans compte';

  @override
  String get guestBannerMessage =>
      'Creez un compte pour synchroniser vos donnees';

  @override
  String get guestBannerAction => 'S\'inscrire';

  @override
  String get authRegisterStep1Title => 'Creez votre compte';

  @override
  String get authRegisterStep1Subtitle => 'Entrez votre e-mail pour commencer';

  @override
  String get authRegisterStep2Subtitle =>
      'Completez votre profil pour terminer l\'inscription';

  @override
  String get authRegisterContinueWithEmail => 'Continuer avec l\'e-mail';

  @override
  String get validationRequired => 'Ce champ est requis';

  @override
  String get validationEmail => 'Veuillez entrer une adresse e-mail valide';

  @override
  String get validationPasswordLength =>
      'Le mot de passe doit contenir au moins 8 caracteres';

  @override
  String get validationPasswordMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get validationTermsRequired =>
      'Vous devez accepter les Conditions d\'utilisation et la Politique de confidentialite';

  @override
  String get passwordStrengthWeak => 'Faible';

  @override
  String get passwordStrengthFair => 'Moyen';

  @override
  String get passwordStrengthStrong => 'Fort';

  @override
  String get passwordStrengthVeryStrong => 'Tres fort';

  @override
  String get onboardingTitle1 => 'Suivez Chaque Depense';

  @override
  String get onboardingDesc1 =>
      'Enregistrez vos depenses et revenus en quelques secondes. Voyez exactement ou va votre argent avec des apercus clairs et instantanes.';

  @override
  String get onboardingTitle2 => 'Budgetez Plus Malin';

  @override
  String get onboardingDesc2 =>
      'Definissez des budgets personnalises pour chaque categorie et soyez alerte avant de trop depenser. Gardez le controle, sans effort.';

  @override
  String get onboardingTitle3 => 'Atteignez Vos Objectifs';

  @override
  String get onboardingDesc3 =>
      'Creez des objectifs d\'epargne, suivez votre progression et regardez votre argent grandir. Votre avenir financier commence ici.';

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
  String get homeGreetingAfternoon => 'Bon apres-midi';

  @override
  String get homeGreetingEvening => 'Bonsoir';

  @override
  String get dashboardCashFlow => 'Flux de tresorerie';

  @override
  String get dashboardIncome => 'Revenus';

  @override
  String get dashboardExpenses => 'Depenses';

  @override
  String get dashboardCouldNotLoad => 'Impossible de charger le resume';

  @override
  String get dashboardBudgetHealth => 'Sante du budget';

  @override
  String get dashboardViewBudget => 'Voir le budget';

  @override
  String get dashboardOnTrack => 'En bonne voie';

  @override
  String get dashboardGettingClose => 'Presque atteint';

  @override
  String get dashboardOverBudget => 'Budget depasse';

  @override
  String get dashboardSpent => ' depense';

  @override
  String get dashboardSavingsGoals => 'Objectifs d\'epargne';

  @override
  String get dashboardViewAll => 'Voir tout';

  @override
  String get dashboardSavedOf => ' epargne sur ';

  @override
  String get dashboardRecentTransactions => 'Transactions recentes';

  @override
  String get dashboardNoTransactions => 'Aucune transaction';

  @override
  String get dashboardNoTransactionsSubtitle =>
      'Appuyez sur + pour ajouter votre premiere transaction';

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
  String get transactionsExpense => 'Depense';

  @override
  String get transactionsNoTransactions => 'Aucune transaction';

  @override
  String get transactionsNoTransactionsSubtitle =>
      'Appuyez sur + pour ajouter votre premiere transaction';

  @override
  String get transactionsSaved => 'Enregistre';

  @override
  String get transactionsAmount => 'Montant';

  @override
  String get transactionsAmountHint => '0';

  @override
  String get transactionsAmountRequired => 'Entrez un montant';

  @override
  String get transactionsAmountInvalid => 'Entrez un montant valide';

  @override
  String get transactionsCategory => 'Categorie';

  @override
  String get transactionsCategoryRequired =>
      'Veuillez selectionner une categorie';

  @override
  String get transactionsNoCategoriesAvailable => 'Aucune categorie disponible';

  @override
  String get transactionsDate => 'Date';

  @override
  String get transactionsPaymentMethod => 'Mode de paiement';

  @override
  String get transactionsPaymentCash => 'Especes';

  @override
  String get transactionsPaymentMobileMoney => 'Mobile Money';

  @override
  String get transactionsPaymentBank => 'Banque';

  @override
  String get transactionsPaymentCard => 'Carte';

  @override
  String get transactionsMobileMoneyProvider => 'Fournisseur Mobile Money';

  @override
  String get transactionsSelectProvider => 'Selectionner un fournisseur';

  @override
  String get transactionsSelectProviderRequired =>
      'Veuillez selectionner un fournisseur';

  @override
  String get transactionsDescription => 'Description (optionnel)';

  @override
  String get transactionsDescriptionHint =>
      'ex. Dejeuner au marche, Uber au travail';

  @override
  String get transactionsSaveTransaction => 'Enregistrer la transaction';

  @override
  String get transactionsUpdateTransaction => 'Mettre a jour la transaction';

  @override
  String get transactionsUncategorized => 'Non categorise';

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
  String get transactionsDeleted => 'Transaction supprimee';

  @override
  String get dashboardQuickAdd => 'Ajouter';

  @override
  String get dashboardQuickBudget => 'Budget';

  @override
  String get dashboardQuickSavings => 'Epargne';

  @override
  String get dashboardIncomeVsExpenses => 'Revenus vs Depenses';

  @override
  String get dashboardExpenseBreakdown => 'Repartition des depenses';

  @override
  String get dashboardNoChartData => 'Aucune donnee de transaction';

  @override
  String get dashboardNoChartDataSubtitle =>
      'Ajoutez votre premiere transaction pour voir le graphique';

  @override
  String get budgetTitle => 'Budget';

  @override
  String get budgetNoActiveBudget => 'Aucun budget actif';

  @override
  String get budgetNoActiveBudgetSubtitle =>
      'Creez un budget pour commencer a suivre vos depenses et garder le controle de vos finances.';

  @override
  String get budgetCreateBudget => 'Creer un budget';

  @override
  String get budgetEditBudget => 'Modifier le budget';

  @override
  String get budgetNewBudget => 'Nouveau budget';

  @override
  String get budgetTotalSpent => 'Total depense';

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
  String get budgetStrategyCustom => 'Personnalise';

  @override
  String get budgetSetupTitle => 'Creer un budget';

  @override
  String budgetSetupStep(int current, int total) {
    return 'Etape $current sur $total';
  }

  @override
  String get budgetSetupChooseStrategy => 'Choisissez votre strategie';

  @override
  String get budgetSetupChooseStrategySubtitle =>
      'Choisissez une methode de budget adaptee a votre style de vie.';

  @override
  String get budgetSetupSetPeriod => 'Definissez votre periode';

  @override
  String get budgetSetupSetPeriodSubtitle =>
      'A quelle frequence souhaitez-vous budgeter ?';

  @override
  String get budgetSetupExpectedIncome => 'Revenu prevu (optionnel)';

  @override
  String get budgetSetupExpectedIncomeSubtitle =>
      'Entrez votre revenu prevu pour calculer automatiquement les allocations.';

  @override
  String get budgetSetupExpectedIncomeHint => '0,00';

  @override
  String get budgetSetupBiWeekly => 'Bi-hebdomadaire (Toutes les 2 semaines)';

  @override
  String get budgetSetupCustomize => 'Personnaliser les allocations';

  @override
  String get budgetSetupCustomizeSubtitle =>
      'Ajustez les montants pour chaque categorie de depenses.';

  @override
  String get budgetSetupReview => 'Verifier votre budget';

  @override
  String get budgetSetupReviewSubtitle =>
      'Confirmez les details ci-dessous pour creer votre budget.';

  @override
  String get budgetSetupStrategy => 'Strategie';

  @override
  String get budgetSetupPeriod => 'Periode';

  @override
  String get budgetSetupIncome => 'Revenu';

  @override
  String get budgetSetupTotalBudget => 'Budget total';

  @override
  String get budgetSetupCategoryBreakdown => 'Repartition par categorie';

  @override
  String get budgetSetupContinue => 'Continuer';

  @override
  String get budgetStrategy5030Name => 'Regle 50/30/20';

  @override
  String get budgetStrategy5030Desc =>
      'Une approche equilibree qui repartit votre revenu entre besoins, envies et epargne.';

  @override
  String get budgetStrategy5030Formula =>
      '50% Besoins - 30% Envies - 20% Epargne';

  @override
  String get budgetStrategy8020Name => '80/20 Entrepreneur';

  @override
  String get budgetStrategy8020Desc =>
      'Pour les entrepreneurs : reinvestissez 80% dans les essentiels et l\'entreprise, epargnez 20%.';

  @override
  String get budgetStrategy8020Formula =>
      '80% Essentiels & Business - 20% Epargne';

  @override
  String get budgetStrategyEnvelopeName => 'Systeme d\'enveloppes';

  @override
  String get budgetStrategyEnvelopeDesc =>
      'Attribuez des montants fixes a chaque categorie. Quand l\'enveloppe est vide, arretez de depenser.';

  @override
  String get budgetStrategyEnvelopeFormula => 'Montants fixes par categorie';

  @override
  String get budgetStrategyCustomName => 'Personnalise';

  @override
  String get budgetStrategyCustomDesc =>
      'Definissez vos propres pourcentages et montants pour un controle total de votre budget.';

  @override
  String get budgetStrategyCustomFormula => 'Vous decidez la repartition';

  @override
  String get categoryFoodGroceries => 'Alimentation & Courses';

  @override
  String get categoryRent => 'Loyer';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryUtilities => 'Services publics';

  @override
  String get categoryHealth => 'Sante';

  @override
  String get categoryEntertainment => 'Divertissement';

  @override
  String get categoryClothing => 'Vetements';

  @override
  String get categoryAirtimeData => 'Credit & Data';

  @override
  String get categoryPersonalCare => 'Soins personnels';

  @override
  String get categoryFamilySupport => 'Soutien familial';

  @override
  String get categorySavings => 'Epargne';

  @override
  String get categoryDebtRepayment => 'Remboursement de dettes';

  @override
  String get categoryReligiousGiving => 'Don religieux';

  @override
  String get categoryBusinessExpenses => 'Depenses professionnelles';

  @override
  String get categoryMobileMoneyFees => 'Frais Mobile Money';

  @override
  String get categoryGroupNeeds => 'Besoins';

  @override
  String get categoryGroupWants => 'Envies';

  @override
  String get categoryGroupSavings => 'Epargne';

  @override
  String get categoryGroupEssentialsBusiness => 'Essentiels & Business';

  @override
  String get savingsGoalsTitle => 'Objectifs d\'epargne';

  @override
  String get savingsAddGoal => 'Ajouter un objectif';

  @override
  String get savingsNoGoals => 'Aucun objectif d\'epargne';

  @override
  String get savingsNoGoalsSubtitle =>
      'Pour quoi epargnez-vous ? Definissez un objectif pour commencer a suivre.';

  @override
  String get savingsCreateGoal => 'Creer un objectif';

  @override
  String get savingsNewGoal => 'Nouvel objectif d\'epargne';

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
  String get savingsDescriptionHint => 'Pour quoi epargnez-vous ?';

  @override
  String get savingsDeadlineOptional => 'Echeance (optionnel)';

  @override
  String get savingsNoDeadline => 'Aucune echeance definie';

  @override
  String get savingsGoalDetails => 'Details de l\'objectif';

  @override
  String get savingsGoalNotFound => 'Objectif introuvable';

  @override
  String get savingsDeleteGoal => 'Supprimer l\'objectif';

  @override
  String get savingsAddMoney => 'Ajouter de l\'argent';

  @override
  String get savingsSaved => 'Epargne';

  @override
  String get savingsRemaining => 'Restant';

  @override
  String get savingsTarget => 'Cible';

  @override
  String get savingsDeadline => 'Echeance';

  @override
  String get savingsNotes => 'Notes';

  @override
  String get savingsContributionHistory => 'Historique des contributions';

  @override
  String get savingsNoContributions =>
      'Aucune contribution. Appuyez sur \"Ajouter de l\'argent\" pour commencer !';

  @override
  String savingsAddMoneyTo(String name) {
    return 'Ajouter de l\'argent a \"$name\"';
  }

  @override
  String get savingsNoteOptional => 'Note (optionnel)';

  @override
  String get savingsAddContribution => 'Ajouter une contribution';

  @override
  String savingsDeleteGoalConfirm(String name) {
    return 'Supprimer \"$name\" ? Cette action est irreversible.';
  }

  @override
  String get savingsSavedLabel => 'epargne';

  @override
  String get moreTitle => 'Plus';

  @override
  String get moreAccountSection => 'Compte';

  @override
  String get moreFeaturesSection => 'Fonctionnalites';

  @override
  String get moreSupportSection => 'Support';

  @override
  String get moreProfile => 'Profil';

  @override
  String get moreSettings => 'Parametres';

  @override
  String get moreSavingsGoals => 'Objectifs d\'epargne';

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
      'Decouvrez Kale - une application intelligente de budget et suivi des depenses !';

  @override
  String get moreComingSoon => 'Bientot disponible';

  @override
  String get moreComingSoonMessage => 'Bientot disponible ! Restez connecte.';

  @override
  String get tontineGroupsTitle => 'Epargne communautaire';

  @override
  String get tontineGroupsDescription =>
      'Rejoignez ou creez un groupe de tontine pour epargner avec vos amis et votre famille. Mettez en commun vos cotisations et recevez la cagnotte a tour de role.';

  @override
  String get tontineGroupsHowItWorks => 'Comment ca marche';

  @override
  String get tontineGroupsStep1Title => 'Creez ou rejoignez un groupe';

  @override
  String get tontineGroupsStep1Desc =>
      'Lancez un nouveau groupe de tontine ou rejoignez-en un existant grace a une invitation.';

  @override
  String get tontineGroupsStep2Title => 'Cotisez regulierement';

  @override
  String get tontineGroupsStep2Desc =>
      'Chaque membre verse un montant fixe selon un calendrier defini.';

  @override
  String get tontineGroupsStep3Title => 'Recevez la cagnotte';

  @override
  String get tontineGroupsStep3Desc =>
      'Les membres recoivent a tour de role la totalite de la somme mise en commun.';

  @override
  String get tontineGroupsEmpty => 'Aucun groupe pour l\'instant';

  @override
  String get tontineGroupsEmptySubtitle =>
      'Creez votre premier groupe de tontine et commencez a epargner ensemble.';

  @override
  String get tontineGroupsCreateGroup => 'Creer un groupe';

  @override
  String get helpFaqTitle => 'Questions frequentes';

  @override
  String get helpFaq1Question => 'Comment ajouter une transaction ?';

  @override
  String get helpFaq1Answer =>
      'Appuyez sur le bouton + de l\'ecran d\'accueil pour ajouter un revenu ou une depense. Renseignez le montant, la categorie et des notes facultatives.';

  @override
  String get helpFaq2Question => 'Comment fonctionnent les budgets ?';

  @override
  String get helpFaq2Answer =>
      'Allez dans l\'onglet Budget pour definir des limites de depenses mensuelles par categorie. Kale suit vos depenses et vous previent lorsque vous approchez de votre limite.';

  @override
  String get helpFaq3Question => 'Puis-je definir des objectifs d\'epargne ?';

  @override
  String get helpFaq3Answer =>
      'Oui ! Allez dans Plus > Objectifs d\'epargne pour creer des objectifs comme des vacances, un fonds d\'urgence ou un gros achat. Suivez votre progression au fil du temps.';

  @override
  String get helpFaq4Question => 'Mes donnees sont-elles securisees ?';

  @override
  String get helpFaq4Answer =>
      'Vos donnees sont chiffrees et stockees en toute securite. Nous ne partageons jamais vos informations financieres avec des tiers. Vous pouvez effacer les donnees locales a tout moment depuis les Parametres.';

  @override
  String get helpContactTitle => 'Nous contacter';

  @override
  String get helpContactEmail => 'Assistance par e-mail';

  @override
  String get helpContactChat => 'Chat en direct';

  @override
  String get helpContactChatSubtitle =>
      'Disponible du lundi au vendredi, de 9h a 17h';

  @override
  String get helpLegalTitle => 'Mentions legales';

  @override
  String get rateAppTitle => 'Vous aimez Kale ?';

  @override
  String get rateAppSubtitle =>
      'Votre avis nous aide a nous ameliorer. Dites-nous ce que vous en pensez !';

  @override
  String get rateAppSubmit => 'Envoyer la note';

  @override
  String get rateAppLabel1 => 'A ameliorer';

  @override
  String get rateAppLabel2 => 'Pourrait etre mieux';

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
      'Nous apprecions votre avis. Il nous aide a rendre Kale encore meilleure pour vous.';

  @override
  String get shareAppTitle => 'Partager Kale';

  @override
  String get shareAppDescription =>
      'Aidez vos amis et votre famille a prendre le controle de leurs finances avec Kale.';

  @override
  String get shareAppShareVia => 'PARTAGER VIA';

  @override
  String get shareAppCopyLink => 'Copier le lien de telechargement';

  @override
  String get shareAppCopyMessage => 'Copier le message de partage';

  @override
  String get shareAppLinkCopied => 'Lien copie dans le presse-papiers';

  @override
  String get shareAppMessageCopied => 'Message copie dans le presse-papiers';

  @override
  String get onboardingTitle4 => 'Personnalisez votre experience';

  @override
  String get onboardingDesc4 =>
      'Choisissez vos preferences pour tirer le meilleur parti de Kale.';

  @override
  String get onboardingCurrency => 'Devise';

  @override
  String get onboardingLanguage => 'Langue';

  @override
  String get onboardingGoal => 'Quel est votre objectif principal ?';

  @override
  String get onboardingGoalTrackSpending => 'Suivre mes depenses';

  @override
  String get onboardingGoalSaveMore => 'Epargner plus';

  @override
  String get onboardingGoalManageBudgets => 'Gerer mes budgets';

  @override
  String get coachMarkFab =>
      'Appuyez ici pour ajouter votre premiere transaction';

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
  String get profileLogout => 'Deconnexion';

  @override
  String get profileAchievements => 'Accomplissements';

  @override
  String profileLevel(String level) {
    return 'Niveau : $level';
  }

  @override
  String profileBadgesUnlocked(int count, int total) {
    return '$count sur $total badges debloques';
  }

  @override
  String get achievementFirstTransaction => 'Premiere transaction';

  @override
  String get achievementStreak7 => 'Serie de 7 jours';

  @override
  String get achievementStreak30 => 'Serie de 30 jours';

  @override
  String get achievementFirstBudget => 'Premier budget';

  @override
  String get achievementUnderBudget => 'Sous le budget';

  @override
  String get achievementFirstGoalCompleted => 'Objectif atteint';

  @override
  String get achievementTransactions100 => '100 transactions';

  @override
  String get levelBeginner => 'Debutant';

  @override
  String get levelExplorer => 'Explorateur';

  @override
  String get levelPro => 'Pro';

  @override
  String get levelMaster => 'Maitre';

  @override
  String get settingsTitle => 'Parametres';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'Systeme';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageEn => 'Anglais';

  @override
  String get settingsLanguageFr => 'Francais';

  @override
  String get settingsAbout => 'A propos';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsTerms => 'Conditions d\'utilisation';

  @override
  String get settingsPrivacy => 'Politique de confidentialite';

  @override
  String get settingsCurrency => 'Devise';

  @override
  String get settingsSelectCurrency => 'Selectionner la devise';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPushNotifications => 'Notifications push';

  @override
  String get settingsEnabled => 'Active';

  @override
  String get settingsDisabled => 'Desactive';

  @override
  String get settingsDailyReminder => 'Rappel quotidien';

  @override
  String get settingsDailyReminderSubtitle =>
      'Me rappeler de saisir mes transactions';

  @override
  String get settingsBudgetAlertThreshold => 'Seuil d\'alerte budget';

  @override
  String settingsBudgetAlertThresholdSubtitle(int percentage) {
    return 'Alerte lorsque les depenses atteignent $percentage% du budget';
  }

  @override
  String get settingsData => 'Donnees';

  @override
  String get settingsClearLocalData => 'Effacer les donnees locales';

  @override
  String get settingsClearLocalDataSubtitle =>
      'Supprimer toutes les donnees en cache de cet appareil';

  @override
  String get settingsClearLocalDataConfirm =>
      'Cela supprimera toutes les donnees en cache de cet appareil. Votre compte et vos donnees synchronisees sur le serveur ne seront pas affectes.\n\nEtes-vous sur ?';

  @override
  String get settingsClearLocalDataSuccess => 'Donnees locales effacees';

  @override
  String get legalLastUpdated => 'Derniere mise a jour : 20 fevrier 2026';

  @override
  String get legalContactFooter =>
      'Si vous avez des questions, contactez-nous a support@kale.app';

  @override
  String get legalTosTitle => 'Conditions d\'utilisation';

  @override
  String get legalTosIntroHeading => '1. Introduction';

  @override
  String get legalTosIntroBody =>
      'Bienvenue sur Kale. Ces Conditions d\'utilisation regissent votre utilisation de l\'application mobile Kale et des services associes. En creant un compte ou en utilisant Kale, vous acceptez d\'etre lie par ces conditions. Si vous n\'etes pas d\'accord, veuillez ne pas utiliser l\'application.';

  @override
  String get legalTosAccountHeading => '2. Inscription au compte';

  @override
  String get legalTosAccountBody =>
      'Pour utiliser Kale, vous devez creer un compte avec des informations exactes et completes. Vous etes responsable du maintien de la confidentialite de vos identifiants de connexion et de toute activite sous votre compte. Vous devez avoir au moins 13 ans pour creer un compte. Si vous avez moins de 18 ans, vous confirmez avoir le consentement de votre parent ou tuteur.';

  @override
  String get legalTosServicesHeading => '3. Services fournis';

  @override
  String get legalTosServicesBody =>
      'Kale fournit des outils de gestion des finances personnelles comprenant le suivi des depenses et des revenus, la creation et le suivi de budgets, la gestion des objectifs d\'epargne et des analyses financieres. Ces outils sont concus pour vous aider a organiser et comprendre vos finances personnelles.';

  @override
  String get legalTosResponsibilitiesHeading =>
      '4. Responsabilites de l\'utilisateur';

  @override
  String get legalTosResponsibilitiesBody =>
      'Vous etes seul responsable de l\'exactitude des donnees financieres que vous saisissez dans Kale. Kale est un outil de suivi et d\'organisation et ne fournit pas de conseils financiers, d\'investissement, fiscaux ou juridiques professionnels. Vous acceptez d\'utiliser l\'application conformement a toutes les lois et reglementations applicables.';

  @override
  String get legalTosFinancialDataHeading => '5. Donnees financieres';

  @override
  String get legalTosFinancialDataBody =>
      'Kale n\'est pas une banque, un processeur de paiement ou une institution financiere. Nous ne detenons pas, ne transferons pas et n\'avons pas la garde de vos fonds. Toutes les donnees financieres dans Kale sont des informations saisies par l\'utilisateur a des fins de suivi personnel uniquement. Nous ne verifions pas l\'exactitude des transactions, soldes ou autres informations financieres que vous saisissez.';

  @override
  String get legalTosIpHeading => '6. Propriete intellectuelle';

  @override
  String get legalTosIpBody =>
      'L\'application Kale, y compris sa conception, son code, ses fonctionnalites et sa marque, est la propriete de Kale et protegee par les lois sur la propriete intellectuelle. Vous conservez la pleine propriete des donnees personnelles et des informations financieres que vous saisissez dans l\'application. Vous accordez a Kale une licence limitee pour traiter vos donnees uniquement pour fournir et ameliorer les services.';

  @override
  String get legalTosLiabilityHeading => '7. Limitation de responsabilite';

  @override
  String get legalTosLiabilityBody =>
      'Kale est fourni \"en l\'etat\". Nous ne sommes pas responsables des decisions financieres que vous prenez sur la base des informations affichees dans l\'application. Nous ne garantissons pas l\'exactitude des calculs, resumes ou analyses derivees de vos donnees. Dans la mesure maximale permise par la loi, Kale ne sera pas responsable des dommages indirects, accessoires ou consecutifs.';

  @override
  String get legalTosTerminationHeading => '8. Resiliation';

  @override
  String get legalTosTerminationBody =>
      'Vous pouvez supprimer votre compte a tout moment via les parametres de l\'application. Nous pouvons suspendre ou resilier votre compte si vous violez ces conditions. A la resiliation, vos donnees seront supprimees de nos serveurs dans les 30 jours, sauf si la conservation est requise par la loi.';

  @override
  String get legalTosChangesHeading => '9. Modifications de ces conditions';

  @override
  String get legalTosChangesBody =>
      'Nous pouvons mettre a jour ces Conditions d\'utilisation de temps en temps. Nous vous informerons des modifications importantes via l\'application ou par e-mail. Votre utilisation continue de Kale apres la publication des modifications constitue votre acceptation des conditions mises a jour.';

  @override
  String get legalTosContactHeading => '10. Nous contacter';

  @override
  String get legalTosContactBody =>
      'Si vous avez des questions sur ces Conditions d\'utilisation, veuillez nous contacter a support@kale.app.';

  @override
  String get legalPrivacyTitle => 'Politique de confidentialite';

  @override
  String get legalPrivacyIntroHeading => '1. Introduction';

  @override
  String get legalPrivacyIntroBody =>
      'Votre vie privee est importante pour nous. Cette Politique de confidentialite explique comment Kale collecte, utilise, stocke et protege vos informations personnelles et financieres. Nous nous engageons a traiter vos donnees avec transparence et soin.';

  @override
  String get legalPrivacyCollectionHeading =>
      '2. Informations que nous collectons';

  @override
  String get legalPrivacyCollectionBody =>
      'Nous collectons les types d\'informations suivants :\n\nInformations de compte : Votre nom, adresse e-mail et identifiants d\'authentification lors de la creation de votre compte.\n\nDonnees financieres : Enregistrements de transactions, configurations de budget, objectifs d\'epargne et preferences de categories que vous saisissez dans l\'application.\n\nDonnees d\'utilisation : Analyses anonymes de la facon dont vous interagissez avec l\'application, y compris les vues d\'ecran et l\'utilisation des fonctionnalites, pour nous aider a ameliorer l\'experience.\n\nInformations sur l\'appareil : Type d\'appareil, version du systeme d\'exploitation et version de l\'application a des fins de compatibilite et de depannage.';

  @override
  String get legalPrivacyUsageHeading =>
      '3. Comment nous utilisons vos donnees';

  @override
  String get legalPrivacyUsageBody =>
      'Nous utilisons vos informations pour :\n\n- Fournir, maintenir et ameliorer les fonctionnalites et services de Kale\n- Generer des resumes financiers personnalises, des graphiques et des analyses\n- Vous envoyer des notifications telles que des alertes de budget et des rappels quotidiens (lorsqu\'ils sont actives)\n- Authentifier votre identite et securiser votre compte\n- Analyser les tendances d\'utilisation agregees pour ameliorer l\'experience de l\'application';

  @override
  String get legalPrivacyStorageHeading =>
      '4. Stockage et securite des donnees';

  @override
  String get legalPrivacyStorageBody =>
      'Vos donnees sont stockees de maniere securisee en utilisant des pratiques conformes aux normes de l\'industrie. Toutes les donnees sont chiffrees en transit via TLS et au repos sur nos serveurs. Nous utilisons Supabase comme infrastructure backend, qui fournit une securite de niveau entreprise, des controles d\'acces et une isolation des donnees. Nous revisons regulierement nos pratiques de securite et limitons l\'acces a vos donnees au personnel autorise uniquement.';

  @override
  String get legalPrivacyThirdPartyHeading => '5. Services tiers';

  @override
  String get legalPrivacyThirdPartyBody =>
      'Kale s\'integre aux services tiers suivants :\n\n- Google Sign-In et Apple Sign-In pour l\'authentification\n- Services d\'analyse pour le suivi anonyme de l\'utilisation\n- Services de signalement de crash pour identifier et corriger les problemes de l\'application\n\nNous ne vendons pas, ne louons pas et ne partageons pas vos donnees personnelles ou financieres avec des tiers a des fins de marketing. Les services tiers ne recoivent que les donnees minimales necessaires pour remplir leur fonction.';

  @override
  String get legalPrivacyRightsHeading => '6. Vos droits';

  @override
  String get legalPrivacyRightsBody =>
      'Vous avez le droit de :\n\n- Acceder aux donnees personnelles que nous detenons sur vous\n- Corriger les informations inexactes de votre compte\n- Supprimer votre compte et toutes les donnees associees\n- Exporter vos donnees financieres\n- Restreindre ou vous opposer a certains traitements de vos donnees\n\nPour exercer l\'un de ces droits, contactez-nous a privacy@kale.app ou utilisez les fonctionnalites de gestion de compte dans l\'application.';

  @override
  String get legalPrivacyRetentionHeading => '7. Conservation des donnees';

  @override
  String get legalPrivacyRetentionBody =>
      'Nous conservons vos donnees aussi longtemps que votre compte est actif. Si vous supprimez votre compte, nous supprimerons vos donnees personnelles et financieres de nos serveurs dans les 30 jours. Certaines donnees anonymisees et agregees peuvent etre conservees a des fins d\'analyse. Nous pouvons egalement conserver certaines donnees comme requis par la loi.';

  @override
  String get legalPrivacyChildrenHeading => '8. Vie privee des enfants';

  @override
  String get legalPrivacyChildrenBody =>
      'Kale ne s\'adresse pas aux enfants de moins de 13 ans. Nous ne collectons pas sciemment d\'informations personnelles aupres d\'enfants de moins de 13 ans. Si nous apprenons que nous avons collecte des donnees d\'un enfant de moins de 13 ans sans le consentement parental, nous prendrons des mesures pour supprimer ces informations rapidement.';

  @override
  String get legalPrivacyChangesHeading =>
      '9. Modifications de cette politique';

  @override
  String get legalPrivacyChangesBody =>
      'Nous pouvons mettre a jour cette Politique de confidentialite de temps en temps. Nous vous informerons des modifications importantes via une notification dans l\'application ou par e-mail. Nous vous encourageons a consulter cette politique periodiquement. Votre utilisation continue de Kale apres la publication des modifications constitue votre acceptation de la politique mise a jour.';

  @override
  String get legalPrivacyContactHeading => '10. Nous contacter';

  @override
  String get legalPrivacyContactBody =>
      'Si vous avez des questions sur cette Politique de confidentialite ou sur la facon dont vos donnees sont traitees, veuillez nous contacter a privacy@kale.app.';

  @override
  String get offlineBanner => 'Vous etes hors ligne';

  @override
  String get emptyStateTitle => 'Rien ici pour le moment';

  @override
  String get emptyStateSubtitle => 'Revenez plus tard pour les mises a jour.';

  @override
  String get budgetEmptyRecommendation =>
      'Nous recommandons la regle 50/30/20 pour commencer';

  @override
  String get budgetStartWith5030 => 'Commencer avec 50/30/20';

  @override
  String get budgetCustomBudget => 'Budget personnalise';

  @override
  String get budgetEmptyQuickTip => 'Cela ne prend qu\'une minute a configurer';

  @override
  String get savingsEmptyTemplateTitle =>
      'Objectifs populaires pour vous inspirer';

  @override
  String get savingsTemplateEmergency => 'Fonds d\'urgence';

  @override
  String get savingsTemplateVacation => 'Vacances';

  @override
  String get savingsTemplateNewPhone => 'Nouveau telephone';

  @override
  String get savingsEmptyOrCreate => 'Ou creez votre propre objectif';

  @override
  String get transactionsEmptyQuickTip => 'Cela ne prend que 10 secondes';

  @override
  String get dashboardEmptyTitle => 'Bienvenue sur Kale !';

  @override
  String get dashboardEmptySubtitle =>
      'Completez ces etapes pour tirer le meilleur parti de vos finances :';

  @override
  String get dashboardEmptyStep1 => 'Ajoutez votre premiere transaction';

  @override
  String get dashboardEmptyStep2 => 'Configurez un budget';

  @override
  String get dashboardEmptyStep3 => 'Creez un objectif d\'epargne';

  @override
  String dashboardStreak(int count) {
    return 'Serie de $count jours';
  }

  @override
  String get dashboardStreakStart => 'Commencez votre serie !';

  @override
  String get dashboardFinancialHealth => 'Sante financiere';

  @override
  String get dashboardHealthExcellent => 'Excellent';

  @override
  String get dashboardHealthGood => 'Bien';

  @override
  String get dashboardHealthFair => 'Moyen';

  @override
  String get dashboardHealthNeedsWork => 'A ameliorer';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'Aucune notification';

  @override
  String get notificationsEmptySubtitle =>
      'Vous etes a jour ! Les notifications concernant vos budgets, epargnes et rappels apparaitront ici.';
}
