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
  final List<PlayerEntity> players;

  AttendancePlayersLoaded(this.players);
}

class AttendanceHistoryInitial extends AttendanceState {}

class AttendanceHistoryLoading extends AttendanceState {}

class AttendanceHistoryLoaded extends AttendanceState {
  final List<AttendanceHistoryModel> history;
  AttendanceHistoryLoaded(this.history);
}

class AttendanceHistoryError extends AttendanceState {
  final String message;
  AttendanceHistoryError(this.message);
}
