import 'package:blue_bird/core/common/result.dart';

abstract class ResetPasswordRepo {
  Future<Result<void>> resetPassword(String email);
}
