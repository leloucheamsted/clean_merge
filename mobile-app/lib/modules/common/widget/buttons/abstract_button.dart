import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants.dart';
import '../../constants/layout_constants.dart';

class AbstractButton extends StatelessWidget {
  final String? content;
  final String? iconPath;
  final VoidCallback onTap;
  final Color background;
  final double? width;
  final bool isEnabled;
  const AbstractButton({
    required this.content,
    this.iconPath,
    required this.onTap,
    Key? key,
    required this.background,
    this.width = double.infinity,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) {
      return Opacity(opacity: .5, child: _buildContent(context));
    }
    return GestureDetector(
      onTap: onTap,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    Text? textWidget = content == null
        ? null
        : Text(
            content!,
            style: const TextStyle(
                color: ColorPalette.colorText, fontSize: FontsSize.normalText, fontFamily: 'poppinsRegular'),
          );
    return Container(
      height: LayoutConstants.actionBtnHeight,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(LayoutConstants.radiusM),
      ),
      child: iconPath == null
          ? textWidget
          : content == null
              ? SvgPicture.asset(iconPath!)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(iconPath!),
                    const SizedBox(
                      width: LayoutConstants.spaceM,
                    ),
                    textWidget!,
                  ],
                ),
    );
  }
}
