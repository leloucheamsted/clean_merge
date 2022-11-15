import '../../domain/entities/group.entity.dart';

abstract class IGroupDataSource {
  Future<GroupEntity> create(Map<String, dynamic> data, {String? avatarFilePath});
  Future<GroupEntity> findById(String id);
  Future<List<GroupEntity>> fetchGroups(); //fetch user related groups either owner or a member of
  // Future<List<GroupMessageEntity>> fetchMessages(String groupId);
  Future<void> setActiveGroup(String groupId);

  Future<GroupEntity> addUserToGroup({required String phoneNumber, required String groupId});
  Future<GroupEntity> removeUserFromGroup({required String phoneNumber, required String groupId});

  Future<void> delete(String groupId);
  Future<void> rename(String groupId, String name);
  Future<GroupEntity> attach(String groupId, String phoneNumber, bool flag);
  Future<void> setPhoto(String groupId, String imgPath);

  Future<void> acceptInvitation(String invitationId);
  Future<void> rejectInvitation(String invitationId);
}
