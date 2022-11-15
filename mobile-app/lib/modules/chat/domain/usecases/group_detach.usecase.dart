import 'package:tello_social_app/modules/chat/domain/usecases/group_value_params.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

import '../entities/group.entity.dart';
import '../repositories/i_group.repo.dart';

class GroupDetachUseCase implements IUseCase<GroupEntity, GroupValueParams> {
  final IGroupRepo repo;

  GroupDetachUseCase(this.repo);
  @override
  Future<Either<IFailure, GroupEntity>> call(GroupValueParams params) {
    return repo.attach(params.groupId, params.value, false);
  }
}
