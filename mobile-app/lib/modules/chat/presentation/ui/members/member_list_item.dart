import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_member.entity.dart';
import 'package:tello_social_app/modules/common/widgets.dart';

class MemberListItem extends StatelessWidget {
  final GroupMemberEntity entity;
  final Function(String)? onMemberRemoveBtn;
  const MemberListItem({
    super.key,
    required this.entity,
    this.onMemberRemoveBtn,
  });

  @override
  Widget build(BuildContext context) {
    // return Text("kro");
    return ListTile(
      contentPadding: EdgeInsets.all(8),
      // tileColor: Colors.grey.shade400,
      leading: ImgLogoWidget(
        imgSrc: entity.avatar,
        borderColor: Colors.green,
        borderWidth: 4,
      ),
      title: Text(entity.displayName),
      // subtitle: _buildDuration(),
      trailing: onMemberRemoveBtn == null
          ? null
          : IconButton(
              onPressed: () => onMemberRemoveBtn!(entity.phoneNumber),
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
    );
  }
}
