import 'package:dartz/dartz.dart';

import 'package:tello_social_app/modules/contact/domain/repositories/i_phonebook_repo.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

class AddContactUseCase implements IUseCase<void, AddContactInput> {
  final IPhoneBookRepo repo;

  AddContactUseCase(this.repo);

  @override
  Future<Either<IFailure, void>> call(AddContactInput params) {
    return repo.addContact(phoneNumber: params.phoneNumber, name: params.name);
  }
}

class AddContactInput {
  final String? name;
  final String phoneNumber;
  AddContactInput({
    this.name,
    required this.phoneNumber,
  });
}
