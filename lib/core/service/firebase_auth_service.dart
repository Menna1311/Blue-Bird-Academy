import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/service/auth_service.dart';
import 'package:blue_bird/features/auth/login/data/models/user_model.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      // Fetch role from Firestore
      final firestore = FirebaseFirestore.instance;
      final doc = await firestore.collection('users').doc(user.uid).get();
      final role = doc.data()?['role'] ?? '';

      return Success(
        UserModel(
          id: user.uid,
          email: user.email,
          password: password,
          displayName: user.displayName,
          role: role,
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
    required String role,
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

      // Store user profile in Firestore
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'email': email,
        'displayName': displayName,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Success(
        UserModel(
          id: user.uid,
          email: user.email,
          password: password,
          displayName: displayName,
          role: role,
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

      // Fetch role from Firestore
      final firestore = FirebaseFirestore.instance;
      final doc = await firestore.collection('users').doc(user.uid).get();
      final role = doc.data()?['role'] ?? '';

      final model = UserModel(
        id: user.uid,
        email: user.email,
        displayName: user.displayName,
        role: role,
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

  @override
  Future<Result<void>> resetPassword({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return Success(null);
    } on FirebaseAuthException catch (e) {
      return Fail(Exception(e.message ?? 'Reset password failed'));
    } catch (e) {
      return Fail(Exception(e.toString()));
    }
  }
}
