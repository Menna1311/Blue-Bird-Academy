import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/team_entity.dart';
import '../../domain/entities/player_entity.dart';

class TeamModel {
  final String id;
  final String trainerId;
  final String teamName;
  final String teamAgeCategory;
  final List<String> trainingDays;
  final DateTime trainingTime;
  final List<PlayerEntity> players;
  final DateTime createdAt;

  const TeamModel({
    required this.id,
    required this.trainerId,
    required this.teamName,
    required this.teamAgeCategory,
    required this.trainingDays,
    required this.trainingTime,
    required this.players,
    required this.createdAt,
  });

  /// 🔹 from Firestore map → Model
  factory TeamModel.fromMap(Map<String, dynamic> map, String id) {
    return TeamModel(
      id: id,
      trainerId: map['trainerId'] ?? '',
      teamName: map['teamName'] ?? '',
      teamAgeCategory: map['teamAgeCategory'] ?? '',
      trainingDays: List<String>.from(map['trainingDays'] ?? []),
      trainingTime:
          (map['trainingTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      players: (map['players'] as List<dynamic>? ?? [])
          .map((p) => PlayerEntity(
                name: p['name'] ?? '',
                jerseyNumber: p['jerseyNumber'] ?? '',
              ))
          .toList(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// 🔹 to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'trainerId': trainerId,
      'teamName': teamName,
      'teamAgeCategory': teamAgeCategory,
      'trainingDays': trainingDays,
      'trainingTime': trainingTime,
      'players': players
          .map((p) => {
                'name': p.name,
                'jerseyNumber': p.jerseyNumber,
              })
          .toList(),
      'createdAt': createdAt,
    };
  }

  /// 🔹 from domain entity → model
  factory TeamModel.fromEntity(TeamEntity entity) {
    return TeamModel(
      id: entity.id,
      trainerId: entity.trainerId,
      teamName: entity.teamName,
      teamAgeCategory: entity.teamAgeCategory,
      trainingDays: entity.trainingDays,
      trainingTime: entity.trainingTime,
      players: entity.players,
      createdAt: entity.createdAt,
    );
  }

  /// 🔹 from model → domain entity
  TeamEntity toEntity() {
    return TeamEntity(
      id: id,
      trainerId: trainerId,
      teamName: teamName,
      teamAgeCategory: teamAgeCategory,
      trainingDays: trainingDays,
      trainingTime: trainingTime,
      players: players,
      createdAt: createdAt,
    );
  }
}
