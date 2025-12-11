import 'package:bloc/bloc.dart';
import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:blue_bird/features/auth/login/domain/repo/login_repod.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'login_cubit_state.dart';

@injectable
class LoginCubitCubit extends Cubit<LoginCubitState> {
  LoginCubitCubit(this._loginRepo) : super(LoginCubitInitial());
  final LoginRepo _loginRepo;
  Future<void> checkUserToken() async {
    emit(LoginCubitLoading()); // show loading animation
    final result = await _loginRepo.checkUserToken();
    switch (result) {
      case Success<bool>():
        if (result.data == true) {
          emit(TokenChecked()); // token exists → navigate
        } else {
          emit(NoToken()); // no token → show login
        }
      case Fail<bool>():
        emit(LoginCubitError(result.exception!.toString()));
        break;
    }
  }

  Future<void> login(String email, String password) async {
    emit(LoginCubitLoading());
    await Future.delayed(const Duration(seconds: 2));
    final result = await _loginRepo.login(email, password);
    switch (result) {
      case Success<UserEntity>():
        final user = result.data!;
        emit(LoginCubitSuccess(user));
        final userToken = await _loginRepo.setUserToken(user.id);
        if (userToken is Success<bool>) {
          if (userToken.data == true) {
            print('Token: ${userToken.data}'); // token exists → navigate
          }
        }

        break;

      case Fail<UserEntity>():
        emit(LoginCubitError(result.exception!.toString()));
        break;
    }
  }
}
