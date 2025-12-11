import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceHistoryModel {
  final Timestamp takenAt;
  final String playerName;
  final String status;

  AttendanceHistoryModel({
    required this.takenAt,
    required this.playerName,
    required this.status,
  });
}
