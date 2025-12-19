import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/auth_service.dart';
import 'package:blue_bird/features/auth/login/data/models/user_model.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthService)
class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
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
      if (user == null) {
        return Fail(Exception('No user found'));
      }

      return Success(
        UserModel(
          id: user.uid,
          email: user.email,
          password: password,
          displayName: user.displayName,
        ),
      );
    } on FirebaseAuthException catch (e) {
      return Fail(Exception(e.message ?? 'Login failed'));
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }

  @override
  Future<Result<UserModel>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return Fail(Exception('No user found'));
      }

      await user.updateDisplayName(displayName);

      return Success(
        UserModel(
          id: user.uid,
          email: user.email,
          password: password,
          displayName: displayName,
        ),
      );
    } on FirebaseAuthException catch (e) {
      return Fail(Exception(e.message ?? 'Register failed'));
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> getLoggedInUser() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return Fail(Exception('No user found'));
      }

      final model = UserModel(
        id: user.uid,
        email: user.email,
        displayName: user.displayName,
      );

      return Success(model.toEntity());
    } on FirebaseAuthException catch (e) {
      return Fail(Exception(e.message ?? 'Failed to get user'));
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return Success(null);
    } on FirebaseAuthException catch (e) {
      return Fail(Exception(e.message ?? 'Logout failed'));
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }
}
