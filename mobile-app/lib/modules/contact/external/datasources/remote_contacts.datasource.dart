import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';
import 'package:tello_social_app/modules/contact/external/datasources/phone_number_helper.dart';
import 'package:tello_social_app/modules/contact/infra/datasources/i_contacts.datasource.dart';
import 'package:tello_social_app/modules/contact/infra/datasources/i_contacts_remote.datasource.dart';

import '../../../core/services/interfaces/ihttpclient_service.dart';

class RemoteContactsDataSource implements IContactsRemoteDataSource {
  final IHttpClientService _client;

  RemoteContactsDataSource(this._client);

  String _getUrl(String actionName) {
    return "/Contact/$actionName";
  }

  @override
  Future<List<ContactEntity>> fetchContacts({
    String? keyword,
    ContactsFilterParam? filter,
  }) async {
    final response = await _client.get(_getUrl("GetContactsList"));
    return List<ContactEntity>.from(response.map((x) => ContactEntity.fromMap(x)));
  }

  Map<String, dynamic> _mapToRemote(ContactEntity entity) {
    return {
      "phonebook_id": entity.phoneBookId,
      "phone_number": PhoneNumberHelper.fixIt(entity.phoneNumber),
      "display_name": entity.displayName,
    };
  }

  @override
  Future<void> saveContacts(List<ContactEntity> list) async {
    final Map<String, dynamic> params = {"type": "contact"};

    //encode json on isolate

    final List<Map<String, dynamic>> jsonList = list.map(_mapToRemote).toList();

    final encodedJson = await compute(jsonEncode, jsonList);

    // final encodedJson = jsonEncode(list);

    final Map<String, dynamic> postData = {
      "file": MultipartFile.fromString(
        encodedJson,
        contentType: Headers.jsonMimeType,
        filename: "contacts_upl.json",
      ),
    };

    final FormData formData = FormData.fromMap(postData);
    return _client.post(
      "/Media/UploadFile",
      postData: formData,
      params: params,
      // uploadProgressCtrl: _uploadProgressCtrl,
    );
  }
}
