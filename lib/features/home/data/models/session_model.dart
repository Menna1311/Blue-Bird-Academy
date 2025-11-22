import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:blue_bird/features/home/domain/entities/session_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final String id;
  final String day;
  final String date;
  final Timestamp time;
  final String status;
  final List<dynamic> players; // Add players field>
  SessionModel({
    required this.id,
    required this.day,
    required this.date,
    required this.time,
    required this.status,
    required this.players,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'date': date,
      'time': time,
      'status': status,
      'players': players,
    };
  }

  factory SessionModel.fromFirestore(Map<String, dynamic> data, String id) {
    return SessionModel(
      id: id,
      day: data['day'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? Timestamp.now(),
      status: data['status'] ?? 'upcoming',
      players: data['players'] ?? [],
    );
  }

  /// 🔥 Mapper → Convert Model to Entity
  SessionEntity toEntity() {
    return SessionEntity(
      id: id,
      day: day,
      date: date,
      time: time,
      status: status,
      players: players,
    );
  }
}
