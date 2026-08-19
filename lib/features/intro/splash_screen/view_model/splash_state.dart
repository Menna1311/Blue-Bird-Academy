import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';

abstract class SplashState {}

final class SplashInitial extends SplashState {}

final class SplashNavigateToLogin extends SplashState {}

final class SplashNavigateToTrainer extends SplashState {
  final UserEntity user;
  SplashNavigateToTrainer(this.user);
}

final class SplashNavigateToParent extends SplashState {
  final UserEntity user;
  SplashNavigateToParent(this.user);
}
