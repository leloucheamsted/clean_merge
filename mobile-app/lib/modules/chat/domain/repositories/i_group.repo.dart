import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';

abstract class IGroupRepo {
  Future<Either<IFailure, GroupEntity>> create(Map<String, dynamic> data, {String? avatarFilePath});
  Future<Either<IFailure, GroupEntity>> attach(String groupId, String phoneNumber, bool flag);
  Future<Either<IFailure, void>> rename(String groupId, String name);
  Future<Either<IFailure, void>> delete(String groupId);
  Future<Either<IFailure, void>> setPhoto(String groupId, String imgPath);
  // Future<Either<GroupFailure, bool>> setPhoto(String groupId,Map<String, dynamic> data);
  Future<Either<IFailure, GroupEntity>> findById(String id);

  //fetch user related groups either owner or a member of. user_id should handle on backend via token
  Future<Either<IFailure, List<GroupEntity>>> fetchGroups();
  Future<Either<IFailure, void>> setActiveGroup(String groupId);
  Future<Either<IFailure, GroupEntity>> addUserToGroup({required String phoneNumber, required String groupId});
  Future<Either<IFailure, GroupEntity>> removeUserFromGroup({required String phoneNumber, required String groupId});

  Future<Either<IFailure, void>> acceptInvitation(String groupId);
  Future<Either<IFailure, void>> rejectInvitation(String groupId);
}
