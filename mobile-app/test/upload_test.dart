import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tello_social_app/modules/core/services/implementations/http/diohttpclient_service.dart';
import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_auth_phone_repo.dart';

class MockRepo extends Mock implements IAuthPhoneRepo {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late final Dio _dioClient;
  late IHttpClientService httpClientService;

  const String apiBaseUrl = 'https://api.dev.tello-social.tello-technologies.com/api/v1';
  // const String apiBaseUrl = 'https://api.staging.dev.tello-social.tello-technologies.com/api/v1';

  const String tokenSocial =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjZTdkOGUyMGY5OGQ0NzE1OGYwN2VmNmU5OWJhMmNhOCIsInVuaXF1ZV9uYW1lIjoiY2U3ZDhlMjBmOThkNDcxNThmMDdlZjZlOTliYTJjYTgiLCJqdGkiOiI0ZTkwMzBhMS1mODk5LTRkNDUtODQ0Ny1lOWY4ZjBkODFlZDAiLCJpYXQiOiIxNjY1MTYzNTM1IiwiYXVkIjoiODc2Mzc4IiwibmJmIjoxNjY1MTYzNTM1LCJleHAiOjE2NjcyMzcxMzUsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjMifQ._KkQ2_qlZAWdx8tyXzCN3M_47Hy8Rwnkfo6cMHPbfxA";

  setUp(() {
    // repo = MockRepo();
    // phoneNumberValidator = PhoneUtilValidator();

    _dioClient = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        headers: {
          "content-type": "application/json",
        },
      ),
    );
    httpClientService = DioHttpClientService(dio: _dioClient);

