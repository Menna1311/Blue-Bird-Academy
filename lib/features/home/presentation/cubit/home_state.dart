part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class SessionLoaded extends HomeState {
  final SessionEntity sessions;

  SessionLoaded(this.sessions);
}

final class SessionError extends HomeState {
  final Exception exception;

  SessionError(this.exception);
}

final class SessionLoading extends HomeState {}

final class SessionsLoaded extends HomeState {
  final List<SessionEntity> sessions;

  SessionsLoaded(this.sessions);
}
