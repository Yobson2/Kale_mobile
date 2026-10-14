import 'package:kale/features/auth/domain/entities/account_link.dart';
import 'package:meta/meta.dart';

/// What happened at a step of saving a guest's data to a real account.
@immutable
sealed class SaveDataOutcome {
  const SaveDataOutcome();
}

/// The guest is now a permanent user, on this account or the existing one
/// they chose. The auth state holds the new user.
final class SaveDataDone extends SaveDataOutcome {
  /// Creates a [SaveDataDone].
  const SaveDataDone();
}

/// A code was sent by email; the user enters it next.
final class SaveDataCodeSent extends SaveDataOutcome {
  /// Creates a [SaveDataCodeSent].
  const SaveDataCodeSent();
}

/// The identity belongs to another Kalé account: the user chooses what to
/// do with their [entryCount] entries. Nothing changed yet.
final class SaveDataIdentityInUse extends SaveDataOutcome {
  /// Creates a [SaveDataIdentityInUse].
  const SaveDataIdentityInUse({
    required this.credential,
    required this.entryCount,
  });

  /// How to sign in to the existing account.
  final AccountCredential credential;

  /// How many of the guest's entries are on this device.
  final int entryCount;
}

/// The step failed; nothing changed.
final class SaveDataFailed extends SaveDataOutcome {
  /// Creates a [SaveDataFailed].
  const SaveDataFailed(this.message);

  /// Why, for the snackbar.
  final String message;
}
