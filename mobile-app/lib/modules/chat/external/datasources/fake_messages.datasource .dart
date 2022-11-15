import 'dart:math';

import 'package:faker_dart/faker_dart.dart';
import 'package:tello_social_app/modules/chat/domain/entities/audio_file.entity.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_message.entity.dart';
import 'package:tello_social_app/modules/chat/infra/datasource/i_message_datasource.dart';
import 'package:tello_social_app/modules/core/mixins/faker_random.mixin.dart';
import 'package:uuid/uuid.dart';

import '../../../contact/domain/entities/contact.entity.dart';

class FakeMessagesDataSource with FakerRandomMixin implements IMessageDataSource {
  late final faker = Faker.instance;

  late Uuid uuid = const Uuid();
  final _random = Random();

  @override
  Future<List<GroupMessageEntity>> fetchMessages(String groupId) {
    final List<GroupMessageEntity> list = List.generate(5 + _random.nextInt(20), _createEntity);
    return returnWithDelay(list);
  }

  GroupMessageEntity _createEntity(int index) {
    return GroupMessageEntity(
      id: faker.datatype.number(min: 1).toString(),
      ownerId: faker.datatype.number(min: 1).toString(),
      groupId: faker.datatype.number(min: 1).toString(),
      // createdAt: faker.datatype.dateTime(min: 2022, max: 2022),
      createdAt: createDateTime(),
      hasListened: faker.datatype.boolean(),
      audioFile: _createAudioFileEntity(),
      contact: _createContactEntity(index),
    );
  }

  ContactEntity _createContactEntity(int index) {
    final bool isFemale = faker.datatype.boolean();
    return ContactEntity(
      displayName: faker.name.fullName(gender: isFemale ? Gender.female : Gender.male),
      phoneNumber: faker.phoneNumber.phoneNumber(
          format: "+###-###-###-####"), //- dashed phone format need to normalise in data repo level or entity
      uniqueId: uuid.v1(),
      phoneBookId: uuid.v5(Uuid.NAMESPACE_URL, 'www.tello.com'),
      // isAppUser: Random().nextBool(),
      isTelloMember: faker.datatype.boolean(),
      avatar: _generatePhoto(isFemale),
    );
  }

  String _generatePhoto(bool isFemale) {
    // https://randomuser.me/api/portraits/women/46.jpg
    final int n = faker.datatype.number(min: 1, max: 50);
    // final String gender = faker.datatype.boolean() ? "women" : "men";
    final String gender = isFemale ? "women" : "men";
    return "https://randomuser.me/api/portraits/$gender/$n.jpg";
    // faker.image.loremPixel.people();
  }

  AudioFileEntity _createAudioFileEntity() {
    return AudioFileEntity(
      duratonMs: faker.datatype.number(min: 5000).toInt(),
      mimeType: AudioFileMimeType.opus,
      url: _createAudioSource(),
    );
  }

  String _createAudioSource() {
    final List<String> files = [
      "https://scummbar.com/mi2/MI1-CD/01%20-%20Opening%20Themes%20-%20Introduction.mp3",
      "https://upload.wikimedia.org/wikipedia/commons/d/de/Lorem_ipsum.ogg"
    ];
    final int n = _random.nextInt(files.length - 1);
    return files[n];
  }

  @override
  Future<bool> markMessageListened(String messageId) {
    return returnWithDelay<bool>(faker.datatype.boolean());
  }
}
