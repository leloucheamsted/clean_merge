import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_member.entity.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widgets.dart';

import 'member_avatar_circle.dart';

class MemberGridItem extends StatelessWidget {
  final GroupMemberEntity entity;
  final bool canRemove;
  final VoidCallback onAction;
  const MemberGridItem({
    Key? key,
    required this.entity,
    required this.onAction,
    required this.canRemove,
  }) : super(key: key);

  // bool get isAdded => entity.isMember;
  @override
  Widget build(BuildContext context) {
    if (!canRemove) {
      return _buildBody();
    }
    return Stack(
      children: [
        _buildBody(),
        _buildDeleteButton(),
      ],
    );
  }

  Container _buildBody() {
    return Container(
      // color: Colors.red,
      padding: const EdgeInsets.all(LayoutConstants.paddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(),
          const SizedBox(height: LayoutConstants.spaceM),
          Text(
            entity.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (!entity.isDisplayNameSameAsPhone)
            Text(
              entity.phoneNumber,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          // const SizedBox(height: LayoutConstants.spaceL),
          // _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Positioned(
      top: 5,
      right: 10,
      child: CircleButton(
        onPressed: onAction,
        // borderColor: Colors.white,
        // borderWidth: 1,
        color: Colors.red,
        width: kMinInteractiveDimension,
        height: kMinInteractiveDimension,
        child: SvgPicture.asset(IconsName.deleteTag),
        // child: const Icon(Icons.remove),
      ),
    );
  }

  /*Widget _buildActionButton() {
    return GestureDetector(
      onTap: onAction,
      child: AvatartIcon(
        iconPath: !isAdded
            ? entity.isAppUser == true
                ? IconsName.choiceIcon
                : IconsName.pingIcon
            : null,
        circleSize1: 20,
        circleSize2: 18,
        primaryColor: ColorPalette.btnDisable,
        secondColor: ColorPalette.greenStatutColor,
      ),
    );
  }*/

  Widget _buildAvatar() {
    return MemberAvatarCircle(entity: entity);
    return ImgLogoWidget(
      imgSrc: entity.avatar,
      borderColor: Colors.green,
      borderWidth: 4,
    );
  }
}
