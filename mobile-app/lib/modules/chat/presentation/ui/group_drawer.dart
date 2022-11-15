import 'package:flutter/material.dart';

import '../../../common/constants/constants.dart';
import 'group_list/group_list_drawer.dart';

class GroupDrawer extends StatelessWidget {
  const GroupDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorPalette.grayPopColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width * 0.7,
      child: const GroupListDrawer(),
    );
  }
}
