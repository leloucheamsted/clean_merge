import 'package:dartz/dartz.dart';

import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';
import 'package:tello_social_app/modules/contact/domain/repositories/i_contact_repo.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

class SaveContactsUseCase implements IUseCase<void, List<ContactEntity>> {
  final IContactRepo _repo;

  SaveContactsUseCase(this._repo);
  @override
  Future<Either<IFailure, void>> call(List<ContactEntity> list) {
    return _repo.saveContacts(list);
  }
}
