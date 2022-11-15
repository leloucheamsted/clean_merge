import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';

import '../../constants/layout_constants.dart';

class CheckIcon extends StatelessWidget {
  final bool isSelected;
  final Color primaryColor;
  final Color secondColor;
  final bool? iconColor;
  final double circleSize1;
  final double circleSize2;
  const CheckIcon(
      {Key? key,
      required this.isSelected,
      required this.primaryColor,
      required this.secondColor,
      required this.iconColor,
      required this.circleSize1,
      required this.circleSize2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: circleSize1,
          backgroundColor: primaryColor, // Palette.colorText,
          child: CircleAvatar(
            radius: circleSize2,
            backgroundColor: secondColor, //Palette.btnDisable,
            child: !isSelected
                ? null
                : Padding(
                    padding: const EdgeInsets.all(LayoutConstants.paddingS),
                    child: SvgPicture.asset(
                      IconsName.choiceIcon,
                      height: 31,
                      width: 5,
                      color: iconColor != null ? ColorPalette.colorText : secondColor,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
