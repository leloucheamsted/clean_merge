import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';
import 'package:tello_social_app/modules/core/validators/i_simple.validator.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_auth_phone_repo.dart';

import '../entities/otp_token.dart';
import '../errors/auth_failure.dart';

class SigninUseCase implements IUseCase<OtpToken, SigninParams> {
  final ISimpleValidator<String>? phoneNumberValidator;
  final IAuthPhoneRepo repo;

  SigninUseCase(this.repo, {this.phoneNumberValidator});
  @override
  Future<Either<IFailure, OtpToken>> call(SigninParams params) async {
    String phoneNumber = params.phonePrefix + params.phoneNumber;
    if (phoneNumberValidator != null) {
      try {
        phoneNumber = await phoneNumberValidator!.validate(phoneNumber);
      } catch (e) {
        return left(AuthFailure.invalidPhoneNumber(msg: e.toString()));
      }
    }

    return repo.signInWithPhoneNumber(phoneNumber: phoneNumber);
    // return repo.signInWithPhoneNumber(phoneNumber: params.phoneNumber, timeout: Duration.zero);
  }
}

class SigninParams {
  final String phoneNumber;
  final String phonePrefix;
  final String? regionCode;
  SigninParams({
    required this.phoneNumber,
    required this.phonePrefix,
    this.regionCode,
  });
}
