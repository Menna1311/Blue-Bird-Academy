import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/auth_service.dart';
import 'package:blue_bird/core/service/secure_storage_service.dart';
import 'package:blue_bird/features/intro/splash_screen/view_model/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._authService, this._secureStorageService)
      : super(SplashInitial());

  final AuthService _authService;
  final SecureStorageService _secureStorageService;

  Future<void> checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await _secureStorageService.getToken();

    if (token == null || token.isEmpty) {
      emit(SplashNavigateToLogin());
      return;
    }

    final result = await _authService.getLoggedInUser();

    switch (result) {
      case Success():
        final user = result.data!;
        if (user.role.toLowerCase() == 'parent') {
          emit(SplashNavigateToParent(user));
        } else {
          emit(SplashNavigateToTrainer(user));
        }
      case Fail():
        await _secureStorageService.deleteToken();
        emit(SplashNavigateToLogin());
    }
  }
}
