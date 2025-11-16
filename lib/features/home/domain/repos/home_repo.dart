import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/home/domain/entities/session_entity.dart';

abstract class HomeRepo {
  Future<Result<SessionEntity>> getSession(
      String trainerId, String teamId, String sessionId);
  Future<Result<List<SessionEntity>>> getSessions(
      String trainerId, String teamId);
}
