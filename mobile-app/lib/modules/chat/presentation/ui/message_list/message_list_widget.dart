import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_message.entity.dart';
import 'package:tello_social_app/modules/core/presentation/list/list_widget.dart';

import 'message_list_item.dart';

class MessageListWidget extends StatelessWidget {
  final List<GroupMessageEntity> items;
  const MessageListWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListWidget(itemCount: items.length, itemBuilder: _itemBuilder);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final GroupMessageEntity item = items[index];
    return MessageListItem(entity: item);
  }
}
