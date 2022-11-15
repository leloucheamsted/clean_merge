import 'i_contacts.datasource.dart';

abstract class IContactsLocalDataSource extends IContactsDataSource {
  Future<void> resetDb();
}
