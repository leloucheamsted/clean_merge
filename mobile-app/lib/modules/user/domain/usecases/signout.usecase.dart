import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_auth_phone_repo.dart';

class SignOutUseCase implements IUseCase<void, void> {
  final IAuthPhoneRepo repo;

  SignOutUseCase(this.repo);
  @override
  Future<Either<IFailure, void>> call(void params) {
    return repo.signOut();
  }
}
