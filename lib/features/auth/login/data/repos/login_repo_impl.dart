import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/execute_secure_storage.dart';
import 'package:blue_bird/core/service/firebase_auth_service.dart';
import 'package:blue_bird/core/service/secure_storage_service.dart';
import 'package:blue_bird/features/auth/login/data/models/user_model.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:blue_bird/features/auth/login/domain/repo/login_repod.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginRepo)
class LoginRepoImpl extends LoginRepo {
  final FirebaseAuthService _firebaseAuth;
  final SecureStorageService _secureStorageService;
  LoginRepoImpl(this._firebaseAuth, this._secureStorageService);

  @override
  Future<Result<UserEntity>> login(String email, String password) async {
    final result = await _firebaseAuth.login(email: email, password: password);

    if (result is Success<UserModel>) {
      final entity = (result).data!.toEntity();
      return Success<UserEntity>(entity);
    } else {
      return Fail<UserEntity>((result as Fail<UserModel>).exception!);
    }
  }

  @override
  Future<Result<bool>> setUserToken(String token) {
    return executeSecureStorage(() => _secureStorageService.setToken(token));
  }

  @override
  Future<Result<bool>> checkUserToken() async {
    final result =
        await executeSecureStorage(() => _secureStorageService.getToken());

    if (result is Success<String?>) {
      final token = result.data;
      if (token != null && token.isNotEmpty) {
        return Success(true);
      } else {
        return Success(false);
      }
    } else {
      return Success(false); // treat errors as no token
    }
  }
}
