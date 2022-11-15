import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tello_social_app/modules/core/services/implementations/http/diohttpclient_service.dart';
import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';
import 'package:tello_social_app/modules/core/validators/i_simple.validator.dart';
import 'package:tello_social_app/modules/core/validators/phone_regex.validator.dart';
import 'package:tello_social_app/modules/user/domain/entities/otp_token.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_auth_phone_repo.dart';
import 'package:tello_social_app/modules/user/domain/usecases/otp.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/signin.usecase.dart';
import 'package:tello_social_app/modules/user/external/datasources/auth_remote.datasource.dart';
import 'package:tello_social_app/modules/user/infra/repositories/auth_repo.dart';

class MockRepo extends Mock implements IAuthPhoneRepo {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late SigninUseCase signinUsecase;
  late OtpUseCase otpUseCase;
  late IAuthPhoneRepo repo;

  late ISimpleValidator<String> phoneNumberValidator;

  late IHttpClientService httpClientService;

  setUp(() {
    // repo = MockRepo();
    // phoneNumberValidator = PhoneUtilValidator();
    phoneNumberValidator = PhoneRegexpValidator();

    final Dio dioClient = Dio(
      BaseOptions(
        baseUrl: 'https://api.dev.tello-social.tello-technologies.com/api/v1',
        headers: {
          "content-type": "application/json",
        },
      ),
    );
    httpClientService = DioHttpClientService(dio: dioClient);

    final dataSource = AuthApiDataSource(httpClientService);
    repo = AuthRepo(dataSource);
    signinUsecase = SigninUseCase(repo, phoneNumberValidator: phoneNumberValidator);

    otpUseCase = OtpUseCase(repo);
  });

  test("test usecase incorrect phone number", () async {
    // when(()=>usecase()).thenAnswer((invocation) => right(r))
    final response = await signinUsecase.call(SigninParams(phoneNumber: "123", phonePrefix: "111"));

    final bool isFailed = response.isLeft();
    if (isFailed) {
      response.fold((l) => print(l), (r) => print("successss"));
    }

    expect(isFailed, false);
    // verify(() => repo);

    // expect(response, Left<IFailure, OtpToken>(AuthFailure.invalidPhoneNumber()));

    // when(()=>usecase.call(SigninParams(phoneNumber: "123"))).thenAnswer((invocation) => right(r))
  });
  test("test usecase with phone number", () async {
    // when(()=>usecase()).thenAnswer((invocation) => right(r))
    // final response = await usecase.call(SigninParams(phoneNumber: "+994506000000"));
    final response =
        await signinUsecase.call(SigninParams(phoneNumber: "506000000", phonePrefix: "+994", regionCode: "AZE"));
    // final response = await usecase.call(SigninParams(phoneNumber: "4175555470", regionCode: "US"));

    final bool isSuccess = response.isRight();

    response.fold((l) => print("failed $l"), (r) => print("successss $r"));

    expect(isSuccess, true);
    // verify(() => repo);

    // expect(response, Left<IFailure, OtpToken>(AuthFailure.invalidPhoneNumber()));

    // when(()=>usecase.call(SigninParams(phoneNumber: "123"))).thenAnswer((invocation) => right(r))
  });

  test("test usecase signin & receive otp", () async {
    // final String phonePrefix = "+90";
    // final String phoneNumber = "5559197381";

    final String phonePrefix = "+33";
    final String phoneNumber = "651146579";

    final responseSignin =
        await signinUsecase.call(SigninParams(phoneNumber: phoneNumber, phonePrefix: phonePrefix, regionCode: "TR"));
    // final response = await usecase.call(SigninParams(phoneNumber: "4175555470", regionCode: "US"));

    final bool isSuccess = responseSignin.isRight();

    String? code;

    OtpToken? otpToken;

    responseSignin.fold((l) => print("failed $l"), (r) {
      print("success ${r.code}");
    });

    expect(isSuccess, true);

    otpToken = responseSignin.getOrElse(() => throw "No Otp Token");
    code = otpToken.code;

    httpClientService.setHeaders({"Otp-Token": otpToken.token});

    final responseOtp = await otpUseCase.call(VerifyParams(smsCode: code, otpToken: otpToken));

    responseOtp.fold((l) => print("OptVerify.failed $l"), (r) {
      print("OptVerify.success r}");
    });

    expect(responseOtp.isRight(), true);

    final verifyResponse = responseOtp.getOrElse(() => throw "failed verify");

    final String? parsedTokenValue = httpClientService.getBearerToken();

    print(parsedTokenValue);

    expect(parsedTokenValue, verifyResponse);

    // verify(() => repo);

    // expect(response, Left<IFailure, OtpToken>(AuthFailure.invalidPhoneNumber()));

    // when(()=>usecase.call(SigninParams(phoneNumber: "123"))).thenAnswer((invocation) => right(r))
  });

  test("parse bearer token with dio", () {
    const String tokenValue = "token123";

    httpClientService.setBearerToken(tokenValue);

    String? parsedTokenValue = httpClientService.getBearerToken();

    expect(parsedTokenValue, tokenValue);
  });

  test("parse bearer token", () {
    const String tokenValue = "token123";

    const String bearerHeaderValue = "Bearer $tokenValue";
    // final regExp = RegExp(r'^(?<type>.+?)\s+(?<token>.+?)$');
    final regExp = RegExp(r'^Bearer\s+(?<token>.+?)$');
    RegExpMatch? match = regExp.firstMatch(bearerHeaderValue);
    String? parsedTokenValue = match?.namedGroup("token");
    expect(parsedTokenValue, tokenValue);
  });
}
