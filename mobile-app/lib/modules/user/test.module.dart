import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/test_home_page.dart';
import 'package:tello_social_app/modules/user/presentation/test_views/test_clear_session_page.dart';

import 'package:tello_social_app/routes/app_routes.enum.dart';

import '../chat/presentation/ui/circle_menu/crcle_menu_test.page.dart';

class TestModule extends Module {
  @override
  // List<Module> get imports => [CoreModule()];
  List<Module> get imports => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(AppRoute.test.pathAsChild, child: (_, __) => const TestHomePage()),
        ChildRoute(AppRoute.clearSession.pathAsChild, child: (_, __) => const TestClearSession()),
        ChildRoute(AppRoute.circleTest.pathAsChild, child: (_, __) => const CircleMenuTestPage()),
        // ModuleRoute(AppRoute.contacts.path, module: ContactModule()),
      ];
}
