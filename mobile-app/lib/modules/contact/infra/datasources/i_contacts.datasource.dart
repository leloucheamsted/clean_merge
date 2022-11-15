import '../../domain/entities/contact.entity.dart';

abstract class IContactsDataSource {
  Future<List<ContactEntity>> fetchContacts({String? keyword, ContactsFilterParam? filter});
  Future<void> saveContacts(List<ContactEntity> list);
}

class ContactsFilterParam {
  final String? keyword;
  final List<String>? idList;
  final List<String>? phoneNumberList;

  ContactsFilterParam({
    this.keyword,
    this.idList,
    this.phoneNumberList,
  });
}
