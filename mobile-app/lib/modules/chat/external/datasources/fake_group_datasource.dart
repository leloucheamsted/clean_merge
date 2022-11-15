import 'dart:math';

import 'package:faker_dart/faker_dart.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/infra/datasource/i_group_datasource.dart';
import 'package:tello_social_app/modules/core/mixins/faker_random.mixin.dart';
import 'package:uuid/uuid.dart';

class FakeGroupDataSource with FakerRandomMixin implements IGroupDataSource {
  late final faker = Faker.instance;

  late Uuid uuid = const Uuid();
  final _random = Random();

  final List<GroupEntity> _groups = [];

  Future<T> _returnData<T>(dynamic data) {
    return Future.delayed(const Duration(seconds: 1), () => data);
  }

  @override
  Future<GroupEntity> addUserToGroup({required String phoneNumber, required String groupId}) {
    // TODO: implement addUserToGroup
    throw UnimplementedError();
  }

  @override
  Future<GroupEntity> create(Map<String, dynamic> data, {String? avatarFilePath}) {
    data["createdAt"] = DateTime.now().millisecondsSinceEpoch;
    final GroupEntity entity = GroupEntity.fromMap(data);
    _groups.add(entity);
    return returnWithDelay(entity);
  }

  @override
  Future<bool> delete(String groupId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<GroupEntity>> fetchGroups() {
    late List<GroupEntity> list;
    if (_groups.isNotEmpty) {
      list = _groups;
    } else {
      list = List.generate(5 + _random.nextInt(20), _createEntity);
      _groups.addAll(list);
    }

    return returnWithDelay(list);
  }

  @override
  Future<GroupEntity> findById(String id) {
    return returnWithDelay(_createEntity(0));
  }

  GroupEntity _createEntity(int index) {
    return GroupEntity(
      id: faker.datatype.number(min: 1).toString(),
      owner: faker.datatype.number(min: 1).toString(),
      name: faker.lorem.word(),
      createdAt: createDateTime(),
      isOwner: faker.datatype.boolean(),
      isActive: faker.datatype.boolean(),
      members: [],
      attachedMembers: [],
      membersCount: 0,
    );
  }

  @override
  Future<GroupEntity> removeUserFromGroup({required String phoneNumber, required String groupId}) {
    // TODO: implement removeUserFromGroup
    throw UnimplementedError();
  }

  @override
  Future<bool> rename(String groupId, String name) {
    // TODO: implement rename
    throw UnimplementedError();
  }

  @override
  Future<void> setActiveGroup(String groupId) {
    // TODO: implement setActiveGroup
    throw UnimplementedError();
  }

  @override
  Future<bool> setPhoto(String groupId, String imgPath) {
    // TODO: implement setPhoto
    throw UnimplementedError();
  }

  @override
  Future<void> acceptInvitation(String groupId) {
    return _returnData(null);
  }

  @override
  Future<void> rejectInvitation(String groupId) {
    return _returnData(null);
  }

  @override
  Future<GroupEntity> attach(String groupId, String name, bool flag) {
    // TODO: implement attach
    throw UnimplementedError();
  }
}
