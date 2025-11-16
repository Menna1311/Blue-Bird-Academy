part of 'attendance_cubit.dart';

@immutable
sealed class AttendanceState {}

final class AttendanceInitial extends AttendanceState {}

final class AttendanceLoading extends AttendanceState {}

final class AttendanceSuccess extends AttendanceState {}

final class AttendanceError extends AttendanceState {
  final String message;
  AttendanceError({required this.message});
}

final class AttendancePlayersLoaded extends AttendanceState {
  final List<AttendanceModel> players;

  AttendancePlayersLoaded(this.players);
}
