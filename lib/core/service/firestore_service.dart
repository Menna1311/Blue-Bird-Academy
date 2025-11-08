import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/database_service.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
import 'package:blue_bird/features/home/data/models/team_model.dart';
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
  Future<List<TeamModelHome>> getTeams(String trainerId) async {
    final snapshot = await firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('teams')
        .get();

    return snapshot.docs
        .map((doc) => TeamModelHome.fromFirestore(doc.data(), doc.id))
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

      return Success(true);
    } on FirebaseException catch (e) {
      return Fail(Exception('Failed to add team: ${e.message}'));
    } catch (e) {
      return Fail(Exception('Unexpected error: $e'));
    }
  }
}
