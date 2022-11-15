import 'dart:math';

import 'package:faker_dart/faker_dart.dart';
import 'package:tello_social_app/modules/user/domain/entities/otp_token.dart';
import 'package:tello_social_app/modules/user/domain/entities/auth_user.dart';
import 'package:tello_social_app/modules/user/infra/datasources/i_auth.datasource.dart';

class FakeAuthDataSource implements IAuthDataSource {
  late final Faker faker = Faker.instance;
  Future<T> _returnData<T>(dynamic data) {
    return Future.delayed(const Duration(seconds: 1), () => data);
  }

  @override
  // TODO: implement onAuthChanged
  Stream<AuthUser?> get onAuthChanged => throw UnimplementedError();

  @override
  Future<OtpToken> signInWithPhoneNumber({required String phoneNumber}) {
    return _returnData(OtpToken(code: _generateOtp().toString(), token: _generateOtp(length: 12).toString()));
  }

  int _generateOtp({int length = 6}) {
    final int min = pow(10, length - 1).toInt();
    final int max = pow(10, length).toInt();
    return faker.datatype.number(min: min, max: max);
  }

  @override
  Future<void> signOut() {
    return _returnData(true);
  }

  @override
  Future<String> verifySmsCode({required String smsCode, required OtpToken otpToken}) {
    return _returnData("done");
  }
}
