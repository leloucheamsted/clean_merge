import 'package:tello_social_app/modules/chat/domain/usecases/group_value_params.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

import '../repositories/i_group.repo.dart';

class GroupRenameUseCase implements IUseCase<void, GroupValueParams> {
  final IGroupRepo repo;

  GroupRenameUseCase(this.repo);
  @override
  Future<Either<IFailure, void>> call(GroupValueParams params) {
    return repo.rename(params.groupId, params.value);
  }
}
