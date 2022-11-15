import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/layout_constants.dart';

class AvatartIcon extends StatelessWidget {
  final Color primaryColor;
  final Color secondColor;
  final String? iconPath;
  final double circleSize1;
  final double circleSize2;
  const AvatartIcon(
      {Key? key,
      required this.primaryColor,
      required this.secondColor,
      required this.iconPath,
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
            child: Padding(
              padding: const EdgeInsets.all(LayoutConstants.paddingS),
              child: iconPath != null
                  ? SvgPicture.asset(
                      iconPath!,
                      height: 31,
                      width: 5,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
