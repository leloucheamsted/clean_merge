import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/user/domain/repositories/iuser_repo.dart';

import '../../../core/usecases/iusecase.dart';

class UserRenameUseCase implements IUseCase<void, String> {
  final IUserRepo repo;

  UserRenameUseCase(this.repo);

  @override
  Future<Either<IFailure, void>> call(String value) {
    return repo.setDisplayName(value);
  }
}
