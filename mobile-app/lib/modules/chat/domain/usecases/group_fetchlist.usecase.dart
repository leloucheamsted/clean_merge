import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

import '../entities/group.entity.dart';
import '../repositories/i_group.repo.dart';

class GroupFetchListUseCase implements IUseCase<List<GroupEntity>, void> {
  final IGroupRepo repo;

  GroupFetchListUseCase(this.repo);
  @override
  Future<Either<IFailure, List<GroupEntity>>> call([void params]) {
    return repo.fetchGroups();
  }
}
