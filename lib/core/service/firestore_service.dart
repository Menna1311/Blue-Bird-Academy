import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/database_service.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_history_model.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/home/data/models/session_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DatabaseService)
class FirestoreService implements DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Result<bool>> addData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return Fail(Exception('No authenticated user found'));

      await firestore.collection(path).doc(user.uid).set({
        ...data,
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Success(true);
    } on FirebaseException catch (e) {
      return Fail(e);
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }

  @override
  Future<List<TeamModel>> getTeams(String trainerId) async {
    final snapshot = await firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('teams')
        .get();

    return snapshot.docs
        .map((doc) =>
            TeamModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  @override
  Future<Result<bool>> addTeam(String trainerId, TeamModel team) async {
    try {
      final teamRef = FirebaseFirestore.instance
          .collection('trainers')
          .doc(trainerId)
          .collection('teams')
          .doc();

      // Save team without player IDs
      await teamRef.set({
        ...team.toMap(),
        'id': teamRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Generate sessions with player IDs
      await _generateTeamSessions(
        trainerId: trainerId,
        teamId: teamRef.id,
        trainingDays: team.trainingDays,
        trainingTime: team.trainingTime,
        players: team.players,
      );

      return Success(true);
    } on FirebaseException catch (e) {
      return Fail(Exception('Failed to add team: ${e.message}'));
    } catch (e) {
      return Fail(Exception('Unexpected error: $e'));
    }
  }

  Future<void> _generateTeamSessions({
    required String trainerId,
    required String teamId,
    required List<String> trainingDays,
    required DateTime trainingTime,
    required List<PlayerEntity> players,
  }) async {
    final now = DateTime.now();
    final sessionsCollection = FirebaseFirestore.instance
        .collection('trainers')
        .doc(trainerId)
        .collection('teams')
        .doc(teamId)
        .collection('sessions');

    for (String day in trainingDays) {
      final nextDate = _getNextDateForDay(day, now);

      final sessionData = {
        'day': day,
        'date': Timestamp.fromDate(nextDate),
        'time': trainingTime,
        'status': "upcoming",
        'players': players
            .map((p) => {
                  'id': FirebaseFirestore.instance
                      .collection('dummy')
                      .doc()
                      .id, // unique ID per session
                  'name': p.name,
                  'jerseyNumber': p.jerseyNumber,
                  'attendance': false, // default attendance
                })
            .toList(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await sessionsCollection.add(sessionData);
    }
  }

  DateTime _getNextDateForDay(String weekday, DateTime fromDate) {
    const weekdaysMap = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };
    int targetWeekday = weekdaysMap[weekday] ?? 1;
    int daysAhead = (targetWeekday - fromDate.weekday + 7) % 7;
    if (daysAhead == 0) daysAhead = 7;
    return fromDate.add(Duration(days: daysAhead));
  }

  @override
  Future<Result<bool>> markAttendance(
    String trainerId,
    String teamId,
    String sessionId,
    List<AttendanceModel> attendanceList,
  ) async {
    final attendanceCollection = firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('teams')
        .doc(teamId)
        .collection('sessions')
        .doc(sessionId)
        .collection('attendance_records');

    final playersMap = {
      for (var a in attendanceList) a.playerId: a.toMap(),
    };

    await attendanceCollection.add({
      'players': playersMap,
      'takenAt': FieldValue.serverTimestamp(),
    });

    return Success(true);
  }

  @override
  Future<Result<SessionModel>> getSession(
      String trainerId, String teamId, String sessionId) async {
    try {
      final docSnapshot = await firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('teams')
          .doc(teamId)
          .collection('sessions')
          .doc(sessionId)
          .get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return Fail(Exception('Session not found'));
      }
      final session = SessionModel.fromFirestore(
          docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      return Success(session);
    } on FirebaseException catch (e) {
      return Fail(e);
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<SessionModel>>> getSessions(
      String trainerId, String teamId) async {
    try {
      final snapshot = await firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('teams')
          .doc(teamId)
          .collection('sessions')
          .orderBy('date')
          .get();

      final sessions = snapshot.docs
          .map((doc) => SessionModel.fromFirestore(
                doc.data(),
                doc.id,
              ))
          .toList();

      return Success(sessions);
    } on FirebaseException catch (e) {
      return Fail(Exception('Failed to load sessions: ${e.message}'));
    } catch (e) {
      return Fail(Exception('Unexpected error: $e'));
    }
  }

  @override
  Future<Result<List<AttendanceHistoryModel>>> getAttendanceHistory(
    String trainerId,
    String teamId,
  ) async {
    try {
      final sessions = await firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('teams')
          .doc(teamId)
          .collection('sessions')
          .get();

      List<AttendanceHistoryModel> history = [];

      for (var session in sessions.docs) {
        final recordsSnap = await session.reference
            .collection('attendance_records')
            .orderBy('takenAt', descending: true)
            .get();

        for (var record in recordsSnap.docs) {
          final takenAt = record['takenAt'] as Timestamp;
          final playersMap = record['players'] as Map<String, dynamic>;

          playersMap.forEach((_, playerData) {
            history.add(
              AttendanceHistoryModel(
                takenAt: takenAt,
                playerName: playerData['playerName'],
                status: playerData['status'],
              ),
            );
          });
        }
      }

      return Success(history);
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }
}
