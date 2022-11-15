import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';

class ContactGridItem extends StatelessWidget {
  final ContactEntity entity;
  // final bool isAdded;
  final VoidCallback onAction;
  const ContactGridItem({
    Key? key,
    required this.entity,
    required this.onAction,
    // this.isAdded = false,
  }) : super(key: key);

  bool get isAdded => entity.isMember;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      padding: const EdgeInsets.all(LayoutConstants.paddingL),
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
          Text(
            entity.phoneNumber,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: LayoutConstants.spaceL),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return GestureDetector(
      onTap: onAction,
      child: AvatartIcon(
        iconPath: isAdded
            ? entity.isTelloMember == true
                ? IconsName.choiceIcon
                : IconsName.pingIcon
            : null,
        circleSize1: 20,
        circleSize2: 18,
        primaryColor: ColorPalette.btnDisable,
        secondColor: ColorPalette.greenStatutColor,
      ),
    );
  }

  Widget _buildAvatar() {
    return ImgLogoWidget(
      imgSrc: entity.avatar,
      // borderColor: Colors.green,
      borderColor: entity.isOnline ? Colors.green : Colors.grey,
      borderWidth: 4,
    );
  }
}
