import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/auth/reset_password/domain/repo/reset_password_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'reset_password_state.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._resetPasswordRepo) : super(ResetPasswordInitial());
  final ResetPasswordRepo _resetPasswordRepo;
  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoading());
    final result = await _resetPasswordRepo.resetPassword(email);

    switch (result) {
      case Success<void>():
        emit(ResetPasswordSuccess());
        break;
      case Fail<void>():
        emit(ResetPasswordError(message: result.exception!.toString()));
        break;
    }
  }
}
