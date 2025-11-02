import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  final String id;
  final String teamName;
  final int teamAge;
  final int numberOfPlayers;
  final DateTime? nextSessionDate;

  TeamModel({
    required this.id,
    required this.teamName,
    required this.teamAge,
    required this.numberOfPlayers,
    this.nextSessionDate,
  });

  factory TeamModel.fromFirestore(Map<String, dynamic> data, String id) {
    return TeamModel(
      id: id,
      teamName: data['name'] ?? '',
      teamAge: data['age'] ?? '',
      numberOfPlayers: data['numberOfPlayers'] ?? 0,
      nextSessionDate: data['nextSessionDate'] != null
          ? (data['nextSessionDate'] as Timestamp).toDate()
          : null,
    );
  }
}
