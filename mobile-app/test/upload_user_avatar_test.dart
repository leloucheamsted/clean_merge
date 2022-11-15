import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tello_social_app/modules/core/services/implementations/http/diohttpclient_service.dart';
import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late final Dio _dioClient;
  late IHttpClientService httpClientService;

  const String apiBaseUrl = 'https://api.dev.tello-social.tello-technologies.com/api/v1';
  // const String apiBaseUrl = 'https://api.staging.dev.tello-social.tello-technologies.com/api/v1';

  const String fileAvatarPath =
      "/Users/fersmart/Library/Developer/CoreSimulator/Devices/3ABD7CCB-BED5-40E1-9D97-03CCAE352F55/data/Containers/Data/Application/C4EC97B3-3BCE-49B7-BEAD-64B96331DF1F/tmp/image_cropper_07412C4B-1EC4-45F4-B2D1-B73EAF278286-5639-00002D724FEB307E.jpg";
  // const String fileAvatarPath = "/Users/fersmart/Downloads/Anders-Holch-Povlsen1.jpeg";

  const String tokenSocial =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjZTdkOGUyMGY5OGQ0NzE1OGYwN2VmNmU5OWJhMmNhOCIsInVuaXF1ZV9uYW1lIjoiY2U3ZDhlMjBmOThkNDcxNThmMDdlZjZlOTliYTJjYTgiLCJqdGkiOiI0ZTkwMzBhMS1mODk5LTRkNDUtODQ0Ny1lOWY4ZjBkODFlZDAiLCJpYXQiOiIxNjY1MTYzNTM1IiwiYXVkIjoiODc2Mzc4IiwibmJmIjoxNjY1MTYzNTM1LCJleHAiOjE2NjcyMzcxMzUsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjMifQ._KkQ2_qlZAWdx8tyXzCN3M_47Hy8Rwnkfo6cMHPbfxA";

  setUp(() {
    // repo = MockRepo();
    // phoneNumberValidator = PhoneUtilValidator();

    _dioClient = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        // baseUrl: 'https://api.dev.tello-social.tello-technologies.com/api/v1',
        headers: {
          "content-type": "application/json",
        },
      ),
    );
    httpClientService = DioHttpClientService(dio: _dioClient);

    httpClientService.setBearerToken(tokenSocial);
  });

  test("test Media/UploadFile with raw dio user avatar", () async {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        // headers: {"content-type": "application/json", HttpHeaders.authorizationHeader: "Bearer $tokenSocial"},
      ),
    );
    dio.options.headers[HttpHeaders.authorizationHeader] = "Bearer $tokenSocial";

    late final bool isFailed;

    final Map<String, dynamic> params = {"type": "user"};
    final Map<String, dynamic> postData = {};

    final String fileName = fileAvatarPath.split("/").last;

    postData["file"] = await MultipartFile.fromFile(fileAvatarPath);
    // postData["file"] = await MultipartFile.fromFile(fileAvatarPath, filename: fileName);

    final FormData formData = FormData.fromMap(postData);

    try {
      final response = await dio.post(
        "/Media/UploadFile",
        // "/Media/UploadFile",
        data: formData,
        queryParameters: params,
        // uploadProgressCtrl: _uploadProgressCtrl,
      );
      print(response.data);
      isFailed = false;
    } on DioError catch (e) {
      isFailed = true;
      print(e.response?.data);
      // print(e);
    } catch (e) {
      isFailed = true;
      print(e);
      // print(e["response"]["data"]);
    }
  });

  test("test upload user avatar", () async {
    late final bool isFailed;

    final Map<String, dynamic> params = {"type": "user"};
    final Map<String, dynamic> postData = {};

    postData["File"] = MultipartFile.fromFile(fileAvatarPath);

    final FormData formData = FormData.fromMap(postData);
    try {
      final response = await httpClientService.post(
        // "/Media/UploadFile",
        '/Group/UploadCommon',
        postData: formData,
        params: params,
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
}
