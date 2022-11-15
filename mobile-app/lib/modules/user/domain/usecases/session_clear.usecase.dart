import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_session.repo.dart';

class SessionClearUseCase implements IUseCase<void, void> {
  final ISessionRepo _repo;
  SessionClearUseCase(this._repo);

  @override
  Future<Either<IFailure, void>> call(void params) {
    return _repo.clearSession();
  }
}
