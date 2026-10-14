import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:meta/meta.dart';

/// How to sign in to an existing Kalé account that a guest tried to link
/// to. Kept by the app while the user chooses what to do with their guest
/// data.
@immutable
sealed class AccountCredential {
  const AccountCredential();
}

/// The account's email: signing in needs a code sent to it.
final class EmailCodeCredential extends AccountCredential {
  /// Creates an [EmailCodeCredential].
  const EmailCodeCredential(this.email);

  /// The account's email.
  final String email;
}

/// An email and password typed on the login page.
final class PasswordCredential extends AccountCredential {
  /// Creates a [PasswordCredential].
  const PasswordCredential({required this.email, required this.password});

  /// The account's email.
  final String email;

  /// The account's password.
  final String password;
}

/// A Google or Apple sign-in, captured when linking it failed.
final class IdTokenCredential extends AccountCredential {
  /// Creates an [IdTokenCredential].
  const IdTokenCredential({
    required this.provider,
    required this.idToken,
    this.accessToken,
    this.rawNonce,
  });

  /// Who issued [idToken].
  final SocialProvider provider;

  /// The provider's ID token.
  final String idToken;

  /// Google's access token, when there is one.
  final String? accessToken;

  /// Apple's raw nonce, hashed into [idToken].
  final String? rawNonce;
}

/// A social identity provider.
enum SocialProvider {
  /// Sign in with Google.
  google,

  /// Sign in with Apple.
  apple,
}

/// The result of linking an identity to the signed-in guest.
@immutable
sealed class LinkResult {
  const LinkResult();
}

/// The identity is now the guest's: same user id, no longer anonymous,
/// every local entry kept.
final class AccountLinked extends LinkResult {
  /// Creates an [AccountLinked].
  const AccountLinked(this.user);

  /// The upgraded user.
  final User user;
}

/// The identity already belongs to another Kalé account. Nothing changed:
/// the guest session and its data are as they were.
final class IdentityInUse extends LinkResult {
  /// Creates an [IdentityInUse].
  const IdentityInUse(this.credential);

  /// How to sign in to that account, if the user chooses to.
  final AccountCredential credential;
}
