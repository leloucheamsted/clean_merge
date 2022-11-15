import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widgets.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/widget/buttons/check_icon.dart';

class GroupListItem extends StatefulWidget {
  final GroupEntity entity;
  final Function? onItemDeletePressed;
  final Function() onSetActivePressed;
  const GroupListItem({
    Key? key,
    required this.entity,
    required this.onSetActivePressed,
    this.onItemDeletePressed,
  }) : super(key: key);

  @override
  State<GroupListItem> createState() => _GroupListItemState();
}

class _GroupListItemState extends State<GroupListItem> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Text("kro");
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(LayoutConstants.paddingS),
        leading: ImgLogoWidget(
          imgSrc: widget.entity.avatar,
          borderColor: Colors.green,
          borderWidth: 4,
        ),
        title: Text(widget.entity.name),
        subtitle: _buildSubTitle(),
      ),
    );
  }

  Widget _buildSubTitle() {
    final String n = widget.entity.membersCount.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text(DateHelper.dateToText(widget.entity.createdAt)),
          const SizedBox(width: LayoutConstants.spaceM),
          // _buildMemberCount(),
          const Icon(Icons.group),
          const SizedBox(width: LayoutConstants.spaceS),
          Text(
            n,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: LayoutConstants.spaceL),
          widget.entity.isOwner ? const Icon(Icons.local_police) : const SizedBox(),
          // Icon(widget.entity.isActive ? Icons.notifications_active : Icons.notifications_off),
          Spacer(),
          _buildSetActiveButton(),
        ],
      ),
    );
  }

  Widget _buildSetActiveButton() {
    final bool isActive = widget.entity.isActive;
    return GestureDetector(
      onTap: isActive ? null : widget.onSetActivePressed,
      child: CheckIcon(
          isSelected: isActive,
          primaryColor: ColorPalette.btnDisable,
          secondColor: isActive ? ColorPalette.greenStatutColor : ColorPalette.btnDisable,
          iconColor: isActive,
          circleSize1: 25,
          circleSize2: 23),
    );
  }
}
