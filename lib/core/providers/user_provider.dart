import 'package:blue_bird/core/models/user.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserProvider extends ChangeNotifier {
  static final UserProvider _instance = UserProvider._internal();
  factory UserProvider() => _instance;

  UserProvider._internal();

  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  bool get isLoggedIn => _user != null;

  void login(String token) {
    _token = token;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
