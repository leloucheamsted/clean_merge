import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';
import 'package:tello_social_app/modules/user/domain/entities/auth_user.dart';
import 'package:tello_social_app/modules/user/domain/entities/otp_token.dart';
import 'package:tello_social_app/modules/user/infra/datasources/i_auth.datasource.dart';

class AuthApiDataSource implements IAuthDataSource {
  final IHttpClientService _client;
  AuthApiDataSource(this._client);
  @override
  Stream<AuthUser?> get onAuthChanged => throw UnimplementedError();

  @override
  Future<OtpToken> signInWithPhoneNumber({required String phoneNumber}) async {
    // final response = await _client.get("/signin/$phoneNumber");
    final response = await _client.post("/Authenticate/SignIn", postData: {"phone": phoneNumber});
    final token = OtpToken.fromMap(response);
    // _client.setHeaders({"Otp-Token": token.token});
    return token;
  }

  @override
  Future<void> signOut() {
    return _client.get("/signout");
  }

  @override
  Future<String> verifySmsCode({required String smsCode, required OtpToken otpToken}) async {
    // final response =await _client.post("/Authenticate/VerifyOtp", postData: {"code": smsCode, "token:": otpToken.token});
    final response = await _client.post("/Authenticate/VerifyOtp", postData: {"code": smsCode});
    final AuthSuccessResponse authSuccessResponse = AuthSuccessResponse.fromMap(response);
    _client.setBearerToken(authSuccessResponse.accessToken);
    return authSuccessResponse.accessToken;
  }
}

class AuthSuccessResponse {
  final String accessToken;
  final String? refreshToken;
  final String? role;
  AuthSuccessResponse({
    required this.accessToken,
    this.refreshToken,
    this.role,
  });

  factory AuthSuccessResponse.fromMap(Map<String, dynamic> map) {
    return AuthSuccessResponse(
      accessToken: map['accessToken'],
      refreshToken: map['refreshToken'],
      role: map['role'],
    );
  }

  @override
  String toString() => 'AuthSuccessResponse(accessToken: $accessToken, refreshToken: $refreshToken, role: $role)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthSuccessResponse &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.role == role;
  }

  @override
  int get hashCode => accessToken.hashCode ^ refreshToken.hashCode ^ role.hashCode;
}
