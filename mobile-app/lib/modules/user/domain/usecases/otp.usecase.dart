import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_auth_phone_repo.dart';

import '../entities/otp_token.dart';

class OtpUseCase implements IUseCase<String, VerifyParams> {
  final IAuthPhoneRepo repo;

  OtpUseCase(this.repo);
  @override
  Future<Either<IFailure, String>> call(VerifyParams params) {
    return repo.verifySmsCode(smsCode: params.smsCode, otpToken: params.otpToken);
  }
}

class VerifyParams {
  final String smsCode;
  final OtpToken otpToken;
  VerifyParams({
    required this.smsCode,
    required this.otpToken,
  });
}
