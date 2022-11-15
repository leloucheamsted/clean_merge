import 'package:dartz/dartz.dart';

import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/repositories/either.mixin.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

import '../repositories/i_contact_repo.dart';

class ResetContactsRepoUseCase with EitherMixin implements IUseCase<void, void> {
  final IContactRepo _repo;

  ResetContactsRepoUseCase(this._repo);

  @override
  Future<Either<IFailure, void>> call(void params) {
    return runWithEither(() => _repo.reset());
  }
}
