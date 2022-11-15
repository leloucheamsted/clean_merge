import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';
import 'package:tello_social_app/modules/contact/infra/datasources/i_contacts_local.datasource.dart';
import 'package:tello_social_app/modules/core/db/local_sqflite_db_provider.dart';

import '../../infra/datasources/i_contacts.datasource.dart';

class SqfliteContactsDataSource implements IContactsLocalDataSource {
  final String tableName = "contacts";
  late final LocalSqfliteDbProvider _dbProvider = LocalSqfliteDbProvider(onCreateDb);

  // SqfliteContactsDataSource() {}
  @override
  Future<List<ContactEntity>> fetchContacts({String? keyword, ContactsFilterParam? filter}) async {
    final response = await _dbProvider.actionSelect(
      tableName,
      where: keyword == null || keyword.isEmpty ? null : "displayName like ?",
      whereArgs: keyword == null || keyword.isEmpty ? null : ["%$keyword%"],
    );
    /*final response = keyword == null || keyword.isEmpty
        ? await _dbProvider.actionSelect(tableName)
        : await _dbProvider.actionRawQuery(
            "select * from $tableName where displayName like %$keyword%",
          );*/
    return List<ContactEntity>.from(response.map(_mapFromDb));
  }

  ContactEntity _mapFromDb(Map<String, dynamic> map) => ContactEntity(
        userId: map['userId'],
        uniqueId: map['uniqueId'],
        phoneBookId: map['phoneBookId'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        displayName: map['displayName'],
        avatar: map['avatar'],
        isTelloMember: map['isTelloMember'] == 1,
        // isOnline: map['isOnline'],
        // isMember: map['isMember'] ?? false,
      );

  @override
  Future<void> saveContacts(List<ContactEntity> list) {
    final List<Map<String, dynamic>> mapList = list.map(_mapToDb).toList();
    return _dbProvider.actionBatchInsert(tableName, mapList);
  }

  Map<String, dynamic> _mapToDb(ContactEntity entity) => {
        "userId": entity.userId,
        "uniqueId": entity.uniqueId,
        "phoneBookId": entity.phoneBookId,
        "phoneNumber": entity.phoneNumber,
        "displayName": entity.displayName,
        "avatar": entity.avatar,
        "isTelloMember": entity.isTelloMember ? 1 : 0
      };

  String onCreateDb() {
    return '''
          CREATE TABLE $tableName(
          id INTEGER PRIMARY KEY, 
          userId TEXT,
          uniqueId TEXT,
          phoneBookId TEXT UNIQUE,
          phoneNumber TEXT UNIQUE,
          displayName TEXT,
          isTelloMember INTEGER,
          avatar TEXT,
          isDirty INTEGER default 0,
          lastSyncTime INTEGER default 0
          )
          ''';
  }

  @override
  Future<void> resetDb() async {
    // _dbProvider.actionDelete(tableName);
    await _dbProvider.actionRawQuery("drop table $tableName");
    await _dbProvider.resetDatabase();
  }
}
