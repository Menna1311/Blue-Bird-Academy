import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';

class UserModel {
  String? id;
  String? email;
  String? password;

  UserModel({this.id, this.email, this.password});

  UserEntity toEntity() {
    return UserEntity(
      id: id ?? '',
      email: email ?? '',
      password: password ?? '',
    );
  }
}
