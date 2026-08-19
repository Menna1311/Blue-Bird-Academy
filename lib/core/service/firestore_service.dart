import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/database_service.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
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
      await firestore.collection(path).add({
        ...data,
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
  Future<Result<List<TeamModel>>> getTeams(String trainerId) async {
    final snapshot = await firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('teams')
        .get();

    final teams = snapshot.docs
        .map((doc) => TeamModel.fromMap(doc.data(), doc.id))
        .toList();

    return Success(teams);
  }

  @override
  Future<Result<bool>> addTeam(String trainerId, TeamModel team) async {
    try {
      final teamRef = FirebaseFirestore.instance
          .collection('trainers')
          .doc(trainerId)
          .collection('teams')
          .doc();

      // Add the team to Firestore
      await teamRef.set({
        ...team.toMap(),
        'id': teamRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Create sessions for the month
      await _createSessionsForMonth(trainerId, teamRef.id, team);

      return Success(true);
    } on FirebaseException catch (e) {
      return Fail(Exception('Failed to add team: ${e.message}'));
    } catch (e) {
      return Fail(Exception('Unexpected error: $e'));
    }
  }

  Future<void> _createSessionsForMonth(
      String trainerId, String teamId, TeamModel team) async {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    // Get the number of days in current month
    final daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;

    // Convert training days to DateTime weekdays (Monday = 1, Sunday = 7)
    final trainingWeekdays = team.trainingDays.map((day) {
      switch (day.toLowerCase()) {
        case 'monday':
          return 1;
        case 'tuesday':
          return 2;
        case 'wednesday':
          return 3;
        case 'thursday':
          return 4;
        case 'friday':
          return 5;
        case 'saturday':
          return 6;
        case 'sunday':
          return 7;
        default:
          return 1; // Default to Monday if unknown
      }
    }).toList();

    final batch = FirebaseFirestore.instance.batch();
    int sessionCount = 0;

    // Create sessions for each day of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentYear, currentMonth, day);
      final weekday = date.weekday; // 1=Monday, 7=Sunday

      // Check if this day is one of the training days
      if (trainingWeekdays.contains(weekday)) {
        // Create the session DateTime by combining date with training time
        final sessionDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          team.trainingTime.hour,
          team.trainingTime.minute,
        );

        // Only create sessions for future dates (including today)
        if (sessionDateTime.isAfter(now) || _isSameDay(sessionDateTime, now)) {
          final sessionRef = FirebaseFirestore.instance
              .collection('trainers')
              .doc(trainerId)
              .collection('teams')
              .doc(teamId)
              .collection('sessions')
              .doc();

          final sessionData = {
            'id': sessionRef.id,
            'teamId': teamId,
            'trainerId': trainerId,
            'sessionDateTime': sessionDateTime,
            'teamName': team.teamName,
            'teamAgeCategory': team.teamAgeCategory,
            'status': 'scheduled',
            'attendance': [],
            'attendanceMarked': false,
            'attendanceTakenAt': null,
            'notes': '',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          };

          batch.set(sessionRef, sessionData);
          sessionCount++;

          // Firestore batch has a limit of 500 operations
          if (sessionCount >= 450) {
            await batch.commit();
            sessionCount = 0;
          }
        }
      }
    }

    // Commit any remaining operations
    if (sessionCount > 0) {
      await batch.commit();
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

// If you need to create sessions for multiple months, you can use this extended version:
  Future<void> _createSessionsForMultipleMonths(
      String trainerId, String teamId, TeamModel team,
      {int monthsAhead = 3}) async {
    final now = DateTime.now();

    // Convert training days to DateTime weekdays
    final trainingWeekdays = team.trainingDays.map((day) {
      switch (day.toLowerCase()) {
        case 'monday':
          return 1;
        case 'tuesday':
          return 2;
        case 'wednesday':
          return 3;
        case 'thursday':
          return 4;
        case 'friday':
          return 5;
        case 'saturday':
          return 6;
        case 'sunday':
          return 7;
        default:
          return 1;
      }
    }).toList();

    final batch = FirebaseFirestore.instance.batch();
    int sessionCount = 0;

    // Create sessions for multiple months ahead
    for (int monthOffset = 0; monthOffset < monthsAhead; monthOffset++) {
      final targetMonth = DateTime(now.year, now.month + monthOffset, 1);
      final daysInMonth =
          DateTime(targetMonth.year, targetMonth.month + 1, 0).day;

      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(targetMonth.year, targetMonth.month, day);
        final weekday = date.weekday;

        if (trainingWeekdays.contains(weekday)) {
          final sessionDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            team.trainingTime.hour,
            team.trainingTime.minute,
          );

          // Only create future sessions
          if (sessionDateTime.isAfter(now)) {
            final sessionRef = FirebaseFirestore.instance
                .collection('trainers')
                .doc(trainerId)
                .collection('teams')
                .doc(teamId)
                .collection('sessions')
                .doc();

            final sessionData = {
              'id': sessionRef.id,
              'teamId': teamId,
              'trainerId': trainerId,
              'sessionDateTime': sessionDateTime,
              'teamName': team.teamName,
              'teamAgeCategory': team.teamAgeCategory,
              'status': 'scheduled',
              'attendance': [],
              'notes': '',
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            };

            batch.set(sessionRef, sessionData);
            sessionCount++;

            if (sessionCount >= 450) {
              await batch.commit();
              sessionCount = 0;
            }
          }
        }
      }
    }

    if (sessionCount > 0) {
      await batch.commit();
    }
  }

  @override
  Future<Result<bool>> markAttendance(
    String trainerId,
    String teamId,
    String sessionId,
    List<AttendanceModel> attendanceList,
  ) async {
    final sessionRef = firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('teams')
        .doc(teamId)
        .collection('sessions')
        .doc(sessionId);

    try {
      await firestore.runTransaction((transaction) async {
        final sessionSnapshot = await transaction.get(sessionRef);

        if (!sessionSnapshot.exists) {
          throw Exception('Session not found');
        }

        final data = sessionSnapshot.data() ?? {};

        if (data['attendanceMarked'] == true) {
          throw Exception('Attendance already marked for this session');
        }

        final attendanceData = attendanceList.map((a) => a.toMap()).toList();

        transaction.update(sessionRef, {
          'attendance': attendanceData,
          'attendanceMarked': true,
          'attendanceTakenAt': FieldValue.serverTimestamp(),
          'status': 'completed',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

      return Success(true);
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool>> isAttendanceMarkedToday(
    String trainerId,
    String teamId,
  ) async {
    try {
      final doc = await firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('teams')
          .doc(teamId)
          .get();

      final data = doc.data();
      if (data == null) return Success(false);

      final bool marked = data['attendanceMarked'] ?? false;
      final Timestamp? savedDay = data['attendanceDay'];

      final today = startOfDay(DateTime.now());

      if (!marked || savedDay == null) {
        return Success(false);
      }

      if (!savedDay.toDate().isAtSameMomentAs(today)) {
        /// 🔁 AUTO RESET
        await doc.reference.update({
          'attendanceMarked': false,
        });
        return Success(false);
      }

      return Success(true);
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }

  @override
  // Future<Result<SessionModel>> getSession(
  //     String trainerId, String teamId, String sessionId) async {
  //   try {
  //     final docSnapshot = await firestore
  //         .collection('trainers')
  //         .doc(trainerId)
  //         .collection('teams')
  //         .doc(teamId)
  //         .collection('sessions')
  //         .doc(sessionId)
  //         .get();

  //     if (!docSnapshot.exists || docSnapshot.data() == null) {
  //       return Fail(Exception('Session not found'));
  //     }
  //     final session = SessionModel.fromFirestore(
  //         docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
  //     return Success(session);
  //   } on FirebaseException catch (e) {
  //     return Fail(e);
  //   } catch (e) {
  //     return Fail(Exception(e.toString()));
  //   }
  // }

  // @override
  // Future<Result<List<SessionModel>>> getSessions(
  //     String trainerId, String teamId) async {
  //   try {
  //     final snapshot = await firestore
  //         .collection('trainers')
  //         .doc(trainerId)
  //         .collection('teams')
  //         .doc(teamId)
  //         .collection('sessions')
  //         .orderBy('date')
  //         .get();

  //     final sessions = snapshot.docs
  //         .map((doc) => SessionModel.fromFirestore(
  //               doc.data(),
  //               doc.id,
  //             ))
  //         .toList();

  //     return Success(sessions);
  //   } on FirebaseException catch (e) {
  //     return Fail(Exception('Failed to load sessions: ${e.message}'));
  //   } catch (e) {
  //     return Fail(Exception('Unexpected error: $e'));
  //   }
  // }

  @override
  Future<Result<List<AttendanceHistoryModel>>> getAttendanceHistory(
    String trainerId,
    String teamId,
  ) async {
    try {
      final sessionsSnap = await firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('teams')
          .doc(teamId)
          .collection('sessions')
          .where('attendanceMarked', isEqualTo: true)
          .get();

      final List<AttendanceHistoryModel> history = [];

      for (final session in sessionsSnap.docs) {
        final sessionData = session.data();
        final Timestamp? takenAt = sessionData['attendanceTakenAt'] is Timestamp
            ? sessionData['attendanceTakenAt'] as Timestamp
            : null;
        final dynamic attendance = sessionData['attendance'];
        final List players = attendance is List ? attendance : [];

        for (final player in players) {
          final playerData =
              player is Map ? player.cast<String, dynamic>() : null;
          history.add(
            AttendanceHistoryModel(
              takenAt: takenAt ?? Timestamp.fromDate(DateTime.now()),
              playerName: (playerData?['playerName'] as String?) ?? '',
              status: (playerData?['status'] as String?) ?? 'غائب',
            ),
          );
        }
      }

      history.sort((a, b) => b.takenAt.compareTo(a.takenAt));

      return Success(history);
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }

  DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
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
          .orderBy('sessionDateTime')
          .get();

      final sessions = snapshot.docs
          .map((doc) => SessionModel.fromMap(
                doc.data(),
                doc.id,
              ))
          .toList();

      return Success(sessions);
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }
}
