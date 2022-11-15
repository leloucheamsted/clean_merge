import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';
import 'package:tello_social_app/modules/contact/external/datasources/phone_number_helper.dart';
import 'package:tello_social_app/modules/contact/infra/datasources/i_phonebook.datasource.dart';

class FlutterContactsDataSource implements IPhoneBookDataSource {
  @override
  Future<bool> addContact({required String phoneNumber, String? name}) {
    final Contact contact = Contact(phones: [Phone(phoneNumber)]);
    FlutterContacts.insertContact(contact);
    return Future.value(true);
  }

  @override
  Future<List<ContactEntity>> fetchContacts({String? keyword}) async {
    //TODO: replace find plugin with search by contact name support
    final bool perm = await FlutterContacts.requestPermission(readonly: true);
    if (!perm) {
      throw Exception("Need Contact Read Permission");
    }
    final List<Contact> list = await FlutterContacts.getContacts(withProperties: true);
    final List<Contact> listWithPhoneNumbers = list.where((element) => element.phones.isNotEmpty).toList();
    return listWithPhoneNumbers.map(_mapToEntity).toList();
  }

  ContactEntity _mapToEntity(Contact contact) => ContactEntity(
        phoneNumber: PhoneNumberHelper.fixIt(contact.phones[0].number),
        uniqueId: contact.id,
        phoneBookId: contact.id,
        isTelloMember: false,
        displayName: contact.displayName,
        // image: contact.photo
      );

  @override
  // TODO: implement onContactSync
  Stream<ContactEntity?>? get onContactSync => null;

  @override
  Future<bool> requestPermission() {
    return FlutterContacts.requestPermission();
  }

  @override
  Future<ContactEntity?> createContactUi() async {
    final Contact? contact = await FlutterContacts.openExternalInsert();
    if (contact == null) {
      return null;
    }
    return _mapToEntity(contact);
  }
}
