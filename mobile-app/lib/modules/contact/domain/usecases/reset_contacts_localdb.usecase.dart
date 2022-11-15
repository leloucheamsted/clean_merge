import 'package:dartz/dartz.dart';

import 'package:tello_social_app/modules/contact/infra/datasources/i_contacts_local.datasource.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/repositories/either.mixin.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

class ResetContactsLocalDbUseCase with EitherMixin implements IUseCase<void, void> {
  final IContactsLocalDataSource _contactsLocalDataSource;

  ResetContactsLocalDbUseCase(this._contactsLocalDataSource);

  @override
  Future<Either<IFailure, void>> call(void params) {
    return runWithEither(() => _contactsLocalDataSource.resetDb());
  }
}
