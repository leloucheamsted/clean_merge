import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';
import 'package:tello_social_app/modules/contact/infra/datasources/i_contacts_local.datasource.dart';
import 'package:tello_social_app/modules/contact/infra/datasources/i_contacts_remote.datasource.dart';
import 'package:tello_social_app/modules/contact/infra/datasources/i_phonebook.datasource.dart';

class ContactSyncService {
  //run on app bootstrap
  final IPhoneBookDataSource phoneBookDataSource;
  final IContactsLocalDataSource localDataSource;
  final IContactsRemoteDataSource remoteDataSource;

  ContactSyncService({
    required this.phoneBookDataSource,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  void actionSync() async {
    List<ContactEntity> list;
    list = await phoneBookDataSource.fetchContacts();
    if (list.isNotEmpty) {
      await localDataSource.saveContacts(list);
      //get dirty contacts and upload remote
      await remoteDataSource.saveContacts(list);
    }
  }
}
