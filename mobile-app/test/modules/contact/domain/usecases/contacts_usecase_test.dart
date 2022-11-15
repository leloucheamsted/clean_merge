import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:modular_test/modular_test.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tello_social_app/modules/contact/contact.module.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';
import 'package:tello_social_app/modules/contact/domain/usecases/fetch_contacts.usecase.dart';
import 'package:tello_social_app/modules/contact/domain/usecases/save_contacts.usecase.dart';
import 'package:tello_social_app/modules/contact/external/datasources/remote_contacts.datasource.dart';
import 'package:tello_social_app/modules/core/core.module.dart';
import 'package:tello_social_app/modules/core/services/implementations/http/diohttpclient_service.dart';
import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late final FetchContactsUseCase fetchContactsUseCase = Modular.get();
  late final SaveContactsUseCase saveContactsUseCase = Modular.get();

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
    {"phone_number": "+237694138336", "display_name": "Contact3", "phonebook_id": "2003"},
    {"phone_number": "+972544444444", "display_name": "Elann Maskk", "phonebook_id": "2004"},
  ];

  const List<Map> jsonFromPhoneBookIOS = [
    {
      "phonebook_id": "5C7134A6-FACE-4FE5-A0FB-792937B95BDA:ABPerson",
      "phone_number": "+994 55 222 22 22",
      "display_name": "Air Jordan"
    },
    {
      "phonebook_id": "F57C8277-585D-4327-88A6-B5689FF69DFE",
      "phone_number": "555-522-8243",
      "display_name": "Anna Haro"
    },
    {
      "phonebook_id": "AB211C5F-9EC9-429F-9466-B9382FF61035",
      "phone_number": "555-478-7672",
      "display_name": "Daniel Higgins Jr."
    },
    {
      "phonebook_id": "E94CD15C-7964-4A9B-8AC4-10D7CFB791FD",
      "phone_number": "555-610-6679",
      "display_name": "David Taylor"
    },
    {
      "phonebook_id": "2E73EE73-C03F-4D5F-B1E8-44E85A70F170",
      "phone_number": "(555) 766-4823",
      "display_name": "Hank M. Zakroff"
    },
    {
      "phonebook_id": "410FE041-5C4E-48DA-B4DE-04C15EA3DBAC",
      "phone_number": "888-555-5512",
      "display_name": "John Appleseed"
    },
    {
      "phonebook_id": "177C371E-701D-42F8-A03B-C61CA31627F6",
      "phone_number": "(555) 564-8583",
      "display_name": "Kate Bell"
    }
  ];

  late final Dio _dioClient;
  late IHttpClientService httpClientService;

  late final RemoteContactsDataSource remoteContactsDataSource = RemoteContactsDataSource(httpClientService);

  const String fileAvatarPath =
      "/Users/fersmart/Library/Developer/CoreSimulator/Devices/3ABD7CCB-BED5-40E1-9D97-03CCAE352F55/data/Containers/Data/Application/C4EC97B3-3BCE-49B7-BEAD-64B96331DF1F/tmp/image_cropper_07412C4B-1EC4-45F4-B2D1-B73EAF278286-5639-00002D724FEB307E.jpg";
  // const String fileAvatarPath = "/Users/fersmart/Downloads/Anders-Holch-Povlsen1.jpeg";

  //+905559197381
  const String tokenSocial =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1MjQ1NTU5NTc1YzM0NDY0OTcyN2FmNGRmNWQ0MWE0OCIsInVuaXF1ZV9uYW1lIjoiNTI0NTU1OTU3NWMzNDQ2NDk3MjdhZjRkZjVkNDFhNDgiLCJqdGkiOiI0YmU0MzhlMy1lMjMyLTQzZmQtYmRjMy1kMzIzYmY5YThmMTUiLCJpYXQiOiIxNjY1MzE5OTM5IiwiYXVkIjoiODgyOTcxIiwibmJmIjoxNjY1MzE5OTM5LCJleHAiOjE2NjczOTM1MzksImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjMifQ.ZK4Og-LIYof-Y_L-3q6D8kh-lwvvt7AHxwnszOP9zwI";

  setUp(() {
    // initModule(CoreModule());
    initModule(ContactModule()); //BindNotFoundException

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

    Bind.lazySingleton((i) => FetchContactsUseCase(i()), export: false);
    Bind.lazySingleton((i) => FetchContactsUseCase(i()), export: false);
  });

  _log(dt) {
    print("$dt");
  }

  test('Get  module', () {
    expect(Modular.get<DioHttpClientService>(), isA<DioHttpClientService>());
  });

  test("fetch contacts with modular bind not working", () async {
    final responseEither = await fetchContactsUseCase.call(null);
    responseEither.fold((l) => _log(l), (r) => _log("success\n$r"));
  });

  test("fetch contacts with remote dataSource", () async {
    // final RemoteContactsDataSource remoteContactsDataSource = RemoteContactsDataSource(httpClientService);
    late final bool isSuccess;
    try {
      final res = await remoteContactsDataSource.fetchContacts();
      print(res);
      print("fetched contacts count ${res.length}");
      isSuccess = true;
    } on DioError catch (e) {
      isSuccess = false;
      print(e.response?.data);
      // print(e);
    } catch (e) {
      isSuccess = false;
      print(e);
    }

    expect(isSuccess, true);
  });

  test("save/upload contacts with remote dataSource", () async {
    // final FetchContactsUseCase useCase = FetchContactsUseCase(httpClientService);
    final jsonItemWithPhoneDashSpace = {
      "phonebook_id": "5C7134A6-FACE-4FE5-A0FB-792937B95BDA:ABPerson",
      "phone_number": "+994 55 222 22 22",
      "display_name": "Air Jordan"
    };
    final List<ContactEntity> contactList = <Map>[jsonItemWithPhoneDashSpace]
        .map(
          (e) => ContactEntity(
            phoneBookId: e["phonebook_id"],
            phoneNumber: e["phone_number"],
            displayName: e["display_name"],
          ),
        )
        .toList();

    late final bool isSuccess;
    try {
      final res = await remoteContactsDataSource.saveContacts(contactList);

      isSuccess = true;
    } on DioError catch (e) {
      isSuccess = false;
      print(e.response?.data);
      // print(e);
    } catch (e) {
      isSuccess = false;
      print(e);
    }

    expect(isSuccess, true);
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
