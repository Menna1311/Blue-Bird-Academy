import 'package:bloc/bloc.dart';
import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_history_model.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/attendance/domain/repos/attendance_repo.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

part 'attendance_state.dart';

@injectable
class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit(this._attendanceRepo) : super(AttendanceInitial());
  final AttendanceRepo _attendanceRepo;

  UserEntity? currentUser;
  Map<String, String> selectedStatuses = {};

  // Get current logged in user
  Future<void> getLoggedInUser() async {
    emit(AttendanceUserLoading());
    final result = await _attendanceRepo.getLoggedInUser();
    switch (result) {
      case Success<UserEntity>():
        currentUser = result.data;
        emit(AttendanceUserLoaded(result.data!));
        break;
      case Fail<UserEntity>():
        emit(AttendanceUserError(result.exception!.toString()));
        break;
    }
  }

  // Get teams for the current user
  Future<void> getTeams(String trainerId) async {
    emit(AttendanceTeamsLoading());
    final result = await _attendanceRepo.getAllTeams(trainerId);
    if (result is Success<List<TeamModel>>) {
      emit(AttendanceTeamsLoaded(result.data!));
    } else if (result is Fail<List<TeamModel>>) {
      emit(AttendanceTeamsError(result.exception!.toString()));
    }
  }

  // ... rest of the existing methods remain the same
  Future<void> initAttendance(
    String trainerId,
    String teamId,
    List<PlayerEntity> players,
  ) async {
    emit(AttendanceLoading());

    final result = await _attendanceRepo.isAttendanceMarkedToday(
      trainerId,
      teamId,
    );

    if (result is Success<bool> && result.data == true) {
      emit(AttendanceAlreadyMarked());
    } else {
      selectedStatuses = {
        for (final player in players) player.id: 'present',
      };
      emit(AttendanceReady());
    }
  }

  void updateStatus(String playerId, String status) {
    selectedStatuses[playerId] = status;
    emit(AttendanceStatusChanged());
  }

  Future<void> checkAttendance(
    String trainerId,
    String teamId,
  ) async {
    emit(AttendanceLoading());

    final result = await _attendanceRepo.isAttendanceMarkedToday(
      trainerId,
      teamId,
    );

    if (result is Success<bool> && result.data == true) {
      emit(AttendanceAlreadyMarked());
    } else {
      emit(AttendanceInitial());
    }
  }

  Future<void> markAttendance(String trainerId, String teamId,
      List<AttendanceModel> attendanceList) async {
    emit(AttendanceLoading());
    final result =
        await _attendanceRepo.markAttendance(trainerId, teamId, attendanceList);

    switch (result) {
      case Success<bool>():
        emit(AttendanceSuccess());
        break;
      case Fail<bool>():
        emit(AttendanceError(result.exception!.toString()));
        break;
    }
  }

  Future<void> getHistory(String trainerId, String teamId) async {
    emit(AttendanceHistoryLoading());
    try {
      final data =
          await _attendanceRepo.getAttendanceHistory(trainerId, teamId);
      if (data is Success<List<AttendanceHistoryModel>>) {
        emit(AttendanceHistoryLoaded(data.data!));
      } else if (data is Fail<List<AttendanceHistoryModel>>) {
        emit(AttendanceHistoryError(data.exception!.toString()));
      }
    } catch (e) {
      emit(AttendanceHistoryError(e.toString()));
    }
  }
}
