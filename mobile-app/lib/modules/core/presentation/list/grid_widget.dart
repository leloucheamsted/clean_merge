import 'package:flutter/material.dart';

/*
crossAxisCount: 3,
        childAspectRatio: 10 / 16,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 20.0,
*/
class GridWidget extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final bool showScrollBar;
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double childAspectRatio;
  const GridWidget({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.showScrollBar = true,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.childAspectRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showScrollBar ? Scrollbar(child: _buildBody(context)) : _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return GridView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const ClampingScrollPhysics(),
      itemCount: itemCount,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (BuildContext context, int i) => itemBuilder(context, i),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,

        // childAspectRatio: PromoListItemBox.ASPECT_RATIO,
      ),
    );
  }
}
