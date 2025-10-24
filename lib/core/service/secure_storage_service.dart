import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class SecureStorageService {
  static const String _tokenKey = 'token';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Save the token securely
  Future<bool> setToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
    return true;
  }

  /// Retrieve the saved token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Delete the saved token (used when logging out)
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  /// Clear all secure storage data (optional)
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
