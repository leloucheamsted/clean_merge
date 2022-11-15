import 'package:flutter/material.dart';

class CircleContainer extends StatelessWidget {
  final Color color;
  final Color? borderColor;
  final double? borderWidth;
  final double? width;
  final double? height;
  final Widget? child;
  final DecorationImage? image;
  final AlignmentGeometry? alignment;
  const CircleContainer({
    Key? key,
    required this.color,
    this.borderColor,
    this.borderWidth,
    this.width,
    this.height,
    this.child,
    this.image,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      width: width,
      height: height,
      alignment: alignment,
      decoration: BoxDecoration(
        border: borderColor == null ? null : Border.all(color: borderColor!, width: borderWidth ?? 1),
        color: color,
        shape: BoxShape.circle,
        image: image,
      ),
      child: child,
    );
  }
}
