import '../../domain/entities/group_message.entity.dart';

abstract class IMessageDataSource {
  Future<List<GroupMessageEntity>> fetchMessages(String groupId);
  Future<bool> markMessageListened(String messageId);
}
