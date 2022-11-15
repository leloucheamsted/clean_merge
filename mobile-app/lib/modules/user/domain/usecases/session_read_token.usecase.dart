import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_session.repo.dart';

class SessionReadTokenUseCase implements IUseCase<String?, void> {
  final ISessionRepo _repo;
  SessionReadTokenUseCase(this._repo);

  @override
  Future<Either<IFailure, String?>> call(void params) {
    return _repo.getToken();
  }
}
