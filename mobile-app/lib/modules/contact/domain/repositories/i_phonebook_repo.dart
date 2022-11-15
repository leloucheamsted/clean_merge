import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';

import '../../../core/error/failure.dart';

abstract class IPhoneBookRepo {
  Stream<ContactEntity?>? get onContactSync;
  Future<Either<IFailure, List<ContactEntity>>> fetchContacts({String? keyword});
  Future<Either<IFailure, void>> saveContacts(List<ContactEntity> list);
  Future<Either<IFailure, bool>> addContact({
    required String phoneNumber,
    String? name,
  });
  Future<Either<IFailure, ContactEntity?>> createContactUi();
}
