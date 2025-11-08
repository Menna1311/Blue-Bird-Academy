import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/database_service.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
import 'package:blue_bird/features/add_team/domain/repos/add_team_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddTeamRepo)
class AddTeamRepoImpl extends AddTeamRepo {
  final DatabaseService _databaseService;

  AddTeamRepoImpl(this._databaseService);

  @override
  Future<Result<bool>> addTeam(String trainerId, TeamModel addTeamRequest) {
    return _databaseService.addTeam(trainerId, addTeamRequest);
  }
}
