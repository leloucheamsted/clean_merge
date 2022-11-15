import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/user/domain/entities/app_user.dart';
import 'package:tello_social_app/modules/user/domain/repositories/iuser_repo.dart';

import '../../../core/usecases/iusecase.dart';

class UserGetDetailsUseCase implements IUseCase<AppUser?, String?> {
  final IUserRepo repo;

  UserGetDetailsUseCase(this.repo);

  @override
  Future<Either<IFailure, AppUser?>> call(String? params) {
    return repo.getDetails(userId: params);
  }
}
