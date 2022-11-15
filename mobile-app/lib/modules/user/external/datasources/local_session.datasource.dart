import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tello_social_app/modules/user/infra/datasources/i_session.datasource.dart';

class LocalSessionDataSource implements ISessionDataSource {
  late final FlutterSecureStorage _secureStorage;

  static const String tokenKey = "telloToken";
  static const String phoneKey = "telloPhone";
  LocalSessionDataSource() {
    _secureStorage = const FlutterSecureStorage();
  }

  @override
  Future<void> clearSession() async {
    await _secureStorage.delete(key: phoneKey);
    return _secureStorage.delete(key: tokenKey);
  }

  @override
  Future<String?> getToken() => _secureStorage.read(key: tokenKey);

  @override
  Future<bool> get isExists async {
    final String? token = await getToken();
    return token != null;
  }

  @override
  Future<void> saveToken(String token) {
    return _secureStorage.write(key: tokenKey, value: token);
  }

  @override
  // Future<String?> getPhoneNumber() => _secureStorage.read(key: phoneKey);
  Future<String?> getPhoneNumber() async {
    final res = await _secureStorage.read(key: phoneKey);
    return res;
  }

  @override
  Future<void> savePhone(String phoneNumber) {
    return _secureStorage.write(key: phoneKey, value: phoneNumber);
  }
}
