import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/database_service.dart';
import 'package:blue_bird/features/home/data/models/team_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DatabaseService)
class FirestoreService implements DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<Result<bool>> addData(
      {required String path, required Map<String, dynamic> data}) async {
    await firestore.collection(path).add(data);
    return Future.value(Success(true));
  }

  @override
  Future<List<TeamModel>> getTeams(String trainerId) async {
    final snapshot = await firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('teams')
        .get();

    return snapshot.docs
        .map((doc) => TeamModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
