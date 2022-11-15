import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/common/widgets.dart';

class DraggableNode extends StatefulWidget {
  final int index;
  final double itemRadius;
  final IndexedWidgetBuilder itemBuilder;
  final Color color;
  final bool enabled;
  const DraggableNode({
    Key? key,
    required this.index,
    required this.itemRadius,
    required this.itemBuilder,
    required this.color,
    required this.enabled,
  }) : super(key: key);

  @override
  State<DraggableNode> createState() => _DraggableNodeState();
}

class _DraggableNodeState extends State<DraggableNode> {
  @override
  Widget build(BuildContext context) {
    final Widget child = _buildItemBody();
    if (!widget.enabled) return child;
    return Draggable<int>(
      data: widget.index,
      childWhenDragging: CircleContainer(
        width: widget.itemRadius * 2,
        height: widget.itemRadius * 2,
        color: Colors.grey.shade400,
        // child: Center(child: itemBuilder(context, index)),
      ),
      feedback: child,
      child: child,
    );
  }

  Widget _buildItemBody() {
    return CircleContainer(
      color: Colors.grey.shade200,
      width: widget.itemRadius * 2,
      height: widget.itemRadius * 2,
      borderColor: widget.color,
      borderWidth: 4,
      child: Center(child: widget.itemBuilder(context, widget.index)),
    );
  }
}
