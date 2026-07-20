import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  AuthStorage({
    FlutterSecureStorage? storage,
  }) : _storage =
           storage ??
           const FlutterSecureStorage();

  static const _tokenKey =
      'authentication_token';

  final FlutterSecureStorage _storage;

  Future<String?> readToken() {
    return _storage.read(
      key: _tokenKey,
    );
  }

  Future<void> saveToken(
    String token,
  ) {
    return _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  Future<void> deleteToken() {
    return _storage.delete(
      key: _tokenKey,
    );
  }
}