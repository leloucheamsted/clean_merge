import '../../domain/entities/contact.entity.dart';

abstract class IPhoneBookDataSource {
  Future<bool> requestPermission();
  Stream<ContactEntity?>? get onContactSync;
  Future<List<ContactEntity>> fetchContacts({String? keyword});
  Future<bool> addContact({
    required String phoneNumber,
    String? name,
  });
  Future<ContactEntity?> createContactUi();
}
