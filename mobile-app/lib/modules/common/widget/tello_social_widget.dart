import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';
import 'package:tello_social_app/modules/common/widget/asset_widget.dart';

class TelloSocialWidget extends StatelessWidget {
  final double? height;
  const TelloSocialWidget({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: ColorPalette.telloBgColor,
      // color: Colors.amber,
      // color: Theme.of(context).scaffoldBackgroundColor,
      height: height ?? MediaQuery.of(context).size.height * .4,
      child: const Center(
        child: AssetWidget(
          color: Colors.white,
          AssetName.telloSocial,
        ),
      ),
    );
  }
}
