import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_history_model.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/home/data/models/session_model.dart';

abstract class DatabaseService {
  Future<Result<bool>> addData(
      {required String path, required Map<String, dynamic> data});
  Future<Result<List<TeamModel>>> getTeams(String trainerId);
  Future<Result<bool>> addTeam(String trainerId, TeamModel team);
  Future<Result<bool>> markAttendance(String trainerId, String teamId,
      String sessionId, List<AttendanceModel> attendanceList);
  Future<Result<SessionModel>> getSession(
      String trainerId, String teamId, String sessionId);
  Future<Result<List<SessionModel>>> getSessions(
      String trainerId, String teamId);
  Future<Result<List<AttendanceHistoryModel>>> getAttendanceHistory(
    String trainerId,
    String teamId,
  );
}
