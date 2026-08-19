import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_history_model.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';

abstract class AttendanceRepo {
  Future<Result<bool>> markAttendance(
    String trainerId,
    String teamId,
    String sessionId,
    List<AttendanceModel> attendanceList,
  );

  Future<Result<List<AttendanceHistoryModel>>> getAttendanceHistory(
    String trainerId,
    String teamId,
  );

  Future<Result<List<TeamModel>>> getAllTeams(
    String trainerId,
  );

  Future<Result<UserEntity>> getLoggedInUser();
}
