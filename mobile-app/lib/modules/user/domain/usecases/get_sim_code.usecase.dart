import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';
import 'package:tello_social_app/modules/user/domain/repositories/i_sim_country.repo.dart';

class GetSimCodeUseCase implements IUseCase<String?, void> {
  final ISimCountryRepo repo;

  GetSimCodeUseCase(this.repo);

  @override
  Future<Either<IFailure, String?>> call(void params) {
    return repo.getSIMCountryCode();
  }
}