    httpClientService.setBearerToken(tokenSocial);
  });

  Dio _getDio(bool isRaw) {
    return !isRaw
        ? _dioClient
        : Dio(
            BaseOptions(
              baseUrl: apiBaseUrl,
              // headers: {"content-type": "application/json", HttpHeaders.authorizationHeader: "Bearer $tokenSocial"},
            ),
          );
  }

  test("test upload with raw dio client", () async {
    /*final Dio rawDio = Dio(
      BaseOptions(
        baseUrl: 'https://api.staging.dev.tello-social.tello-technologies.com/api/v1',
        headers: {"content-type": "application/json", HttpHeaders.authorizationHeader: "Bearer $tokenSocial"},
      ),
    );*/

    final Dio dioClient = _getDio(false);
    dioClient.options.headers[HttpHeaders.authorizationHeader] = "Bearer $tokenSocial";
    const String filePath = "/Users/fersmart/Downloads/Anders-Holch-Povlsen1.jpeg";
    late final bool isFailed;
    try {
      var formData = FormData.fromMap({
        'Type': 25,
        "Extra": "rawDioExtra",
        'File': await MultipartFile.fromFile(filePath, filename: 'uploadRaw.test')
      });
      final response = await dioClient.post(
        '/Group/UploadCommon',
        data: formData,
        // options: Options(headers: {HttpHeaders.authorizationHeader: "Bearer $tokenSocial"}),
      );

      if (response.data["FileName"] == null) {
        throw Exception("FileName response null");
      }
      print(response);
      isFailed = false;
    } catch (e) {
      isFailed = true;
      print(e);
    }

    expect(isFailed, false);
  });

  Future<bool> testUploadWithDioClient({
    required String url,
    required Dio dio,
    required Map<String, dynamic> postData,
  }) async {
    late final bool isSuccess;
    try {
      final response = await dio.post(
        url,
        data: FormData.fromMap(postData),
      );
      print(response.data);
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
      print(e);
    }

    return isSuccess;
  }

  test("test UploadFile with dio client", () async {
    final Dio dioClient = _getDio(true);
    dioClient.options.headers[HttpHeaders.authorizationHeader] = "Bearer $tokenSocial";
    const String filePath =
        "/Users/fersmart/Library/Developer/CoreSimulator/Devices/3ABD7CCB-BED5-40E1-9D97-03CCAE352F55/data/Containers/Data/Application/C4EC97B3-3BCE-49B7-BEAD-64B96331DF1F/tmp/image_cropper_07412C4B-1EC4-45F4-B2D1-B73EAF278286-5639-00002D724FEB307E.jpg";
    // const String filePath = "/Users/fersmart/Desktop/Screen Shot 2022-10-07 at 00.37.24.png";

    var formData = {'Type': "user", 'File': await MultipartFile.fromFile(filePath, filename: 'uploadRaw.test')};

    final bool isSuccess = await testUploadWithDioClient(url: "/Media/UploadFile", dio: dioClient, postData: formData);

    expect(isSuccess, true);
  });

  test("test uploadCommon with dio client", () async {
    final Dio dioClient = _getDio(false);
    dioClient.options.headers[HttpHeaders.authorizationHeader] = "Bearer $tokenSocial";
    const String filePath = "/Users/fersmart/Desktop/Screen Shot 2022-10-07 at 00.37.24.png";

    var formData = {
      'Type': 25,
      "Extra": "rawDioExtra",
      'File': await MultipartFile.fromFile(filePath, filename: 'uploadRaw.test')
    };
    final bool isSuccess =
        await testUploadWithDioClient(url: '/Group/UploadCommon', dio: dioClient, postData: formData);

    expect(isSuccess, true);
  });

  test("test upload", () async {
    /*final response = await httpClientService.upload(
      // "/Group/UploadGroupAvatar",
      "/Group/UploadCommon",
      filePath: uploadSrc!,
      dtMap: {"type": 1, "extra": _uploadParams["id"]},
      // params: {"id": id},
      uploadProgressCtrl: _uploadProgressCtrl,
    );*/

    _dioClient.options.headers[HttpHeaders.authorizationHeader] = "Bearer $tokenSocial";

    final Map<String, dynamic> testParams = {"id": "myId", "Type": 11, "name": "myName", "Extra": "myExtra"};
    final String filePath =
        "/Users/fersmart/Library/Developer/CoreSimulator/Devices/3ABD7CCB-BED5-40E1-9D97-03CCAE352F55/data/Containers/Data/Application/02CACF2E-A786-4D30-A86C-10AAFA9B6207/tmp/image_cropper_D55A316B-DE87-47EA-B3B8-26720134DFF8-36651-0000188BD16F8418.jpg";

    late final bool isFailed;
    try {
      var formData = FormData.fromMap(
          {'Type': 25, "Extra": "rawDioExtra", 'File': await MultipartFile.fromFile(filePath, filename: 'upload.txt')});
      final responsePureDio = await _dioClient.post(
        "/Group/UploadCommon",
        data: formData,
        // options: Options(headers: {HttpHeaders.authorizationHeader: "Bearer $tokenSocial"}),
      );

      final response = await httpClientService.upload(
        "/Group/UploadCommon",
        filePath: filePath,
        // params: params,
        // params: testParams,
        dtMap: testParams,
        // uploadProgressCtrl: _uploadProgressCtrl,
      );
      if (response["FileName"] == null) {
        throw Exception("FileName response null");
      }
      print(response);
      isFailed = false;
    } catch (e) {
      isFailed = true;
      print(e);
    }

    expect(isFailed, false);
  });

  Future<bool> _testUpload({
    required String url,
    Map<String, dynamic>? postData,
  }) async {
    final Map<String, dynamic> testParams =
        postData ?? {"id": "myId", "Type": 11, "name": "myName", "Extra": "myExtra"};

    late final bool isSuccess;
    try {
      final response = await httpClientService.post(
        url,
        postData: FormData.fromMap(testParams),
        isJson: false,
      );
      /*if (response["Extra"] != testParams["Extra"]) {
        throw Exception("response is not same\n $response");
      }*/
      print(response);
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
      print(e);
    }

    return isSuccess;
  }

  test("test uploadcommon without file with multiform string", () async {
    final bool isSuccess = await _testUpload(url: "/Group/UploadCommon");
    expect(isSuccess, true);
  });

  test("test UploadFile without file with multiform string", () async {
    final Map<String, dynamic> postData = {"Type": "user"};
    final bool isSuccess = await _testUpload(url: "/Media/UploadFile", postData: postData);
    expect(isSuccess, true);
  });

  ;
}
