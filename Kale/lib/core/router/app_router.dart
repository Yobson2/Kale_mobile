import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/providers/analytics_provider.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/router/analytics_observer.dart';
import 'package:kale/core/router/page_transitions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/states/app_empty_state.dart';
import 'package:kale/features/auth/presentation/pages/create_password_page.dart';
import 'package:kale/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:kale/features/auth/presentation/pages/login_page.dart';
import 'package:kale/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:kale/features/auth/presentation/pages/register_page.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/budget/presentation/pages/budget_page.dart';
import 'package:kale/features/budget/presentation/pages/budget_setup_page.dart';
import 'package:kale/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:kale/features/legal/presentation/pages/privacy_policy_page.dart';
import 'package:kale/features/legal/presentation/pages/terms_of_service_page.dart';
import 'package:kale/features/main/home_shell.dart';
import 'package:kale/features/more/presentation/pages/more_page.dart';
import 'package:kale/features/more/presentation/pages/profile_page.dart';
import 'package:kale/features/more/presentation/pages/settings_page.dart';
import 'package:kale/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:kale/features/savings/presentation/pages/add_savings_goal_page.dart';
import 'package:kale/features/savings/presentation/pages/savings_goal_detail_page.dart';
import 'package:kale/features/savings/presentation/pages/savings_goals_page.dart';
import 'package:kale/features/splash/presentation/pages/splash_page.dart';
import 'package:kale/features/transactions/presentation/pages/add_transaction_page.dart';
import 'package:kale/features/transactions/presentation/pages/transaction_detail_page.dart';
import 'package:kale/features/transactions/presentation/pages/transactions_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _dashboardNavigatorKey = GlobalKey<NavigatorState>();
final _transactionsNavigatorKey = GlobalKey<NavigatorState>();
final _budgetNavigatorKey = GlobalKey<NavigatorState>();
final _moreNavigatorKey = GlobalKey<NavigatorState>();

/// Public routes that don't require authentication.
const _publicPaths = [
  RouteNames.splash,
  RouteNames.onboarding,
  RouteNames.login,
  RouteNames.register,
  RouteNames.forgotPassword,
  RouteNames.otpVerification,
  RouteNames.createPassword,
  RouteNames.termsOfService,
  RouteNames.privacyPolicy,
];

