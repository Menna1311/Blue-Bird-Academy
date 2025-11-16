import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/database_service.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
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
      final teamRef = firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('teams')
          .doc();

      await teamRef.set({
        ...team.toMap(),
        'id': teamRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _generateTeamSessions(
        trainerId: trainerId,
        teamId: teamRef.id,
        trainingDays: team.trainingDays,
        trainingTime: team.trainingTime,
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
  }) async {
    final now = DateTime.now();
    final sessionsCollection = firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('teams')
        .doc(teamId)
        .collection('sessions');

    for (String day in trainingDays) {
      final nextDate = _getNextDateForDay(day, now);

      final sessionData = {
        'day': day,
        'date': "${nextDate.year}-${nextDate.month}-${nextDate.day}",
        'time': trainingTime,
        'status': "upcoming",
        'createdAt': FieldValue.serverTimestamp(),
      };

      await sessionsCollection.add(sessionData);
    }
  }

  DateTime _getNextDateForDay(String dayName, DateTime fromDate) {
    final weekdays = {
      "Monday": DateTime.monday,
      "Tuesday": DateTime.tuesday,
      "Wednesday": DateTime.wednesday,
      "Thursday": DateTime.thursday,
      "Friday": DateTime.friday,
      "Saturday": DateTime.saturday,
      "Sunday": DateTime.sunday,
    };

    final targetWeekday = weekdays[dayName] ?? DateTime.monday;
    int daysToAdd = (targetWeekday - fromDate.weekday) % 7;
    if (daysToAdd <= 0) daysToAdd += 7;

    return fromDate.add(Duration(days: daysToAdd));
  }

  @override
  Future<Result<bool>> markAttendance(String trainerId, String teamId,
      String sessionId, List<AttendanceModel> attendanceList) async {
    {
      final attendanceCollection = firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('teams')
          .doc(teamId)
          .collection('sessions')
          .doc(sessionId)
          .collection('attendance');

      for (final attendance in attendanceList) {
        await attendanceCollection.doc(attendance.playerId).set({
          ...attendance.toMap(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
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

  Future<List<Map<String, dynamic>>> getPlayers(
      String trainerId, String teamId) async {
    final snapshot = await firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('teams')
        .doc(teamId)
        .collection('players')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
