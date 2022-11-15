import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatabase {
  final String dbName;

  SqfliteDatabase(this.dbName);

  Database? _db; // db instace

  // Opens a db local file. Creates the db table if it's not yet created.
  Future<bool> initDb() async {
    try {
      // get database path directory
      final dbFolder = await getDatabasesPath();
      if (!await Directory(dbFolder).exists()) {
        await Directory(dbFolder).create(recursive: true);
      }
      final dbPath = join(dbFolder, dbName);
      // open db
      _db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, version) async {
          await _initDBtables(db);
        },
      );
      // success init db
      return true;
    } on DatabaseException catch (e) {
      // failed to init db
      print(e);
      return false;
    }
  }

  String? onCreateDb() {
    return null;

    return '''
          CREATE TABLE elou(
          id INTEGER PRIMARY KEY, 
          displayName TEXT,
          phoneNumber TEXT,
          lastMsg TEXT,
          lastMsgTime INTEGER
          )
        ''';
  }

  Future<void> _initDBtables(Database db) async {
    final String? createTableSql = onCreateDb();
    if (createTableSql != null) {
      await db.execute(createTableSql);
    }
  }

  /// Delete the database
  Future<void> deleteDB() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, dbName);
    await deleteDatabase(dbPath);
    _db = null;
  }

  /*Future<int> actionDelete(String table, {String? where, List<dynamic>? whereArgs}) async {
    await _initDb();
    // await _db!.rawQuery("drop table " + table);
    int affectedRows = await _db!.delete(table, where: where, whereArgs: whereArgs);
    return affectedRows;
  }

  /// delete contact entity from db contacts_table
  Future<void> deleteQuery(ContactEntity contactEntity) async {
    await _db.rawDelete('''
    DELETE FROM $_kDBTableContacts
    WHERE id = "${contactEntity.id}"
    ''');*/

}
