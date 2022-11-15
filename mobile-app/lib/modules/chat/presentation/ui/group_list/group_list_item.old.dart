import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widget/icon_badge.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/core/helpers/date_helper.dart';

class GroupListItem extends StatefulWidget {
  final GroupEntity entity;
  final Function? onItemDeletePressed;
  const GroupListItem({
    Key? key,
    required this.entity,
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
        trailing: _builTrailing(),
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
          Text(DateHelper.dateToText(widget.entity.createdAt)),
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
          Icon(widget.entity.isActive ? Icons.notifications_active : Icons.notifications_off),
          widget.entity.isOwner ? Icon(Icons.local_police) : SizedBox(),
        ],
      ),
    );
  }

  Widget _builTrailing() {
    return IconButton(onPressed: _onDeleteAction, icon: Icon(Icons.delete));
  }

  void _onDeleteAction() async {
    widget.onItemDeletePressed?.call();
    // final RemoveGroupBloc bloc = Modular.get();
    // await bloc.action(widget.entity.id);
  }
}
