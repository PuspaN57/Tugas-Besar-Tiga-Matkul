import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class TokenStorage {
  final FlutterSecureStorage _storage;

  TokenStorage(this._storage);

  Future<void> saveToken(String token) =>
      _storage.write(key: ApiConstants.tokenKey, value: token);

  Future<String?> getToken() =>
      _storage.read(key: ApiConstants.tokenKey);

  Future<void> clear() =>
      _storage.delete(key: ApiConstants.tokenKey);
}