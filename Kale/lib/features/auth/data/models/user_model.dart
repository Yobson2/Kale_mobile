import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data model for [User] with JSON serialization.
///
/// Maps between API JSON responses and the domain [User] entity.
@freezed
abstract class UserModel with _$UserModel {
  /// Creates a [UserModel].
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    required String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _UserModel;

  /// Creates a [UserModel] from JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts this model to a domain [User] entity.
  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        avatarUrl: avatarUrl,
      );

  /// Creates a [UserModel] from a domain [User] entity.
  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        avatarUrl: user.avatarUrl,
      );
}
