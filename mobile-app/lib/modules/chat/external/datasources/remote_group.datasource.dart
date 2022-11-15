import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/infra/datasource/i_group_datasource.dart';
import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';

class RemoteGroupDataSource implements IGroupDataSource {
  final IHttpClientService _client;
  RemoteGroupDataSource(this._client);

  String _getUrl(String actionName) {
    return "/Group/$actionName";
  }

  @override
  Future<GroupEntity> addUserToGroup(
      {required String phoneNumber, required String groupId}) async {
    final response = await _client.put(
      ("AddMember"),
      postData: {
        "groupId": groupId,
        // "phoneNumber": "+994506408888",
        "phoneNumber": phoneNumber.replaceAll("-", ""),
      },
    );
    return GroupEntity.fromMap(response);
  }

  @override
  Future<GroupEntity> removeUserFromGroup(
      {required String phoneNumber, required String groupId}) async {
    final response = await _client.put(_getUrl("RemoveMember"),
        postData: {"groupId": groupId, "phoneNumber": phoneNumber});
    return GroupEntity.fromMap(response);
  }

  @override
  Future<GroupEntity> create(Map<String, dynamic> data,
      {String? avatarFilePath}) async {
    // final response = await _client.upload(_getUrl("CreateGroup"), dtMap: data,filePath: avatarFilePath);
    late final dynamic response;

    // response = await _client.upload(_getUrl("CreateGroup"), dtMap: data, filePath: avatarFilePath!);
    if (avatarFilePath == null) {
      response = await _client.post(_getUrl("CreateGroup"),
          postData: FormData.fromMap(data));
      // _client.addCustomHeaderItem(HttpHeaders.contentTypeHeader, 'multipart/form-data');
      // response = await _client.post(_getUrl("CreateGroup"),
      //     postData: data, contentTypeHeader: 'multipart/form-data', isJson: false);
    } else {
      response = await _client.upload(_getUrl("CreateGroup"),
          dtMap: data, filePath: avatarFilePath);
    }

    return GroupEntity.fromMap(response);
    /*try {
      final GroupEntity entity = GroupEntity.fromMap(response);
      return entity;
    } catch (e) {
      throw Exception("CreateGroup response exception $response");
    }*/
  }

  @override
  Future<void> delete(String groupId) {
    return _client
        .delete(_getUrl("DeleteGroup"), postData: {"groupId": groupId});
  }

  @override
  Future<List<GroupEntity>> fetchGroups() async {
    final response = await _client.get(_getUrl("GetUserGroups"));
    return List<GroupEntity>.from(response.map((x) => GroupEntity.fromMap(x)));
  }

  @override
  Future<GroupEntity> findById(String id) async {
    final response = await _client.get(_getUrl("GetGroup"), params: {"id": id});
    // final String t = response.mapToString();
    return GroupEntity.fromMap(response);
  }

  @override
  Future<void> acceptInvitation(String invitationId) {
    return _client.put(_getUrl("AcceptInvitaton"),
        postData: {"invitationId": invitationId});
  }

  @override
  Future<void> rejectInvitation(String invitationId) {
    return _client.put(_getUrl("RejectInvitaton"),
        postData: {"invitationId": invitationId});
  }

  @override
  Future<void> rename(String groupId, String name) {
    return _client.put(_getUrl("RenameGroup"),
        postData: {"groupId": groupId, "name": name});
  }

  @override
  Future<void> setActiveGroup(String groupId) async {
    final res = await _client
        .put("/User/SetActiveGroup", postData: {"groupId": groupId});
    //_ALL it returns UserDto
    return;
    // return _client.put(_getUrl("SetActiveGroup"), postData: {"groupId": groupId});
  }

  @override
  Future<void> setPhoto(String groupId, String imgPath) {
    // TODO: implement setPhoto
    throw UnimplementedError();
  }

  @override
  Future<GroupEntity> attach(
      String groupId, String phoneNumber, bool flag) async {
    final String actionName = flag ? "AttachMember" : "DetachMember";
    final res = await _client.put(
      "/Group/$actionName",
      postData: {
        "groupId": groupId,
        "phoneNumber": phoneNumber,
      },
    );
    return GroupEntity.fromMap(res);
  }
}
