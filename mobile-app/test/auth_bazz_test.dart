import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tello_social_app/modules/core/services/implementations/http/diohttpclient_service.dart';
import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late IHttpClientService httpClientService;

  setUp(() {
    final Dio dioClient = Dio(
      BaseOptions(
        baseUrl: 'https://api.dev.bazzptt.com',
        headers: {
          "content-type": "application/json",
        },
      ),
    );
    httpClientService = DioHttpClientService(dio: dioClient);
  });

  test("test bazz login", () async {
    final response = await httpClientService.post("/Auth/Login/", postData: {
      "login": "eli123",
      "password": "eli123",
      "ignoreActiveSession": true,
      "simSerialNumber": "8989898989898989",
    });

    final String? token = response["token"];
    if (token == null) {
      final String? msg = response["status"]["message"];
      print(msg);
    } else {
      print(token);
    }

    expect(token, isNotNull);
  });
}
