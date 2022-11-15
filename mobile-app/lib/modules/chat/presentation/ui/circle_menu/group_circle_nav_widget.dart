import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_member.entity.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_ptt_member.entity.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/circle_menu/connector_widget.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/members/member_avatar_circle.dart';
import 'package:tello_social_app/modules/common/widget/circle_container.dart';

import 'circle_menu_widget.dart';

class GroupCircleNavWidget extends StatefulWidget {
  // final int total;
  final List<GroupMemberEntity> members;
  final List<GroupPttMemberEntity> attachedMembers;
  final Color activeColor;
  final Curve connectorAnimationCurve;
  final bool isOwner;
  final VoidCallback onAddAction;
  final Function(String, bool) onDragDropped;
  final Widget? centerWidget;
  const GroupCircleNavWidget({
    Key? key,
    required this.members,
    required this.attachedMembers,
    required this.onAddAction,
    required this.onDragDropped,
    this.activeColor = Colors.green,
    this.isOwner = true,
    this.connectorAnimationCurve = Curves.elasticOut,
    this.centerWidget,
  }) : super(key: key);

  @override
  State<GroupCircleNavWidget> createState() => _GroupCircleNavWidgetState();
}

class _GroupCircleNavWidgetState extends State<GroupCircleNavWidget> {
  final int maxItems = 8;
  List<int> activeIndexes = [];

  void calculateActiveIndexes() {
    activeIndexes = widget.attachedMembers
        .map((e) => widget.members.indexWhere((member) => member.phoneNumber == e.phoneNumber))
        .toList();
  }

  @override
  void initState() {
    calculateActiveIndexes();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GroupCircleNavWidget oldWidget) {
    calculateActiveIndexes();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CircleMenuWidget(
      startAngle: -15,
      colorInteractive: widget.activeColor,
      connectorAnimationCurve: widget.connectorAnimationCurve,
      itemCount: widget.members.length,
      fixedLength: 8,
      activeIndexes: activeIndexes,
      // items: circleMenuItemList,
      radius: MediaQuery.of(context).size.width * .8 * .6,
      checkIsDraggable: (int index) => widget.members.length > index,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(index);
      },
      itemRadius: kMinInteractiveDimension - 10,
      onDrop: _onDrop,
      centerWidget: widget.centerWidget,
      dropTargetWidget: CircleContainer(color: widget.activeColor),
      connectorBuilder: (Color color) => ConnectorWidget(color: color),
    );
  }

  Widget _buildItem(int i) {
    final bool isDataItem = i < widget.members.length;
    return isDataItem ? _buildDataItem(i) : _buildNoDataItem();
  }

  Widget _buildNoDataItem() {
    return widget.isOwner ? _buildAddItem() : const CircleContainer(color: Colors.grey);
  }

  Widget _buildAddItem() {
    return GestureDetector(
      onTap: widget.onAddAction,
      child: const CircleContainer(
        // width: 50,
        // height: 50,
        color: Colors.grey,
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }

  // ContactEntity getEntity(int i) => DummyData.appContacts[i];
  GroupMemberEntity getEntity(int i) => widget.members[i];
  Widget _buildDataItem(int i) {
    final entity = getEntity(i);
    return MemberAvatarCircle(entity: entity);
  }

  void _onDrop(int id) {
    final bool flagContains = activeIndexes.contains(id);
    final GroupMemberEntity entity = getEntity(id);
    widget.onDragDropped(entity.phoneNumber, !flagContains);

    return;
    if (flagContains) {
      activeIndexes.remove(id);
    } else {
      activeIndexes.add(id);
    }
    setState(() {});
  }
}
