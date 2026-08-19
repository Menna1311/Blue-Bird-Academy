import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserEntity? _user;

  UserEntity? get user => _user;

  bool get isLoggedIn => _user != null;

  void setUser(UserEntity user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
