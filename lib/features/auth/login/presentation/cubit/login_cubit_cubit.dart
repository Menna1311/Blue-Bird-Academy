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

  String email = '';
  String password = '';

  void updateEmail(String value) {
    email = value;
  }

  void updatePassword(String value) {
    password = value;
  }

  Future<void> checkUserToken() async {
    emit(LoginCubitLoading());
    final result = await _loginRepo.checkUserToken();
    switch (result) {
      case Success<bool>():
        if (result.data == true) {
          emit(TokenChecked());
        } else {
          emit(NoToken());
        }
      case Fail<bool>():
        emit(LoginCubitError(result.exception!.toString()));
        break;
    }
  }

  Future<void> submit() async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginCubitError('Please fill all fields'));
      return;
    }

    emit(LoginCubitLoading());
    await Future.delayed(const Duration(seconds: 2));
    final result = await _loginRepo.login(email, password);
    switch (result) {
      case Success<UserEntity>():
        final user = result.data!;
        emit(LoginCubitSuccess(user));
        await _loginRepo.setUserToken(user.id);
        break;
      case Fail<UserEntity>():
        emit(LoginCubitError(result.exception!.toString()));
        break;
    }
  }
}