/// Provides the application [GoRouter] instance.
///
/// Listens to [authNotifierProvider] for authentication state changes
/// and redirects accordingly. Splash handles initial navigation;
/// the router only enforces auth/onboarding guards after splash.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authState = ValueNotifier<AuthState>(const AuthInitial());

  ref
    ..listen(authNotifierProvider, (_, next) {
      authState.value = next;
    })
    ..onDispose(authState.dispose);

  final analytics = ref.read(analyticsServiceProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    refreshListenable: authState,
    observers: [AnalyticsObserver(analytics)],
    redirect: (context, state) {
      final currentPath = state.matchedLocation;
      final auth = authState.value;

      // Never redirect away from splash — it handles its own navigation.
      if (currentPath == RouteNames.splash) return null;

      // Don't redirect while auth state is still initializing.
      if (auth is AuthInitial || auth is AuthLoading) return null;

      final isPublicRoute = _publicPaths.contains(currentPath);

      // Redirect authenticated users away from auth pages.
      if (auth is AuthAuthenticated && isPublicRoute) {
        return RouteNames.dashboard;
      }

      // Guest users can access core features (dashboard, transactions,
      // budget) but redirect away from auth pages.
      if (auth is AuthGuest && isPublicRoute) {
        return RouteNames.dashboard;
      }

      // Redirect unauthenticated users to login for protected routes.
      if (auth is AuthUnauthenticated && !isPublicRoute) {
        return RouteNames.login;
      }

      // Check onboarding completion for the login route.
      if (auth is AuthUnauthenticated && currentPath == RouteNames.login) {
        final localStorage = ref.read(localStorageProvider);
        if (!localStorage.isOnboardingComplete && localStorage.isFirstLaunch) {
          return RouteNames.onboarding;
        }
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
    routes: [
      // Splash
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splashName,
        builder: (context, state) => const SplashPage(),
      ),

      // Onboarding
      GoRoute(
        path: RouteNames.onboarding,
        name: RouteNames.onboardingName,
        builder: (context, state) => const OnboardingPage(),
      ),

      // Auth routes
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.loginName,
        pageBuilder: (context, state) => AppPageTransitions.fade(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.registerName,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: RouteNames.forgotPasswordName,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.otpVerification,
        name: RouteNames.otpVerificationName,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return OtpVerificationPage(
            email: extra['email'] ?? '',
            name: extra['name'],
          );
        },
      ),
      GoRoute(
        path: RouteNames.createPassword,
        name: RouteNames.createPasswordName,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return CreatePasswordPage(
            name: extra['name'] ?? '',
            email: extra['email'] ?? '',
          );
        },
      ),

      // Legal pages (accessible with or without auth)
      GoRoute(
        path: RouteNames.termsOfService,
        name: RouteNames.termsOfServiceName,
        builder: (context, state) => const TermsOfServicePage(),
      ),
      GoRoute(
        path: RouteNames.privacyPolicy,
        name: RouteNames.privacyPolicyName,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),

      // Add Transaction (root-level modal with parentNavigatorKey)
      GoRoute(
        path: RouteNames.addTransaction,
        name: RouteNames.addTransactionName,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppPageTransitions.slideUp(
          key: state.pageKey,
          child: const AddTransactionPage(),
        ),
      ),

      // Home shell with bottom navigation (4 branches)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.dashboard,
                name: RouteNames.dashboardName,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),

          // Branch 1: Transactions
          StatefulShellBranch(
            navigatorKey: _transactionsNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.transactions,
                name: RouteNames.transactionsName,
                builder: (context, state) => const TransactionsPage(),
                routes: [
                  GoRoute(
                    path: 'detail',
                    name: RouteNames.transactionDetailName,
                    builder: (context, state) {
                      final transactionId = state.extra as String?;
                      return TransactionDetailPage(
                        transactionId: transactionId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 2: Budget
          StatefulShellBranch(
            navigatorKey: _budgetNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.budget,
                name: RouteNames.budgetName,
                builder: (context, state) => const BudgetPage(),
                routes: [
                  GoRoute(
                    path: 'setup',
                    name: RouteNames.budgetSetupName,
                    builder: (context, state) => const BudgetSetupPage(),
                  ),
                ],
              ),
            ],
          ),

          // Branch 3: More
          StatefulShellBranch(
            navigatorKey: _moreNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.more,
                name: RouteNames.moreName,
                builder: (context, state) => const MorePage(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    name: RouteNames.profileName,
                    builder: (context, state) => const ProfilePage(),
                  ),
                  GoRoute(
                    path: 'settings',
                    name: RouteNames.settingsName,
                    builder: (context, state) => const SettingsPage(),
                  ),
                  GoRoute(
                    path: 'savings',
                    name: RouteNames.savingsGoalsName,
                    builder: (context, state) => const SavingsGoalsPage(),
                    routes: [
                      GoRoute(
                        path: 'add',
                        name: RouteNames.addSavingsGoalName,
                        builder: (context, state) => const AddSavingsGoalPage(),
                      ),
                      GoRoute(
                        path: 'detail',
                        name: RouteNames.savingsGoalDetailName,
                        builder: (context, state) {
                          final goalId = state.extra as String?;
                          return SavingsGoalDetailPage(goalId: goalId);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'insights',
                    name: RouteNames.insightsName,
                    builder: (context, state) => const Scaffold(
                      appBar: AppAppBar(title: 'Insights'),
                      body: AppEmptyState(
                        title: 'Insights Coming Soon',
                        subtitle:
                            'Your spending patterns will be analyzed here.',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
