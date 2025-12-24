import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';

class UserModel {
  String? id;
  String? email;
  String? password;
  String? displayName;
  UserModel({this.id, this.email, this.password, this.displayName});

  UserEntity toEntity() {
    return UserEntity(
      id: id ?? '',
      email: email ?? '',
      desplayName: displayName ?? '',
    );
  }
}
