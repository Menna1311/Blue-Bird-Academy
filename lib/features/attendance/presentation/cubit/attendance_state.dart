part of 'attendance_cubit.dart';

abstract class AttendanceState {
  const AttendanceState();

  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceUserLoading extends AttendanceState {}

class AttendanceUserLoaded extends AttendanceState {
  final UserEntity user;
  const AttendanceUserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class AttendanceUserError extends AttendanceState {
  final String message;
  const AttendanceUserError(this.message);

  @override
  List<Object> get props => [message];
}

class AttendanceTeamsLoading extends AttendanceState {}

class AttendanceTeamsLoaded extends AttendanceState {
  final List<TeamModel> teams;
  const AttendanceTeamsLoaded(this.teams);

  @override
  List<Object> get props => [teams];
}

class AttendanceTeamsError extends AttendanceState {
  final String message;
  const AttendanceTeamsError(this.message);

  @override
  List<Object> get props => [message];
}

class AttendanceLoading extends AttendanceState {}

class AttendanceReady extends AttendanceState {}

class AttendanceStatusChanged extends AttendanceState {}

class AttendanceAlreadyMarked extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {}

class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError(this.message);

  @override
  List<Object> get props => [message];
}

class AttendanceHistoryLoading extends AttendanceState {}

class AttendanceHistoryLoaded extends AttendanceState {
  final List<AttendanceHistoryModel> history;
  const AttendanceHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class AttendanceHistoryError extends AttendanceState {
  final String message;
  const AttendanceHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
