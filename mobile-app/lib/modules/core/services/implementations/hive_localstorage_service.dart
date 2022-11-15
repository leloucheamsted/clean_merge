import '../interfaces/ilocalstorage_service.dart';

class HiveLocalStorageService implements ILocalStorageService {
  @override
  bool containsEntry(String boxKey, String id) {
    // TODO: implement containsEntry
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllEntries(String boxKey) {
    // TODO: implement deleteAllEntries
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEntry(String boxKey, String id) {
    // TODO: implement deleteEntry
    throw UnimplementedError();
  }

  @override
  List<Map> getAllEntries(String boxKey) {
    // TODO: implement getAllEntries
    throw UnimplementedError();
  }

  @override
  Map? getEntry(String boxKey, String id) {
    // TODO: implement getEntry
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<void> registerUninitializedBox(String name) {
    // TODO: implement registerUninitializedBox
    throw UnimplementedError();
  }

  @override
  Future<void> saveAllEntries(String boxKey, Map entries) {
    // TODO: implement saveAllEntries
    throw UnimplementedError();
  }

  @override
  Future<void> saveEntry(String boxKey, String id, Map object) {
    // TODO: implement saveEntry
    throw UnimplementedError();
  }
}
