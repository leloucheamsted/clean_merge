import 'package:dartz/dartz.dart';

import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';
import 'package:tello_social_app/modules/contact/domain/repositories/i_contact_repo.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

class FetchContactsUseCase implements IUseCase<List<ContactEntity>, ContactFilterInput?> {
  final IContactRepo _repo;

  FetchContactsUseCase(this._repo);
  @override
  Future<Either<IFailure, List<ContactEntity>>> call(ContactFilterInput? params) {
    return _repo.fetchContacts(keyword: params?.keyword);
  }
}

class ContactFilterInput {
  final String? keyword;
  ContactFilterInput({
    this.keyword,
  });
}
