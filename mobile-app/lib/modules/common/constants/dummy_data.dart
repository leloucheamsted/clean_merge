import '../../contact/domain/entities/contact.entity.dart';

class DummyData {
  static final List<ContactEntity> appContacts = [
    ContactEntity(
        phoneNumber: "+994552222222", uniqueId: "2", phoneBookId: "44", displayName: "Air Jordan", isTelloMember: true),
    ContactEntity(
        phoneNumber: "+994553333333",
        uniqueId: "3",
        phoneBookId: "44",
        displayName: "Emre Aliyev",
        isTelloMember: true),
    ContactEntity(
        phoneNumber: "+994554444444", uniqueId: "4", phoneBookId: "44", displayName: "John Nolan", isTelloMember: true),
    ContactEntity(
        phoneNumber: "+994555555555",
        uniqueId: "5",
        phoneBookId: "55",
        displayName: "Johny Wicker",
        isTelloMember: true),
    ContactEntity(
      phoneNumber: "+994556666666",
      uniqueId: "6",
      phoneBookId: "66",
      displayName: "Elon Mosquito",
    ),
    ContactEntity(
      phoneNumber: "+994557777777",
      uniqueId: "7",
      phoneBookId: "77",
      displayName: "James Browny",
    ),
    ContactEntity(
      phoneNumber: "+994558888888",
      uniqueId: "8",
      phoneBookId: "88",
      displayName: "Arnold Schwarzkopf",
      avatar: "https://d12b272cvzgshl.cloudfront.net/40a5ec76-e23d-406f-8b20-3c7567ea786f..jpg",
    ),
    ContactEntity(
      phoneNumber: "+994559999999",
      uniqueId: "9",
      phoneBookId: "99",
      displayName: "Anders Holch Povlsen",
    ),
  ];
}
