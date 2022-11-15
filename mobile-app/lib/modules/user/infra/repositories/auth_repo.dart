import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/repositories/base_repo.dart';

import 'package:tello_social_app/modules/user/domain/entities/auth_user.dart';
import 'package:tello_social_app/modules/user/domain/entities/otp_token.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_auth_phone_repo.dart';
import 'package:tello_social_app/modules/user/infra/datasources/i_auth.datasource.dart';

import '../../../core/error/failure.dart';

class AuthRepo extends BaseRepo implements IAuthPhoneRepo {
  final IAuthDataSource remoteDataSource;

  AuthRepo(this.remoteDataSource);
  @override
  // TODO: implement onAuthChanged
  Stream<AuthUser?> get onAuthChanged => throw UnimplementedError();

  @override
  Future<Either<IFailure, OtpToken>> signInWithPhoneNumber({required String phoneNumber}) {
    return runWithEither<OtpToken>(() async {
      final response = await remoteDataSource.signInWithPhoneNumber(phoneNumber: phoneNumber);
      return response;
    });
  }

  @override
  Future<Either<IFailure, void>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Either<IFailure, String>> verifySmsCode({required String smsCode, required OtpToken otpToken}) {
    return runWithEither<String>(() async {
      return remoteDataSource.verifySmsCode(smsCode: smsCode, otpToken: otpToken);
    });
  }
}
