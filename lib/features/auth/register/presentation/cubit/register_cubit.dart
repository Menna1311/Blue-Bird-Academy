import 'package:bloc/bloc.dart';
import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:blue_bird/features/auth/register/domain/repos/register_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.registerRepo) : super(RegisterInitial());
  final RegisterRepo registerRepo;

  Future<void> regiser(String email, String password) async {
    emit(RegisterLoading());
    final result = await registerRepo.register(email, password);
    switch (result) {
      case Success<UserEntity>():
        emit(RegisterSuccess(result.data!));
        break;
      case Fail<UserEntity>():
        emit(RegisterFail(result.exception!.toString()));
        break;
    }
  }
}
