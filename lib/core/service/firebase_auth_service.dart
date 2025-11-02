import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/auth/login/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        final model = UserModel(email: user.email, password: password);
        return Success(model);
      } else {
        return Fail(Exception('No user found'));
      }
    } on FirebaseAuthException catch (e) {
      return Fail(Exception(e.message ?? 'Login failed'));
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }

  Future<Result<UserModel>> register({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final model = UserModel(email: user.email, password: password);
        return Success(model);
      } else {
        return Fail(Exception('No user found'));
      }
    } on FirebaseAuthException catch (e) {
      return Fail(Exception(e.message ?? 'Login failed'));
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }
}
