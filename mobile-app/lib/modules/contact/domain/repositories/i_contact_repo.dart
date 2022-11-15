import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';

import '../../../core/error/failure.dart';

abstract class IContactRepo {
  // Stream<ContactEntity?>? get onContactSync;
  Future<Either<IFailure, List<ContactEntity>>> fetchContacts({String? keyword});
  Future<Either<IFailure, void>> saveContacts(List<ContactEntity> list);
  Future<Either<IFailure, void>> reset();
}
