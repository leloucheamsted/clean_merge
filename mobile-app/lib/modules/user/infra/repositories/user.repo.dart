import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/repositories/base_repo.dart';
import 'package:tello_social_app/modules/user/domain/entities/app_user.dart';

import 'package:tello_social_app/modules/user/domain/repositories/iuser_repo.dart';

import 'package:tello_social_app/modules/user/infra/datasources/i_user.datasource.dart';

class UserRepo extends BaseRepo implements IUserRepo {
  final IUserDataSource remoteDataSource;
  UserRepo(this.remoteDataSource);

  @override
  Future<Either<IFailure, AppUser?>> getDetails({String? userId}) {
    return runWithEither(() => remoteDataSource.getDetails(userId: userId));
  }

  @override
  Future<Either<IFailure, void>> setDisplayName(String displaynName) {
    return runWithEither(() => remoteDataSource.setDisplayName(displaynName));
  }

  @override
  Future<Either<IFailure, void>> setPhoto(String imgPath) {
    // TODO: implement setPhoto
    throw UnimplementedError();
  }
}
