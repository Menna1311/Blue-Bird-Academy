import 'package:bloc/bloc.dart';
import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_history_model.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/attendance/domain/repos/attendance_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'attendance_state.dart';

@injectable
class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit(this._attendanceRepo) : super(AttendanceInitial());
  final AttendanceRepo _attendanceRepo;

  Map<String, String> selectedStatuses = {};

  void initializeStatuses(List<PlayerEntity> players) {
    selectedStatuses = {for (var p in players) p.id: 'present'};
    emit(AttendanceStatusChanged());
  }

  void updateStatus(String playerId, String status) {
    selectedStatuses[playerId] = status;
    emit(AttendanceStatusChanged());
  }

  Future<void> markAttendance(String trainerId, String teamId, String sessionId,
      List<AttendanceModel> attendanceList) async {
    emit(AttendanceLoading());
    final result = await _attendanceRepo.markAttendance(
        trainerId, teamId, sessionId, attendanceList);

    switch (result) {
      case Success<bool>():
        emit(AttendanceSuccess());
        break;
      case Fail<bool>():
        emit(AttendanceError(message: result.exception!.toString()));
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
