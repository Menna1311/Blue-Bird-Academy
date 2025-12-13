import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/database_service.dart';
import 'package:blue_bird/core/service/execute_secure_storage.dart';
import 'package:blue_bird/core/service/firebase_auth_service.dart';
import 'package:blue_bird/core/service/secure_storage_service.dart';
import 'package:blue_bird/features/auth/login/data/models/user_model.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:blue_bird/features/auth/register/domain/repos/register_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RegisterRepo)
class RegisterRepoImpl implements RegisterRepo {
  final FirebaseAuthService _firebaseAuth;
  final DatabaseService _databaseService;
  final SecureStorageService _secureStorageService;
  RegisterRepoImpl(
      this._firebaseAuth, this._databaseService, this._secureStorageService);

  @override
  Future<Result<UserEntity>> register(String email, String password) async {
    final result =
        await _firebaseAuth.register(email: email, password: password);

    if (result is Success<UserModel>) {
      final entity = result.data!.toEntity();
      await addData(user: entity);
      return Success(entity);
    } else {
      return Fail((result as Fail<UserModel>).exception!);
    }
  }

  @override
  Future<Result<bool>> setUserToken(String token) {
    return executeSecureStorage(() => _secureStorageService.setToken(token));
  }

  @override
  Future addData({required UserEntity user}) {
    return _databaseService.addData(path: 'trainers', data: user.toMap());
  }
}
