import 'package:bloc/bloc.dart';
import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:blue_bird/features/auth/login/domain/repo/login_repod.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'login_cubit_state.dart';

@injectable
class LoginCubitCubit extends Cubit<LoginCubitState> {
  LoginCubitCubit(this.loginRepo) : super(LoginCubitInitial());
  final LoginRepo loginRepo;

  Future<void> login(String email, String password) async {
    emit(LoginCubitLoading());
    final result = await loginRepo.login(email, password);
    switch (result) {
      case Success<UserEntity>():
        emit(LoginCubitSuccess(result.data!));
        break;
      case Fail<UserEntity>():
        emit(LoginCubitError(result.exception!.toString()));
        break;
    }
  }
}
