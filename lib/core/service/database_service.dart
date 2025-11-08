import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
import 'package:blue_bird/features/home/data/models/team_model.dart';

abstract class DatabaseService {
  Future<Result<bool>> addData(
      {required String path, required Map<String, dynamic> data});
  Future<List<TeamModelHome>> getTeams(String trainerId);
  Future<Result<bool>> addTeam(String trainerId, TeamModel team);
}
