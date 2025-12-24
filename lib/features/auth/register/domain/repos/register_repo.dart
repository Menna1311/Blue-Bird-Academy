import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';

abstract class RegisterRepo {
  Future<Result<UserEntity>> register(
      String email, String password, String username);
  Future<Result<bool>> setUserToken(String token);
  Future addData({required UserEntity user});
}
