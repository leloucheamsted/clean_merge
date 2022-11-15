import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/chat/domain/repositories/i_group.repo.dart';

import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

class GroupSetActiveUseCase implements IUseCase<void, String> {
  final IGroupRepo repo;

  GroupSetActiveUseCase(this.repo);
  @override
  Future<Either<IFailure, void>> call(String groupId) {
    return repo.setActiveGroup(groupId);
  }
}
