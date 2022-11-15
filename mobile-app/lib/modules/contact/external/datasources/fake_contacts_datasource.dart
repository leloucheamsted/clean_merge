import 'package:faker_dart/faker_dart.dart';
import 'package:tello_social_app/modules/common/constants/dummy_data.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';
import 'package:tello_social_app/modules/contact/infra/datasources/i_phonebook.datasource.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_read_phone_number.usecase.dart';
import 'package:uuid/uuid.dart';

class FakeContactsDataSource implements IPhoneBookDataSource {
  final SessionReadPhoneNumberUseCase readPhoneNumberUseCase;
  late final faker = Faker.instance;

  String? _currentUserPhoneNumber;

  late Uuid uuid = const Uuid();
// +994555555555
  static final List<ContactEntity> _appContacts = DummyData.appContacts;

  FakeContactsDataSource(this.readPhoneNumberUseCase);

  @override
  Future<bool> addContact({required String phoneNumber, String? name}) {
    // TODO: implement addContact
    throw UnimplementedError();
  }

  @override
  Future<List<ContactEntity>> fetchContacts({String? keyword}) async {
    if (_currentUserPhoneNumber == null) {
      final res = await readPhoneNumberUseCase.call(null);
      res.fold((l) => print(l.toString()), (r) => _currentUserPhoneNumber = r);
    }
    // List<ContactEntity>.empty();
    final List<ContactEntity> list =
        _appContacts.where((element) => element.phoneNumber != _currentUserPhoneNumber).toList();

    // list.insert(0, element)
    if (keyword != null) {
      return _returnData(list
          .where(((element) =>
              element.displayName != null && element.displayName!.toLowerCase().contains(keyword.toLowerCase())))
          .toList());
    }

    return _returnData(list);
  }

  String _generatePhoto(bool isFemale) {
    // https://randomuser.me/api/portraits/women/46.jpg
    final int n = faker.datatype.number(min: 1, max: 50);
    // final String gender = faker.datatype.boolean() ? "women" : "men";
    final String gender = isFemale ? "women" : "men";
    return "https://randomuser.me/api/portraits/$gender/$n.jpg";
    // faker.image.loremPixel.people();
  }

  ContactEntity _createEntity(int index) {
    final bool isFemale = faker.datatype.boolean();
    return ContactEntity(
      displayName: faker.name.fullName(gender: isFemale ? Gender.female : Gender.male),
      phoneNumber: faker.phoneNumber.phoneNumber(
          format: "+###-##-###-####"), //- dashed phone format need to normalise in data repo level or entity
      uniqueId: uuid.v1(),
      phoneBookId: uuid.v5(Uuid.NAMESPACE_URL, 'www.tello.com'),
      // isAppUser: Random().nextBool(),
      isTelloMember: faker.datatype.boolean(),
      avatar: _generatePhoto(isFemale),
    );
  }

  @override
  // TODO: implement onContactSync
  Stream<ContactEntity?>? get onContactSync => null;

  @override
  Future<bool> requestPermission() => _returnData(true);

  Future<T> _returnData<T>(dynamic data) {
    return Future.delayed(const Duration(milliseconds: 500), () => data);
    // return Future.delayed(const Duration(seconds: 1), () => data);
  }

  @override
  Future<ContactEntity?> createContactUi() {
    // TODO: implement createContactUi
    throw UnimplementedError();
  }
}
