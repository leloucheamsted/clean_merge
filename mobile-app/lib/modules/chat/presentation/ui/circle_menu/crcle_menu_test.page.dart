import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/circle_menu/tello_circle_widget.dart';
import 'package:tello_social_app/modules/common/widgets.dart';

class CircleMenuTestPage extends StatelessWidget {
  const CircleMenuTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Circle Menu Test"),
        ),
        body: const Center(
          child: CircleMenuWidgetTestWrapper(),
        ));
  }
}

class CircleMenuWidgetTestWrapper extends StatefulWidget {
  const CircleMenuWidgetTestWrapper({
    Key? key,
  }) : super(key: key);

  @override
  State<CircleMenuWidgetTestWrapper> createState() => _CircleMenuWidgetTestWrapperState();
}

int _randomBetWeen(int min, int max) {
  return Random().nextInt(max - min) + min;
}

class _CircleMenuWidgetTestWrapperState extends State<CircleMenuWidgetTestWrapper> {
  final int maxItems = 8;

  int totalItems = 8;
  Color activeColor = Colors.green;

  late final List<Color> colors = [Colors.green, Colors.red, Colors.orange];

  final List<Curve> curves = [
    Curves.elasticOut,
    Curves.elasticInOut,
    Curves.elasticIn,
    Curves.bounceOut,
    Curves.easeInOutBack,
    Curves.decelerate,
    Curves.bounceInOut,
    Curves.easeInCubic,
  ];

  late Curve activeCurve = curves.first;

  late bool isOwner = true;

  @override
  void initState() {
    super.initState();
    // final int i = colors.indexOf(activeColor);
    colors.remove(activeColor);
    curves.remove(activeCurve);
  }

  List<int> activeIndexes = [];

  void _toggleIsOwner() {
    isOwner = !isOwner;
    setState(() {});
  }

  void _randomizeItemCount() {
    totalItems = _randomBetWeen(1, maxItems);
    activeIndexes.clear();
    setState(() {});
  }

  void _randomizeActiveColor() {
    colors.add(activeColor);
    // final int index = _randomBetWeen(0, colors.length);
    // activeColor = colors.removeAt(index);
    activeColor = colors.removeAt(0);

    setState(() {});
  }

  void _randomizeCurve() {
    curves.add(activeCurve);
    activeCurve = curves.removeAt(0);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton("Random length ($totalItems)", _randomizeItemCount),
        _buildButton("Toggle isOwner ($isOwner)", _toggleIsOwner),
        _buildButton("Random color (${activeColor.value})", _randomizeActiveColor),
        _buildButton("Random curve ($activeCurve)", _randomizeCurve),
        const SizedBox(height: 40),
        _buildMenu(context),
      ],
    );
  }

  Widget _buildButton(String label, Function() onClick) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: SimpleButton(
        content: label,
        onTap: onClick,
        background: Colors.green,
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return TelloCircleWidget(
      // startAngle: -15,
      total: totalItems,
      activeColor: activeColor,
      connectorAnimationCurve: activeCurve,
      isOwner: isOwner,
      // activeIndexes: activeIndexes,
      // items: circleMenuItemList,
      // radius: MediaQuery.of(context).size.width * .8 * .5,
    );
  }
}
