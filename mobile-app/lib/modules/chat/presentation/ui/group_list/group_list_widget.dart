import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/core/presentation/list/list_widget.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import 'group_list_item.dart';

class GroupListWidget extends StatelessWidget {
  final List<GroupEntity> items;
  final Function(int)? onItemDeletePressed;
  const GroupListWidget({
    Key? key,
    required this.items,
    this.onItemDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListWidget(itemCount: items.length, itemBuilder: _itemBuilder);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final GroupEntity item = items[index];
    return GestureDetector(
        onTap: () => Modular.to.pushNamed(AppRoute.groupDetail.withIdParam(item.id)),
        child: GroupListItem(
          entity: item,
          onItemDeletePressed: () => onItemDeletePressed?.call(index),
          onSetActivePressed: () {},
        ));
  }
}
