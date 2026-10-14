import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_outcome.freezed.dart';

/// What happened when the user asked to log out.
@freezed
sealed class LogoutOutcome with _$LogoutOutcome {
  /// Every change was backed up and the user is logged out.
  const factory LogoutOutcome.loggedOut() = LoggedOut;

  /// Logout did not happen: [unsavedChanges] changes are still only on
  /// this phone (offline, or the server refused them). Logging out now
  /// would lose them, so the user must confirm it explicitly with
  /// `AuthNotifier.discardChangesAndLogout`.
  const factory LogoutOutcome.blocked({required int unsavedChanges}) =
      LogoutBlocked;

  /// Logout could not be attempted, e.g. the backup check itself failed.
  /// The user stays logged in.
  const factory LogoutOutcome.failed(String message) = LogoutFailed;
}
