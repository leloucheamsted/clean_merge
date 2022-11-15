import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/chat/domain/repositories/i_group.repo.dart';

import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

import '../entities/group.entity.dart';
import 'input_group_member_usecase.dart';

class GroupRemoveMemberUseCase implements IUseCase<GroupEntity, InputGroupMemberUsecase> {
  final IGroupRepo repo;

  GroupRemoveMemberUseCase(this.repo);
  @override
  Future<Either<IFailure, GroupEntity>> call(params) {
    return repo.removeUserFromGroup(groupId: params.groupId, phoneNumber: params.phoneNumber);
  }
}
