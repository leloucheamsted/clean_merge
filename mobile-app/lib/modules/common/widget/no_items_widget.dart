import 'package:flutter/material.dart';

class NoItemsWidget extends StatelessWidget {
  const NoItemsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: localize
    return Center(
      child: Text(
        "No Items",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
