import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_member.entity.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_message.entity.dart';
import 'package:tello_social_app/modules/core/presentation/list/list_widget.dart';

import 'member_list_item.dart';

class MemberListWidget extends StatelessWidget {
  final List<GroupMemberEntity> items;
  final Function(String)? onMemberRemoveBtn;
  const MemberListWidget({
    Key? key,
    required this.items,
    this.onMemberRemoveBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListWidget(itemCount: items.length, itemBuilder: _itemBuilder);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final GroupMemberEntity item = items[index];
    return MemberListItem(entity: item, onMemberRemoveBtn: onMemberRemoveBtn);
  }
}
