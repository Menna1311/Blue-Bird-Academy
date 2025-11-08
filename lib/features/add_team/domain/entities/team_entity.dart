import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';

class TeamEntity {
  final String id;
  final String trainerId;
  final String teamName;
  final String teamAgeCategory;
  final List<String> trainingDays;
  final DateTime trainingTime;
  final List<PlayerEntity> players;
  final DateTime createdAt;

  const TeamEntity({
    required this.id,
    required this.trainerId,
    required this.teamName,
    required this.teamAgeCategory,
    required this.trainingDays,
    required this.trainingTime,
    required this.players,
    required this.createdAt,
  });
}
