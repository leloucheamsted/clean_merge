import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';

abstract class IGroupService {
  Stream<GroupEntity> onGroup();
}
