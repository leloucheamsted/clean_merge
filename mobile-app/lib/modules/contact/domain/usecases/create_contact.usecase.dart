import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';

import 'package:tello_social_app/modules/contact/domain/repositories/i_phonebook_repo.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

class CreateContactUseCase implements IUseCase<ContactEntity?, void> {
  final IPhoneBookRepo repo;

  CreateContactUseCase(this.repo);

  @override
  Future<Either<IFailure, ContactEntity?>> call(void params) {
    return repo.createContactUi();
  }
}
