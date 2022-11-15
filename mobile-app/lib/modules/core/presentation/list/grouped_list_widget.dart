import 'package:flutter/material.dart';

class GroupListHeader {
  final int sortIndex;
  final String title;
  GroupListHeader({
    required this.sortIndex,
    required this.title,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupListHeader && other.sortIndex == sortIndex && other.title == title;
  }

  @override
  int get hashCode => sortIndex.hashCode ^ title.hashCode;
}

class GroupedListWidget<H, I> extends StatelessWidget {
  final ScrollController? scrollController;
  final Map<H, List<I>> groupedItems;
  final Widget Function(BuildContext context, H header) headerBuilder;
  final Widget Function(BuildContext context, I item) itemBuilder;
  final Comparator<H>? headerSorter;

  // final IndexedWidgetBuilder itemBuilder;
  const GroupedListWidget({
    Key? key,
    required this.groupedItems,
    required this.headerBuilder,
    required this.itemBuilder,
    this.headerSorter,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: move to external bloc instead of widgets build method
    final List<H> keys = groupedItems.keys.toList();
    if (headerSorter != null) {
      keys.sort(headerSorter);
    }

    return ListView.builder(
        shrinkWrap: true,
        controller: scrollController,
        // padding: EdgeInsets.zero,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: groupedItems.length,
        itemBuilder: (BuildContext context, int index) {
          final H headerData = keys[index];
          return _buildWithHeader(context, headerData, groupedItems[headerData]!);
        });
  }

  Widget _buildWithHeader(BuildContext context, H headerData, List<I> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        headerBuilder(context, headerData),
        _buildItems(context, items),
      ],
    );
  }

  Widget _buildItems(BuildContext context, List<I> items) {
    return ListView.builder(
      // padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) => itemBuilder(context, items[index]),
    );
  }
}
