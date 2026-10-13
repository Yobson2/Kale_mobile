import 'package:flutter/foundation.dart';

/// Domain entity representing an authenticated user.
///
/// This is a pure domain object with no framework dependencies.
@immutable
class User {
  /// Creates a [User].
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.isAnonymous = false,
  });

  /// Unique identifier.
  final String id;

  /// User email address.
  final String email;

  /// Display name.
  final String name;

  /// Optional avatar image URL.
  final String? avatarUrl;

  /// Whether this account is anonymous: no email or social identity is
  /// linked yet. Anonymous users are authenticated and sync like anyone
  /// else, but can never sign back in once they log out.
  final bool isAnonymous;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          avatarUrl == other.avatarUrl &&
          isAnonymous == other.isAnonymous;

  @override
  int get hashCode => Object.hash(id, email, name, avatarUrl, isAnonymous);

  @override
  String toString() =>
      'User(id: $id, email: $email, name: $name, isAnonymous: $isAnonymous)';
}
