import '../../domain/entities/auth_user.dart';
import '../../domain/entities/otp_token.dart';

abstract class IAuthDataSource {
  Stream<AuthUser?> get onAuthChanged;
  Future<void> signOut();
  Future<OtpToken> signInWithPhoneNumber({
    required String phoneNumber,
  });
  Future<String> verifySmsCode({
    required String smsCode,
    required OtpToken otpToken,
  });
}
