import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widgets.dart';

class IconBadge extends StatelessWidget {
  final Widget? icon;
  final int? count;
  final double width;
  final double height;
  const IconBadge({
    Key? key,
    this.icon,
    this.count,
    this.width = 40,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleContainer(
          width: width,
          height: height,
          color: Colors.transparent,
          child: icon ?? const SizedBox(),
        ),
        const SizedBox(width: LayoutConstants.spaceS),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
          child: Text(
            "$count",
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
    return Stack(
      // alignment: Alignment.center,

      children: <Widget>[
        CircleContainer(
          width: width,
          height: height,
          color: Colors.green.shade200,
          child: icon ?? const SizedBox(),
        ),
        // SizedBox(width: width + 20, height: height + 5),
        Positioned(
          top: -5,
          right: 12,
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
            constraints: BoxConstraints(
              minHeight: 12,
              minWidth: 12,
            ),
            child: Text(
              "$count",
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
