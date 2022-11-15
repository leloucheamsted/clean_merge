import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_session.repo.dart';

class SessionSavePhoneNumberUseCase implements IUseCase<void, String> {
  final ISessionRepo _repo;
  SessionSavePhoneNumberUseCase(this._repo);

  @override
  Future<Either<IFailure, void>> call(String phoneNumber) {
    return _repo.savePhone(phoneNumber);
  }
}
