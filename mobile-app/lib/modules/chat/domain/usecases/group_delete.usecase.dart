import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

import '../repositories/i_group.repo.dart';

class GroupDeleteUseCase implements IUseCase<void, String> {
  final IGroupRepo repo;

  GroupDeleteUseCase(this.repo);
  @override
  Future<Either<IFailure, void>> call(String id) {
    return repo.delete(id);
  }
}
