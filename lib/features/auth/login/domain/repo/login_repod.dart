import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';

abstract class LoginRepo {
  Future<Result<UserEntity>> login(String email, String password);
  Future<Result<bool>> setUserToken(String token);
  Future<Result<bool>> checkUserToken();
}
