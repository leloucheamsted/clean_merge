import 'package:flutter/material.dart';

class ListWidget extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final bool showScrollBar;
  const ListWidget({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.showScrollBar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showScrollBar ? Scrollbar(child: _buildBody(context)) : _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const ClampingScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int i) => itemBuilder(context, i),
    );
  }
}
