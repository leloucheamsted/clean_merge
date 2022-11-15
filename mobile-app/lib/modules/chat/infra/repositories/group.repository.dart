import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/domain/repositories/i_group.repo.dart';
import 'package:tello_social_app/modules/chat/infra/datasource/i_group_datasource.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/repositories/base_repo.dart';

class GroupRepository extends BaseRepo implements IGroupRepo {
  final IGroupDataSource _dataSource;

  GroupRepository(this._dataSource);

  @override
  Future<Either<IFailure, GroupEntity>> addUserToGroup({required String phoneNumber, required String groupId}) {
    return runWithEither(() => _dataSource.addUserToGroup(phoneNumber: phoneNumber, groupId: groupId));
  }

  @override
  Future<Either<IFailure, GroupEntity>> removeUserFromGroup({required String phoneNumber, required String groupId}) {
    return runWithEither(() => _dataSource.removeUserFromGroup(phoneNumber: phoneNumber, groupId: groupId));
  }

  @override
  Future<Either<IFailure, GroupEntity>> create(Map<String, dynamic> data, {String? avatarFilePath}) {
    return runWithEither<GroupEntity>(() => _dataSource.create(data, avatarFilePath: avatarFilePath));
  }

  @override
  Future<Either<IFailure, List<GroupEntity>>> fetchGroups() async {
    return runWithEither<List<GroupEntity>>(() => _dataSource.fetchGroups());
  }

  @override
  Future<Either<IFailure, GroupEntity>> findById(String id) async {
    return runWithEither<GroupEntity>(() => _dataSource.findById(id));
  }

  @override
  Future<Either<IFailure, void>> delete(String groupId) {
    return runWithEither<void>(() => _dataSource.delete(groupId));
  }

  @override
  Future<Either<IFailure, void>> rename(String groupId, String name) {
    return runWithEither<void>(() => _dataSource.rename(groupId, name));
  }

  @override
  Future<Either<IFailure, void>> setPhoto(String groupId, String imgPath) {
    return runWithEither<void>(() => _dataSource.setPhoto(groupId, imgPath));
  }

  @override
  Future<Either<IFailure, void>> setActiveGroup(String groupId) {
    return runWithEither<void>(() => _dataSource.setActiveGroup(groupId));
  }

  @override
  Future<Either<IFailure, void>> acceptInvitation(String invitationId) {
    return runWithEither<void>(() => _dataSource.acceptInvitation(invitationId));
  }

  @override
  Future<Either<IFailure, void>> rejectInvitation(String invitationId) {
    return runWithEither<void>(() => _dataSource.rejectInvitation(invitationId));
  }

  @override
  Future<Either<IFailure, GroupEntity>> attach(
    String groupId,
    String phoneNumber,
    bool flag,
  ) {
    return runWithEither(() => _dataSource.attach(groupId, phoneNumber, flag));
  }
}
