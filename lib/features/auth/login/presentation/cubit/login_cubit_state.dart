part of 'login_cubit_cubit.dart';

@immutable
sealed class LoginCubitState {}

final class LoginCubitInitial extends LoginCubitState {}

final class LoginCubitLoading extends LoginCubitState {}

final class LoginCubitError extends LoginCubitState {
  final String message;
  LoginCubitError(this.message);
}

final class LoginCubitSuccess extends LoginCubitState {
  final UserEntity user;
  LoginCubitSuccess(this.user);
}
