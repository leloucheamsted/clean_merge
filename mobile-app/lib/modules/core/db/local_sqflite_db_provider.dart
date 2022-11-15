import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'dart:io';
import 'package:path/path.dart' as $path;
import 'dart:async';

class LocalSqfliteDbProvider {
  Database? _db;
  final String _dbName = "app.db";
  final Lock _lock = Lock();

  final String Function()? onCreateDb;
  LocalSqfliteDbProvider(this.onCreateDb);

  Future<bool> shareDatabase() async {
    String path = await getDbFilePath();
    final dbExists = await databaseExists(path);
    if (!dbExists) {
      print("Database not exists to share");
      return false;
    }
    File dbFile = File(path);
    // CommonHelper.shareFile(dbFile);
    return true;
  }

  Future<bool> resetDatabase() async {
    String dbPath = await getDbFilePath();
    final dbExists = await databaseExists(dbPath);
    if (!dbExists) {
      print("Database not exists to delete");
      return false;
    }
    await deleteDatabase(dbPath);
    _db = null;
    return true;
    File dbFile = File(dbPath);
    try {
      await dbFile.delete();
      return true;
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }

  Future<String> getDbFilePath() async {
    String assetsDbPath = await getDatabasesPath();
    return $path.join(assetsDbPath, _dbName);
  }

  _copyFromAssets(String path) async {
    // var assetsDbPath = await getDatabasesPath();
    // var path = join(assetsDbPath, "app.db");
    String path = await getDbFilePath();
    // Make sure the parent directory exists
    try {
      await Directory($path.dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load($path.join("lib/assets", _dbName));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);
  }

  Future<Database?> _initDb() async {
    if (_db != null) return _db;

    await _lock.synchronized(() async {
      if (_db == null) {
        // String dbPath = await getDatabasesPath();

        final dbFolder = await getDatabasesPath();
        if (!await Directory(dbFolder).exists()) {
          await Directory(dbFolder).create(recursive: true);
        }
        // final dbPath = join(dbFolder, dbName);

        final dbPath = $path.join(dbFolder, _dbName);
        final dbExists = await databaseExists(dbPath);
        // if (!dbExists) {
        //   await _copyFromAssets(dbPath);
        // }
        // _db = await openDatabase(path, version: 2, readOnly: false);
        _db = await openDatabase(dbPath, version: 1, onCreate: onDbCreated);
        // _db = await openDatabase(dbPath, version: 1, onOpen: onDbOpened);
      }
    });
    return _db;
  }

  FutureOr<void> onDbCreated(Database db, int? version) async {
    // bool status = await  databaseExists(db.path);

    final String? createTableSql = onCreateDb?.call();
    if (createTableSql != null) {
      await db.execute(createTableSql);
    }
  }

  /*String? onCreateDb() {
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
  }*/

  Future<int> actionBatchInsert(
    String table,
    List<Map<String, dynamic>> list, {
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    await _initDb();
    final Batch batch = _db!.batch();

    // int i = 0, n = list.length;
    for (var item in list) {
      batch.insert(table, item, conflictAlgorithm: conflictAlgorithm ?? ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
    return 1;
  }

  Future<int> actionInsert(
    String table,
    Map<String, dynamic> values, {
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    await _initDb();
    final res = await _db!.insert(table, values, conflictAlgorithm: conflictAlgorithm ?? ConflictAlgorithm.replace);
    return res;
  }

  Future<int> actionUpdate(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    await _initDb();
    final res = await _db!.update(table, values,
        where: where, whereArgs: whereArgs, conflictAlgorithm: conflictAlgorithm ?? ConflictAlgorithm.replace);
    return res;
  }

  Future actionSelect(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    bool? distinct,
    List<String>? columns,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    await _initDb();
    return _db!.query(
      table,
      where: where,
      whereArgs: whereArgs,
      distinct: distinct,
      columns: columns,
      groupBy: groupBy,
      having: having,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> actionDelete(String table, {String? where, List<dynamic>? whereArgs}) async {
    await _initDb();
    // await _db!.rawQuery("drop table " + table);
    int affectedRows = await _db!.delete(table, where: where, whereArgs: whereArgs);
    return affectedRows;
  }

  Future actionRawQuery(String rawSql) async {
    await _initDb();
    // await _db!.rawQuery("drop table " + table);
    return _db!.rawQuery(rawSql);
  }
}
