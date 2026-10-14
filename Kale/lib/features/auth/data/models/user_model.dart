import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/features/auth/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data model for [User] with JSON serialization.
///
/// Maps between API JSON responses and the domain [User] entity.
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_anonymous') @Default(false) bool isAnonymous,
  }) = _UserModel;

  /// Creates a [UserModel] from a domain [User] entity.
  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        avatarUrl: user.avatarUrl,
        isAnonymous: user.isAnonymous,
      );

  /// Creates a [UserModel].
  const UserModel._();

  /// Creates a [UserModel] from JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts this model to a domain [User] entity.
  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        avatarUrl: avatarUrl,
        isAnonymous: isAnonymous,
      );
}
