import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import 'core/presentation/list/list_widget.dart';

final List<String> items = <String>[
  AppRoute.ptt.path,
  // AppRoute.pttTest.path,

  AppRoute.groupHome.path,
  AppRoute.circleTest.path,
  AppRoute.contacts.path,

  AppRoute.auth.path,
  AppRoute.clearSession.path,
  AppRoute.groupCreate.path,
  AppRoute.groupList.path,

  // AppRoute.groupDetail.path.replaceAll(":id", "123"),
  // AppRoute.groupDetail.withIdParam("123"),
  AppRoute.userProfileCurrent.path,
];

class TestHomePage extends StatelessWidget {
  const TestHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TestHomePage"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListWidget(itemCount: items.length, itemBuilder: _itemBuilder);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final String item = items[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SimpleButton(
        content: item,
        onTap: () => Modular.to.pushNamed(item),
        background: Colors.green,
      ),
    );
  }
}
