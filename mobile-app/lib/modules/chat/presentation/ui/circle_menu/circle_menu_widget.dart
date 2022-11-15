library circle_menu_all;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/circle_menu/draggable_node.dart';

part 'parts/circle_canvas_painter.dart';
// part 'parts/dot_connector_painter.dart';

class CircleMenuWidget extends StatelessWidget {
  // static double itemRadius = kMinInteractiveDimension - 10;

  final int itemCount;
  final double itemRadius;
  // final List<T> itemDataList;üfianl
  final IndexedWidgetBuilder itemBuilder;
  final List<int> activeIndexes;
  final double radius;
  final Color color;
  final Color colorInteractive;
  final double startAngle;
  final Widget dropTargetWidget;
  final Widget Function(Color) connectorBuilder;
  final Function(int) onDrop;
  final bool Function(int) checkIsDraggable;
  final Curve? connectorAnimationCurve;
  final int? fixedLength;
  final Widget? centerWidget;

  const CircleMenuWidget({
    Key? key,
    required this.itemCount,
    required this.radius,
    required this.itemBuilder,
    required this.onDrop,
    required this.checkIsDraggable,
    this.fixedLength = 8,
    this.startAngle = -90,
    this.itemRadius = kMinInteractiveDimension,
    this.centerWidget,

    // this.activeIndexes = const [0, 2, 3],
    required this.activeIndexes,
    this.color = Colors.blue,
    this.colorInteractive = Colors.green,
    required this.dropTargetWidget,
    required this.connectorBuilder,
    this.connectorAnimationCurve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int n = fixedLength != null ? math.min(8, fixedLength!) : itemCount;

    final double anglePer = math.pi * 2 / n;
    final double startAngleRad = (startAngle - 90) * math.pi / 180;

    final List<Widget> childItems = [];
    final List<Widget> nodeConnectors = [];

    int i = 0;
    bool isActive = false;
    late double angleItem;
    for (i; i < n; i++) {
      isActive = activeIndexes.contains(i);
      angleItem = startAngleRad + anglePer * i;
      childItems.add(_buildItem(context, i, angleItem, isActive: isActive));
      nodeConnectors.add(_buildConnectorItem(angleItem, isActive: isActive));
    }

    childItems.insertAll(0, nodeConnectors);
    childItems.insert(0, _buildDragTarget());
    childItems.insert(0, _buildCanvas());

    if (centerWidget != null) {
      childItems.add(centerWidget!);
    }

    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: childItems,
      ),
    );
  }

  Widget _buildDragTarget() {
    return DragTarget<int>(
      builder: (_, candidateData, rejectedData) {
        return _buildDragTargetBody();
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {
        onDrop(data);
      },
    );
  }

  Widget _buildDragTargetBody() {
    return SizedBox(width: radius * .8, height: radius * .8, child: dropTargetWidget);
  }

  Widget _buildConnectorItem(double angleRad, {required bool isActive}) {
    final double w = radius * .25;
    final double h = radius * .29;
    Widget child = _buildConnectorContent(
      w,
      h,
      // isActive ? colorInteractive : Colors.transparent,
      colorInteractive,
    );

    child = AnimatedScale(
      scale: isActive ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      curve: connectorAnimationCurve ?? Curves.bounceOut,
      alignment: Alignment.bottomCenter,
      child: child,
    );

    final double r = radius - itemRadius * 2.54;
    final x = math.cos(angleRad) * r;
    final y = math.sin(angleRad) * r;

    final double angleRot = angleRad - math.pi * .5;
    return Transform(
      transform: Matrix4.identity()
        ..translate(x, y, 0.0)
        ..rotateZ(angleRot),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _buildConnectorContent(double w, double h, Color color) {
    return SizedBox(
      width: w,
      height: h,
      child: connectorBuilder(color),
    );
  }

  Widget _buildCanvas() {
    return SizedBox(
      width: radius,
      height: radius,
      child: CustomPaint(
        painter: CircleCanvasPainter(
          color: color,
          colorInteractive: colorInteractive,
          radius: radius,
          radiusChild: itemRadius,
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, double angleRad, {required bool isActive}) {
    final double posX = math.cos(angleRad) * (radius - itemRadius);
    final double posY = math.sin(angleRad) * (radius - itemRadius);

    final Widget child = _buildItem2(context, index, isActive: isActive);
    return Transform(
      transform: Matrix4.translationValues(posX, posY, 0),
      child: child,
    );
  }

  Widget _buildItem2(BuildContext context, int index, {required bool isActive}) {
    return DraggableNode(
      index: index,
      enabled: checkIsDraggable(index),
      itemRadius: itemRadius,
      itemBuilder: itemBuilder,
      color: isActive ? colorInteractive : color,
    );
  }
}
