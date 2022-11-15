import 'package:flutter/material.dart';

class ReloadBtn extends StatelessWidget {
  final VoidCallback onPressed;
  const ReloadBtn({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(
        const Size(kMinInteractiveDimension, kMinInteractiveDimension),
      ),
      child: build2(context),
    );
  }

  Widget build2(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      // icon: widget.iconBuilder(),
      // icon: widget.iconWidget,
      icon: const Icon(
        Icons.refresh,
        color: Colors.white,
      ),
      color: Colors.white,
    );
  }
}
