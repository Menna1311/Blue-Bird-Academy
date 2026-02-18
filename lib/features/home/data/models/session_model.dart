import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blue_bird/features/home/domain/entities/session_entity.dart';

class SessionModel {
  final String id;
  final String teamId;
  final String trainerId;
  final DateTime sessionDateTime;
  final String teamName;
  final String teamAgeCategory;
  final String status;
  final List<String> attendance;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  SessionModel({
    required this.id,
    required this.teamId,
    required this.trainerId,
    required this.sessionDateTime,
    required this.teamName,
    required this.teamAgeCategory,
    required this.status,
    required this.attendance,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SessionModel.fromMap(Map<String, dynamic> map, String id) {
    return SessionModel(
      id: id,
      teamId: map['teamId'] ?? '',
      trainerId: map['trainerId'] ?? '',
      sessionDateTime:
          (map['sessionDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      teamName: map['teamName'] ?? '',
      teamAgeCategory: map['teamAgeCategory'] ?? '',
      status: map['status'] ?? 'scheduled',
      attendance: List<String>.from(map['attendance'] ?? []),
      notes: map['notes'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teamId': teamId,
      'trainerId': trainerId,
      'sessionDateTime': sessionDateTime,
      'teamName': teamName,
      'teamAgeCategory': teamAgeCategory,
      'status': status,
      'attendance': attendance,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// 🔥 Mapper: Model → Entity
  SessionEntity toEntity() {
    final dateTime = sessionDateTime;

    return SessionEntity(
      id: id,
      day: _getDayName(dateTime),
      date: DateTime(dateTime.year, dateTime.month, dateTime.day),
      time: Timestamp.fromDate(dateTime),
      status: status,
      players: attendance,
    );
  }

  /// Helper method to extract day name
  String _getDayName(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[date.weekday - 1];
  }
}
