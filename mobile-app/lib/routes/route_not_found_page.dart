import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RouteNotFoundPage extends StatelessWidget {
  const RouteNotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final String currentRoute =Modular.to.navigateHistory.map((e) => e.name).toList().join("\n");
    final String currentRoute = Modular.to.path;
    return Scaffold(
      appBar: AppBar(
        title: Text("RouteNotFoundPage"),
      ),
      body: Center(
        child: Text("RouteNotFoundPage\n$currentRoute"),
      ),
    );
  }
}
