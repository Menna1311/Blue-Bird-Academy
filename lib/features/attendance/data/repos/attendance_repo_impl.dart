import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/auth_service.dart';
import 'package:blue_bird/core/service/database_service.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_history_model.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/attendance/domain/repos/attendance_repo.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AttendanceRepo)
class AttendanceRepoImpl implements AttendanceRepo {
  final DatabaseService _firestoreService;
  final AuthService _authService;
  AttendanceRepoImpl(this._firestoreService, this._authService);
  @override
  Future<Result<bool>> markAttendance(
      String trainerId, String teamId, List<AttendanceModel> attendanceList) {
    return _firestoreService.markAttendance(trainerId, teamId, attendanceList);
  }

  @override
  Future<Result<List<AttendanceHistoryModel>>> getAttendanceHistory(
      String trainerId, String teamId) async {
    return _firestoreService.getAttendanceHistory(trainerId, teamId);
  }

  @override
  Future<Result<bool>> isAttendanceMarkedToday(
      String trainerId, String teamId) {
    return _firestoreService.isAttendanceMarkedToday(trainerId, teamId);
  }

  @override
  Future<Result<List<TeamModel>>> getAllTeams(String trainerId) {
    return _firestoreService.getTeams(trainerId);
  }

  @override
  Future<Result<UserEntity>> getLoggedInUser() {
    return _authService.getLoggedInUser();
  }
}
