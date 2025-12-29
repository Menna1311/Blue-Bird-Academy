import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/auth_service.dart';
import 'package:blue_bird/features/auth/reset_password/domain/repo/reset_password_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ResetPasswordRepo)
class ResetPasswordRepoImpl implements ResetPasswordRepo {
  final AuthService _authService;
  ResetPasswordRepoImpl(this._authService);
  @override
  Future<Result<void>> resetPassword(String email) {
    return _authService.resetPassword(email: email);
  }
}
