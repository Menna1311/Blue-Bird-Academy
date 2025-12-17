import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/database_service.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
import 'package:blue_bird/features/add_team/domain/entities/team_entity.dart';
import 'package:blue_bird/features/home/data/models/session_model.dart';
import 'package:blue_bird/features/home/domain/entities/session_entity.dart';
import 'package:blue_bird/features/home/domain/repos/home_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final DatabaseService _firestoreService;

  HomeRepoImpl(this._firestoreService);

  @override
  Future<Result<SessionEntity>> getSession(
      String trainerId, String teamId, String sessionId) {
    return _firestoreService
        .getSession(trainerId, teamId, sessionId)
        .then((result) {
      if (result is Success<SessionModel>) {
        final SessionModel model = (result).data!;
        final SessionEntity entity = model.toEntity();
        return Success<SessionEntity>(entity);
      }

      if (result is Fail) {
        final error = (result as Fail).exception;
        return Fail<SessionEntity>(error);
      }

      return Fail<SessionEntity>(Exception('Unknown error'));
    });
  }

  @override
  Future<Result<List<SessionEntity>>> getSessions(
      String trainerId, String teamId) {
    return _firestoreService.getSessions(trainerId, teamId).then((result) {
      if (result is Success<List<SessionModel>>) {
        final List<SessionModel> models = (result).data!;
        final List<SessionEntity> entities =
            models.map((model) => model.toEntity()).toList();
        return Success<List<SessionEntity>>(entities);
      }

      if (result is Fail) {
        final error = (result as Fail).exception;
        return Fail<List<SessionEntity>>(error);
      }

      return Fail<List<SessionEntity>>(Exception('Unknown error'));
    });
  }

  @override
  Future<Result<List<TeamEntity>>> getTeams(String trainerId) {
    return _firestoreService.getTeams(trainerId).then((result) {
      if (result is Success<List<TeamModel>>) {
        final List<TeamModel> models = result.data ?? [];

        final List<TeamEntity> entities =
            models.map((model) => model.toEntity()).toList();

        return Success<List<TeamEntity>>(entities);
      }

      if (result is Fail) {
        final error = (result as Fail).exception;
        return Fail<List<TeamEntity>>(error);
      }

      return Fail<List<TeamEntity>>(Exception('Unknown error'));
    });
  }
}
