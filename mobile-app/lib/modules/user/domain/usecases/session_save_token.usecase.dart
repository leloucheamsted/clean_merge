import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_session.repo.dart';

class SessionSaveTokenUseCase implements IUseCase<void, String> {
  final ISessionRepo _repo;
  SessionSaveTokenUseCase(this._repo);

  @override
  Future<Either<IFailure, void>> call(String token) {
    return _repo.saveToken(token);
  }
}
