import 'package:bloc/bloc.dart';
import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/attendance/domain/repos/attendance_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'attendance_state.dart';

@injectable
class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit(this._attendanceRepo) : super(AttendanceInitial());
  final AttendanceRepo _attendanceRepo;

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
}
