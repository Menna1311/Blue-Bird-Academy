import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/home/data/models/team_model.dart';

abstract class DatabaseService {
  Future<Result<bool>> addData(
      {required String path, required Map<String, dynamic> data});
  Future<List<TeamModel>> getTeams(String trainerId);
}
