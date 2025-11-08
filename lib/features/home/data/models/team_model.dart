import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModelHome {
  final String id;
  final String teamName;
  final int teamAge;
  final int numberOfPlayers;
  final DateTime? nextSessionDate;

  TeamModelHome({
    required this.id,
    required this.teamName,
    required this.teamAge,
    required this.numberOfPlayers,
    this.nextSessionDate,
  });

  factory TeamModelHome.fromFirestore(Map<String, dynamic> data, String id) {
    return TeamModelHome(
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
