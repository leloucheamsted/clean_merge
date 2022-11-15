abstract class ISessionDataSource {
  Future<bool> get isExists;
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> savePhone(String phoneNumber);
  Future<String?> getPhoneNumber();
  Future<void> clearSession();
}
