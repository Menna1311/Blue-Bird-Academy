import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';

abstract class AddTeamRepo {
  Future<Result<bool>> addTeam(String trainerId, TeamModel addTeamRequest);
}
