import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_member.entity.dart';

import '../../../../common/widget/img_logo_widget.dart';

class MemberAvatarCircle extends StatelessWidget {
  final GroupMemberEntity entity;
  const MemberAvatarCircle({Key? key, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImgLogoWidget(
      imgSrc: entity.avatar,
      // borderColor: Colors.green,
      borderColor: _getColor(),
      borderWidth: 4,
    );
  }

  Color _getColor() {
    late Color color;
    switch (entity.groupInvitationStatus) {
      case InvitationStatus.pending:
        color = Colors.black;
        break;
      default:
        color = Colors.green;
    }
    return color;
  }
}
