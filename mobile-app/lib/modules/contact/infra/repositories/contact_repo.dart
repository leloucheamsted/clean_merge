import 'dart:developer';

import 'package:tello_social_app/modules/contact/infra/datasources/i_contacts_local.datasource.dart';
import 'package:tello_social_app/modules/contact/infra/datasources/i_contacts_remote.datasource.dart';
import 'package:tello_social_app/modules/contact/infra/datasources/i_phonebook.datasource.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';

import '../../../core/repositories/base_repo.dart';
import '../../domain/entities/contact.entity.dart';
import '../../domain/repositories/i_contact_repo.dart';

class ContactRepo extends BaseRepo implements IContactRepo {
  final IContactsLocalDataSource localDataSource;
  final IContactsRemoteDataSource remoteDataSource;
  final IPhoneBookDataSource phoneBookDataSource;

  bool _phoneBookFetched = false;
  bool _remoteFetched = false;
  ContactRepo(this.localDataSource, this.remoteDataSource, this.phoneBookDataSource);

  @override
  Future<Either<IFailure, List<ContactEntity>>> fetchContacts({String? keyword}) {
    return runWithEither(() => _fetchContacts(keyword: keyword));
  }

  Future<List<ContactEntity>> _fetchContacts({String? keyword}) async {
    // return remoteDataSource.fetchContacts();
    List<ContactEntity> res;
    // _phoneBookFetched = true;
    if (!_phoneBookFetched) {
      res = await phoneBookDataSource.fetchContacts();
      if (res.isNotEmpty) {
        await localDataSource.saveContacts(res);
        //TODO get diff and from phonebook and upload isDirty _ALL
        try {
          await remoteDataSource.saveContacts(res);
        } catch (ex) {
          log("Failed.remoteDataSource.saveContacts $ex");
        }
      }
      _phoneBookFetched = true;
    }

    if (!_remoteFetched) {
      res = await remoteDataSource.fetchContacts();
      if (res.isNotEmpty) {
        await localDataSource.saveContacts(res);
      }
      _remoteFetched = true;
    } else {
      res = await localDataSource.fetchContacts(keyword: keyword);
    }

    if (res.isEmpty && (keyword == null || keyword.isEmpty)) {
      res = await remoteDataSource.fetchContacts(keyword: keyword);
      if (res.isNotEmpty) {
        await localDataSource.saveContacts(res);
      }
    }
    return res;
  }

  // @override
  // Stream<ContactEntity?>? get onContactSync => contactsDataSource.onContactSync;

  @override
  Future<Either<IFailure, void>> saveContacts(List<ContactEntity> list) {
    return runWithEither(() => _saveContacts(list));
  }

  Future<void> _saveContacts(List<ContactEntity> list) async {
    await localDataSource.saveContacts(list);
    await remoteDataSource.saveContacts(list);
  }

  @override
  Future<Either<IFailure, void>> reset() {
    _phoneBookFetched = false;
    return runWithEither(() => localDataSource.resetDb());
  }
}
