import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/database_service.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/attendance/domain/repos/attendance_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AttendanceRepo)
class AttendanceRepoImpl implements AttendanceRepo {
  final DatabaseService _firestoreService;
  AttendanceRepoImpl(this._firestoreService);
  @override
  Future<Result<bool>> markAttendance(String trainerId, String teamId,
      String sessionId, List<AttendanceModel> attendanceList) {
    return _firestoreService.markAttendance(
        trainerId, teamId, sessionId, attendanceList);
  }
}
