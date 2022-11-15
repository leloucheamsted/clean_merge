import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';
import 'package:tello_social_app/modules/core/services/dialog_service.dart';

import 'routes/nav_observer.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ThemeData _defaultTheme = Theme.of(context);
    Modular.setNavigatorKey(DialogService.navigationKey);
    Modular.setObservers([Modular.get<NavObserver>()]);
    return MaterialApp.router(
      title: "Tello Social App",

      theme: Constants.theme,
      /*theme: ThemeData(
          brightness: Brightness.dark,
          backgroundColor: const Color.fromRGBO(38, 45, 61, 1),
          primaryColor: const Color.fromRGBO(38, 45, 61, 1),
          fontFamily: 'Georgia',
          scaffoldBackgroundColor: const Color.fromRGBO(25, 33, 46, 1),
          primarySwatch: Colors.blueGrey,
          // backgroundColor: Colors.grey.shade800,

          errorColor: Colors.red,
          // inputDecorationTheme: _defaultTheme.inputDecorationTheme.copyWith(errorStyle: _defaultTheme.inputDecorationTheme.errorStyle?.copyWith(color: Colors.red)),
          appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade500)),*/
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,

      // navigatorObservers: [AppNavigationObserver()],
    );
  }
}
