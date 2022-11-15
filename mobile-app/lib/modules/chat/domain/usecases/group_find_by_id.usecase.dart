import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

import '../entities/group.entity.dart';
import '../repositories/i_group.repo.dart';

class GroupFindByIdUseCase implements IUseCase<GroupEntity, String> {
  final IGroupRepo repo;

  GroupFindByIdUseCase(this.repo);
  @override
  Future<Either<IFailure, GroupEntity>> call(String id) {
    return repo.findById(id);
  }
}
