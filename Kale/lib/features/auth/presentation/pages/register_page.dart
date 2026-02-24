import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/providers/analytics_provider.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/validators.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/inputs/app_checkbox.dart';
import 'package:kale/core/widgets/inputs/app_password_field.dart';
import 'package:kale/core/widgets/inputs/app_text_field.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/auth/presentation/widgets/auth_header.dart';
import 'package:kale/features/auth/presentation/widgets/password_strength_indicator.dart';
import 'package:kale/features/auth/presentation/widgets/social_login_buttons.dart';

/// Registration page — collects name, email, password and confirm password.
///
/// On submit, creates the account via Supabase which sends a confirmation
/// OTP, then navigates to the OTP verification page.
class RegisterPage extends ConsumerStatefulWidget {
  /// Creates a [RegisterPage].
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  bool _agreedToTerms = false;
  bool _registrationStartedTracked = false;
  String _password = '';

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

    _passwordController.addListener(_onPasswordChanged);

    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push(RouteNames.termsOfService);
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push(RouteNames.privacyPolicy);
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    setState(() {
      _password = _passwordController.text;
    });
  }

  void _trackRegistrationStarted() {
    if (!_registrationStartedTracked) {
      _registrationStartedTracked = true;
      ref.read(analyticsServiceProvider).logEvent('registration_started');
    }
  }

  Future<void> _onRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.unfocus();

    final analytics = ref.read(analyticsServiceProvider);
    analytics.logEvent('registration_submitted');

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final success = await ref
        .read(authNotifierProvider.notifier)
        .register(name: name, email: email, password: password);
    if (success && mounted) {
      analytics.logEvent('registration_succeeded');
      await context.push<void>(
        RouteNames.otpVerification,
        extra: {'name': name, 'email': email},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (state is AuthError) {
        ref.read(analyticsServiceProvider).logEvent(
          'registration_failed',
          {'error_message': state.message},
        );
        context.showSnackBar(state.message, isError: true);
      }
      // Social login success navigates to dashboard.
      if (state is AuthAuthenticated) {
        context.go(RouteNames.dashboard);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingHorizontalXl,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (hasFocus) _trackRegistrationStarted();
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthHeader(
                        title: context.l10n.authRegister,
                        subtitle: context.l10n.authRegisterSubtitle,
                      ),
                      AppTextField(
                        controller: _nameController,
                        label: context.l10n.authName,
                        hint: 'John Doe',
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        validator: (v) =>
                            Validators.required(v, fieldName: 'Name'),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      AppSpacing.verticalLg,
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
                        textInputAction: TextInputAction.next,
                      ),
                      if (_password.isNotEmpty) ...[
                        AppSpacing.verticalSm,
                        PasswordStrengthIndicator(password: _password),
                        AppSpacing.verticalSm,
                      ] else
                        AppSpacing.verticalLg,
                      AppPasswordField(
                        controller: _confirmPasswordController,
                        label: context.l10n.authConfirmPassword,
                        hint: 'Re-enter your password',
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return context.l10n.validationPasswordMatch;
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _onRegister(),
                      ),
                      AppSpacing.verticalLg,
                      AppCheckbox(
                        value: _agreedToTerms,
                        onChanged: (value) =>
                            setState(() => _agreedToTerms = value ?? false),
                        labelWidget: Text.rich(
                          TextSpan(
                            style: context.textTheme.bodySmall,
                            children: [
                              TextSpan(
                                text: context.l10n.authTermsPrefix,
                              ),
                              TextSpan(
                                text: context.l10n.authTermsOfService,
                                style: TextStyle(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: _termsRecognizer,
                              ),
                              TextSpan(
                                text: context.l10n.authTermsAnd,
                              ),
                              TextSpan(
                                text: context.l10n.authPrivacyPolicy,
                                style: TextStyle(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: _privacyRecognizer,
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                      AppSpacing.verticalXl,
                      AppPrimaryButton(
                        text: context.l10n.authRegister,
                        onPressed: _agreedToTerms ? _onRegister : null,
                        isLoading: isLoading,
                      ),
                      AppSpacing.verticalXl,
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: AppSpacing.paddingHorizontalLg,
                            child: Text(
                              context.l10n.commonOr,
                              style: context.textTheme.bodySmall,
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      AppSpacing.verticalXl,
                      SocialLoginButtons(
                        googleLabel: context.l10n.authLoginWithGoogle,
                        appleLabel: context.l10n.authLoginWithApple,
                        onGooglePressed: () {
                          ref.read(analyticsServiceProvider).logEvent(
                            'social_login_clicked',
                            {'provider': 'google'},
                          );
                          ref
                              .read(authNotifierProvider.notifier)
                              .signInWithGoogle();
                        },
                        onApplePressed: () {
                          ref.read(analyticsServiceProvider).logEvent(
                            'social_login_clicked',
                            {'provider': 'apple'},
                          );
                          ref
                              .read(authNotifierProvider.notifier)
                              .signInWithApple();
                        },
                      ),
                      AppSpacing.verticalLg,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.l10n.authHaveAccount),
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(context.l10n.authLogin),
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
      ),
    );
  }
}
