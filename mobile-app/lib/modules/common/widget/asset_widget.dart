import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetWidget extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  const AssetWidget(
    this.assetName, {
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      color: color,
      assetName,
      height: height,
      width: width,
    );
  }
}
