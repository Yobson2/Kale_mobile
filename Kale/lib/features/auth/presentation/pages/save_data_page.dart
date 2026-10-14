import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/validators.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/inputs/app_otp_field.dart';
import 'package:kale/core/widgets/inputs/app_password_field.dart';
import 'package:kale/core/widgets/inputs/app_text_field.dart';
import 'package:kale/features/auth/domain/entities/account_link.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/widgets/auth_header.dart';
import 'package:kale/features/auth/presentation/widgets/save_data_flow.dart';
import 'package:kale/features/auth/presentation/widgets/social_login_buttons.dart';

/// Where a guest creates a real account without losing anything: link an
/// email (with a code and a password), Google, or Apple. The user id stays
/// the same, so every entry stays.
///
/// If the identity already belongs to an account, the guest chooses to add
/// their entries to it or discard them (see [SaveDataFlow]).
class SaveDataPage extends ConsumerStatefulWidget {
  /// Creates a [SaveDataPage].
  const SaveDataPage({super.key});

  @override
  ConsumerState<SaveDataPage> createState() => _SaveDataPageState();
}

class _SaveDataPageState extends ConsumerState<SaveDataPage>
    with SaveDataFlow<SaveDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Whether the code field is shown.
  bool _awaitingCode = false;

  /// Set when the code signs in to an existing account instead of linking.
  PendingEmailSwitch? _pendingSwitch;

  String _code = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _email => _emailController.text.trim();

  @override
  void onCodeSent({PendingEmailSwitch? pending}) {
    setState(() {
      _awaitingCode = true;
      _pendingSwitch = pending;
      _code = '';
    });
  }

  void _onContinueWithEmail() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.unfocus();
    runSaveDataStep(
      () => ref.read(authNotifierProvider.notifier).startEmailLink(_email),
    );
  }

  void _onVerify() {
    if (_code.length < 6) return;
    context.unfocus();
    final notifier = ref.read(authNotifierProvider.notifier);
    final pending = _pendingSwitch;
    runSaveDataStep(
      () => pending == null
          ? notifier.confirmEmailLink(
              email: _email,
              code: _code,
              password: _passwordController.text,
            )
          : notifier.switchToExistingAccount(
              pending.credential,
              keepGuestData: pending.keepGuestData,
              code: _code,
            ),
    );
  }

  void _onSocial(SocialProvider provider) => runSaveDataStep(
        () =>
            ref.read(authNotifierProvider.notifier).linkSocialAccount(provider),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(
          onPressed: _awaitingCode
              ? () => setState(() => _awaitingCode = false)
              : null,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingHorizontalXl,
          child: _awaitingCode ? _buildCodeStep(context) : _buildForm(context),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthHeader(
            title: l10n.saveDataTitle,
            subtitle: l10n.saveDataSubtitle,
          ),
          AppTextField(
            controller: _emailController,
            label: l10n.authEmail,
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
            label: l10n.authPassword,
            validator: Validators.password,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _onContinueWithEmail(),
          ),
          AppSpacing.verticalXl,
          AppPrimaryButton(
            text: l10n.saveDataWithEmail,
            onPressed: _onContinueWithEmail,
            isLoading: busy,
          ),
          AppSpacing.verticalXl,
          Center(
            child: Text(
              l10n.commonOr.toUpperCase(),
              style: context.textTheme.labelSmall,
            ),
          ),
          AppSpacing.verticalXl,
          SocialLoginButtons(
            googleLabel: l10n.authLoginWithGoogle,
            appleLabel: l10n.authLoginWithApple,
            onGooglePressed:
                busy ? null : () => _onSocial(SocialProvider.google),
            onApplePressed: busy ? null : () => _onSocial(SocialProvider.apple),
          ),
          AppSpacing.verticalXl,
        ],
      ),
    );
  }

  Widget _buildCodeStep(BuildContext context) {
    final l10n = context.l10n;
    final email = _pendingSwitch?.credential.email ?? _email;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthHeader(
          title: l10n.saveDataTitle,
          subtitle: l10n.saveDataCodeSent(email),
        ),
        AppOtpField(
          onChanged: (code) => setState(() => _code = code),
          onCompleted: (code) {
            setState(() => _code = code);
            _onVerify();
          },
        ),
        AppSpacing.verticalXl,
        AppPrimaryButton(
          text: l10n.saveDataVerify,
          onPressed: _code.length == 6 ? _onVerify : null,
          isLoading: busy,
        ),
      ],
    );
  }
}
