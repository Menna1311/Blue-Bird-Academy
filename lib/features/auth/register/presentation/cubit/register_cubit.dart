import 'package:bloc/bloc.dart';
import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:blue_bird/features/auth/register/domain/repos/register_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._registerRepo) : super(RegisterInitial());

  final RegisterRepo _registerRepo;

  String email = '';
  String password = '';
  String username = '';
  void updateEmail(String value) => email = value;

  void updatePassword(String value) => password = value;

  void updateUsername(String value) => username = value;

  Future<void> submit() async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      emit(RegisterFail("Please fill all fields"));
      return;
    }

    emit(RegisterLoading());
    await Future.delayed(const Duration(seconds: 2));

    final result = await _registerRepo.register(email, password, username);

    switch (result) {
      case Success<UserEntity>():
        final user = result.data!;

        await _registerRepo.setUserToken(user.id);

        emit(RegisterSuccess(user));
        break;

      case Fail<UserEntity>():
        emit(RegisterFail(result.exception.toString()));
        break;
    }
  }
}
