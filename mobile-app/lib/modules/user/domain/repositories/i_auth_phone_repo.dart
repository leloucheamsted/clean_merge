import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/user/domain/entities/auth_user.dart';
import 'package:tello_social_app/modules/user/domain/entities/otp_token.dart';

import '../../../core/error/failure.dart';
import '../errors/auth_failure.dart';

abstract class IAuthPhoneRepo {
  Stream<AuthUser?> get onAuthChanged;
  Future<Either<IFailure, void>> signOut();
  Future<Either<IFailure, OtpToken>> signInWithPhoneNumber({
    required String phoneNumber,
  });
  Future<Either<IFailure, String>> verifySmsCode({
    required String smsCode,
    required OtpToken otpToken,
  });
}
