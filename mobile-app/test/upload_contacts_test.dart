import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tello_social_app/modules/core/services/implementations/http/diohttpclient_service.dart';
import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const List<Map> jsonContacts = [
    {"phone_number": "+237694138335", "display_name": "userOnTello1", "phonebook_id": "001"},
    {"phone_number": "+237680087198", "display_name": "test2", "phonebook_id": "001"},
    {"phone_number": "+237694138336", "display_name": "userOntello2", "phonebook_id": "001"},
    {"phone_number": "+237681111254", "display_name": "usernontello1", "phonebook_id": "001"},
    {"phone_number": "+237680084198", "display_name": "usernontello2", "phonebook_id": "001"},
    {"phone_number": "+237680084198", "display_name": "usernontello3", "phonebook_id": "001"},
    {"phone_number": "+237650087198", "display_name": "usernontello4", "phonebook_id": "001"},
    {"phone_number": "+237694087198", "display_name": "usernontello5", "phonebook_id": "001"}
  ];

  const List<Map> jsonContacts2 = [
    {"phone_number": "+237694138335", "display_name": "Contact1", "phonebook_id": "1001"},
    {"phone_number": "+237680087198", "display_name": "Contact2", "phonebook_id": "2001"},
    {"phone_number": "+237694138336", "display_name": "Contact3", "phonebook_id": "2001"},
  ];
  late final Dio _dioClient;
  late IHttpClientService httpClientService;

  const String fileAvatarPath =
      "/Users/fersmart/Library/Developer/CoreSimulator/Devices/3ABD7CCB-BED5-40E1-9D97-03CCAE352F55/data/Containers/Data/Application/C4EC97B3-3BCE-49B7-BEAD-64B96331DF1F/tmp/image_cropper_07412C4B-1EC4-45F4-B2D1-B73EAF278286-5639-00002D724FEB307E.jpg";
  // const String fileAvatarPath = "/Users/fersmart/Downloads/Anders-Holch-Povlsen1.jpeg";

  const String tokenSocial =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1MjQ1NTU5NTc1YzM0NDY0OTcyN2FmNGRmNWQ0MWE0OCIsInVuaXF1ZV9uYW1lIjoiNTI0NTU1OTU3NWMzNDQ2NDk3MjdhZjRkZjVkNDFhNDgiLCJqdGkiOiI0YmU0MzhlMy1lMjMyLTQzZmQtYmRjMy1kMzIzYmY5YThmMTUiLCJpYXQiOiIxNjY1MzE5OTM5IiwiYXVkIjoiODgyOTcxIiwibmJmIjoxNjY1MzE5OTM5LCJleHAiOjE2NjczOTM1MzksImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjMifQ.ZK4Og-LIYof-Y_L-3q6D8kh-lwvvt7AHxwnszOP9zwI";

  setUp(() {
    // repo = MockRepo();
    // phoneNumberValidator = PhoneUtilValidator();

    _dioClient = Dio(
      BaseOptions(
        baseUrl: 'https://api.dev.tello-social.tello-technologies.com/api/v1',
        // baseUrl: 'https://api.dev.tello-social.tello-technologies.com/api/v1',
        headers: {
          "content-type": "application/json",
        },
      ),
    );
    httpClientService = DioHttpClientService(dio: _dioClient);

    httpClientService.setBearerToken(tokenSocial);
  });

  test("test upload contacts list", () async {
    late final bool isFailed;

    final Map<String, dynamic> params = {"type": "contact"};
    final Map<String, dynamic> postData = {};

    final encodedJson = jsonEncode(jsonContacts2);

    postData["file"] = MultipartFile.fromString(
      encodedJson,
      contentType: Headers.jsonMimeType,
      filename: "contacts_upl.json",
    );

    // postData["file"] = await MultipartFile.fromFile(fileAvatarPath);

    final FormData formData = FormData.fromMap(postData);
    try {
      final response = await httpClientService.post(
        "/Media/UploadFile",
        postData: formData,
        params: params,
        // uploadProgressCtrl: _uploadProgressCtrl,
      );
      print(response);
      isFailed = false;
    } on DioError catch (e) {
      isFailed = true;
      print(e.response?.data);
      // print(e);
    } catch (e) {
      isFailed = true;
      print(e);
    }

    expect(isFailed, false);
  });
}
