import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/validators.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/core/widgets/inputs/app_password_field.dart';
import 'package:kale/core/widgets/inputs/app_text_field.dart';
import 'package:kale/features/auth/domain/entities/account_link.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/auth/presentation/providers/save_data_outcome.dart';
import 'package:kale/features/auth/presentation/widgets/auth_header.dart';
import 'package:kale/features/auth/presentation/widgets/save_data_flow.dart';
import 'package:kale/features/auth/presentation/widgets/social_login_buttons.dart';
import 'package:kale/features/auth/presentation/widgets/try_first_button.dart';

/// Login page with editorial header, gradient CTA, and social login grid.
class LoginPage extends ConsumerStatefulWidget {
  /// Creates a [LoginPage].
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin, SaveDataFlow<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// A guest never logs in directly: their entries would be left under
  /// the guest account. They choose to add or discard them first.
  bool get _isGuest {
    final state = ref.read(authNotifierProvider);
    return state is AuthAuthenticated && state.user.isAnonymous;
  }

  // Only email-code switches need a code, and the login page never starts
  // one.
  @override
  void onCodeSent({PendingEmailSwitch? pending}) {}

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.unfocus();
      if (_isGuest) {
        final credential = PasswordCredential(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        runSaveDataStep(() async {
          final count =
              await ref.read(authNotifierProvider.notifier).countGuestEntries();
          return SaveDataIdentityInUse(
            credential: credential,
            entryCount: count,
          );
        });
        return;
      }
      ref.read(authNotifierProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  /// Social sign-in; a guest links the identity instead (keeping their
  /// entries), or chooses what to do with them if it is taken.
  void _onSocial(SocialProvider provider) {
    final notifier = ref.read(authNotifierProvider.notifier);
    if (_isGuest) {
      runSaveDataStep(() => notifier.linkSocialAccount(provider));
      return;
    }
    switch (provider) {
      case SocialProvider.google:
        notifier.signInWithGoogle();
      case SocialProvider.apple:
        notifier.signInWithApple();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading || busy;
    final isAnonymous =
        authState is AuthAuthenticated && authState.user.isAnonymous;
    final colorScheme = context.colorScheme;

    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (state is AuthError) {
        context.showSnackBar(state.message, isError: true);
      }
      if (state is AuthAuthenticated) {
        context.go(RouteNames.dashboard);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Background K watermarks
          const GeometricKWatermark(
            opacity: 0.03,
            fontSize: 280,
            alignment: Alignment.topRight,
            offset: Offset(80, -60),
          ),
          const GeometricKWatermark(
            opacity: 0.02,
            fontSize: 200,
            alignment: Alignment.bottomLeft,
            offset: Offset(-40, 60),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingHorizontalXl,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthHeader(
                          title: context.l10n.authLogin,
                          subtitle: context.l10n.authLoginSubtitle,
                        ),
                        AppTextField(
                          controller: _emailController,
                          label: context.l10n.authEmail,
                          hint: 'name@example.com',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          validator: Validators.email,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        AppSpacing.verticalLg,
                        AppPasswordField(
                          controller: _passwordController,
                          label: context.l10n.authPassword,
                          validator: Validators.password,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _onLogin(),
                        ),
                        AppSpacing.verticalSm,
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                context.push(RouteNames.forgotPassword),
                            child: Text(context.l10n.authForgotPassword),
                          ),
                        ),
                        AppSpacing.verticalLg,
                        AppPrimaryButton(
                          text: context.l10n.authLogin,
                          onPressed: _onLogin,
                          isLoading: isLoading,
                        ),
                        AppSpacing.verticalXl,

                        // "OR CONTINUE WITH" divider
                        Center(
                          child: Text(
                            context.l10n.commonOr.toUpperCase(),
                            style: context.textTheme.labelSmall,
                          ),
                        ),
                        AppSpacing.verticalXl,

                        // Social login grid
                        SocialLoginButtons(
                          googleLabel: context.l10n.authLoginWithGoogle,
                          appleLabel: context.l10n.authLoginWithApple,
                          onGooglePressed: () =>
                              _onSocial(SocialProvider.google),
                          onApplePressed: () => _onSocial(SocialProvider.apple),
                        ),
                        AppSpacing.verticalXl,

                        // Try first: starts an anonymous session. Hidden
                        // when already anonymous: a second anonymous
                        // account would strand the first one's data.
                        if (!isAnonymous) ...[
                          TryFirstButton(
                            onPressed: () => ref
                                .read(authNotifierProvider.notifier)
                                .signInAnonymously(),
                            colorScheme: colorScheme,
                            label: context.l10n.authTryFirst,
                          ),
                          AppSpacing.verticalXl,
                        ],

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(context.l10n.authNoAccount),
                            TextButton(
                              onPressed: () =>
                                  context.push(RouteNames.register),
                              child: Text(
                                context.l10n.authRegister,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.verticalXl,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
