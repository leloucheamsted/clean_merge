import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

import '../repositories/i_group.repo.dart';
import 'group_value_params.dart';

class GroupSetPhotoUseCase implements IUseCase<void, GroupValueParams> {
  final IGroupRepo repo;

  GroupSetPhotoUseCase(this.repo);
  @override
  Future<Either<IFailure, void>> call(GroupValueParams params) {
    return repo.setPhoto(params.groupId, params.value);
  }
}
