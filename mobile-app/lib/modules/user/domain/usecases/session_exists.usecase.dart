import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_session.repo.dart';

class SessionExistsUseCase implements IUseCase<bool, void> {
  final ISessionRepo _repo;
  SessionExistsUseCase(this._repo);

  @override
  Future<Either<IFailure, bool>> call(void params) {
    return _repo.isExists;
  }
}
