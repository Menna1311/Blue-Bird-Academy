import 'package:cloud_firestore/cloud_firestore.dart';

class SessionEntity {
  final String id;
  final String day;
  final Timestamp date;
  final Timestamp time;
  final String status;
  final List<dynamic>? players; // Convert to List<Map<String, dynamic>>
  SessionEntity({
    required this.id,
    required this.day,
    required this.date,
    required this.time,
    required this.status,
    this.players,
  });
}
