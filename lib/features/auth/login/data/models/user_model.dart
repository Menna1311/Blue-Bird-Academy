import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';

class UserModel {
  String? email;
  String? password;

  UserModel({this.email, this.password});

  UserEntity toEntity() {
    return UserEntity(
      email: email ?? '',
      password: password ?? '',
    );
  }
}
