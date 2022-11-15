import 'package:tello_social_app/modules/contact/domain/repositories/i_phonebook_repo.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';

import '../../../core/repositories/base_repo.dart';
import '../../domain/entities/contact.entity.dart';
import '../datasources/i_phonebook.datasource.dart';

class PhoneBook extends BaseRepo implements IPhoneBookRepo {
  final IPhoneBookDataSource phoneBookDataSource;

  PhoneBook(this.phoneBookDataSource);

  @override
  Future<Either<IFailure, bool>> addContact({required String phoneNumber, String? name}) {
    return runWithEither(() => phoneBookDataSource.addContact(phoneNumber: phoneNumber));
  }

  @override
  Future<Either<IFailure, List<ContactEntity>>> fetchContacts({String? keyword}) {
    return runWithEither(() => phoneBookDataSource.fetchContacts(keyword: keyword));
  }

  @override
  Stream<ContactEntity?>? get onContactSync => phoneBookDataSource.onContactSync;

  @override
  Future<Either<IFailure, ContactEntity?>> createContactUi() =>
      runWithEither(() => phoneBookDataSource.createContactUi());

  @override
  Future<Either<IFailure, void>> saveContacts(List<ContactEntity> list) {
    // TODO: implement saveContacts
    throw UnimplementedError();
  }
}
