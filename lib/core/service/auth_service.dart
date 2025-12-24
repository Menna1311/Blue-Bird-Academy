import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/auth/login/data/models/user_model.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';

abstract class AuthService {
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  });

  Future<Result<UserModel>> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Result<UserEntity>> getLoggedInUser();

  Future<Result<void>> logout();
}
