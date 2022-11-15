import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/repositories/base_repo.dart';

import 'package:tello_social_app/modules/user/domain/repositories/i_session.repo.dart';
import 'package:tello_social_app/modules/user/infra/datasources/i_session.datasource.dart';

class SessionRepo extends BaseRepo implements ISessionRepo {
  final ISessionDataSource localDataSource;
  SessionRepo(this.localDataSource);

  @override
  Future<Either<IFailure, void>> clearSession() {
    return runWithEither(() => localDataSource.clearSession());
  }

  @override
  Future<Either<IFailure, String?>> getToken() {
    return runWithEither(() => localDataSource.getToken());
  }

  @override
  Future<Either<IFailure, bool>> get isExists => runWithEither(() => localDataSource.isExists);

  @override
  Future<Either<IFailure, void>> saveToken(String token) {
    return runWithEither(() => localDataSource.saveToken(token));
  }

  @override
  Future<Either<IFailure, String?>> getPhoneNumber() {
    return runWithEither(() => localDataSource.getPhoneNumber());
  }

  @override
  Future<Either<IFailure, void>> savePhone(String phoneNumber) {
    return runWithEither(() => localDataSource.savePhone(phoneNumber));
  }
}
