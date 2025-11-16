import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';

abstract class AttendanceRepo {
  Future<Result<bool>> markAttendance(String trainerId, String teamId,
      String sessionId, List<AttendanceModel> attendanceList);
}
