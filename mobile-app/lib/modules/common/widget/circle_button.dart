import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final Color color;
  final Color? borderColor;
  final double? borderWidth;
  final double? width;
  final double? height;
  final Widget? child;
  final DecorationImage? image;
  final AlignmentGeometry? alignment;
  final Function()? onPressed;
  const CircleButton({
    Key? key,
    required this.color,
    this.borderColor,
    this.borderWidth,
    this.width = 60,
    this.height = 60,
    this.child,
    this.image,
    this.alignment = Alignment.center,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        // padding: EdgeInsets.all(12),
        alignment: alignment,
        decoration: BoxDecoration(
          border: borderColor == null ? null : Border.all(color: borderColor!, width: borderWidth ?? 1),
          color: color,
          shape: BoxShape.circle,
          image: image,
        ),
        child: child,
      ),
    );
  }
}
