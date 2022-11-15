import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/group.module.dart';
import 'package:tello_social_app/modules/contact/contact.module.dart';
import 'package:tello_social_app/modules/ptt/ptt.module.dart';
import 'package:tello_social_app/modules/splash/pages/splash_page.dart';
import 'package:tello_social_app/modules/user/auth.module.dart';
import 'package:tello_social_app/modules/user/test.module.dart';
import 'package:tello_social_app/modules/user/user.module.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import 'modules/core/core.module.dart';
import 'modules/splash/blocs/splash_bloc.dart';
import 'modules/test_home_page.dart';
import 'routes/route_not_found_page.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  List<Bind> binds = [
    Bind.factory((i) => SplashBloc()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(AppRoute.initial.path, child: (_, __) => const SplashPage()),

    // ChildRoute(AppRoute.test.path, child: (_, __) => const TestHomePage()),
    RedirectRoute(AppRoute.home.path, to: AppRoute.groupHome.path),
    // ChildRoute(AppRoute.circleTest.path, child: (_, __) => const CircleMenuTestPage()),
    ModuleRoute(AppRoute.ptt.path, module: PttModule()),
    ModuleRoute(AppRoute.contacts.path, module: ContactModule()),
    ModuleRoute(AppRoute.test.path, module: TestModule()),
    ModuleRoute(AppRoute.auth.path, module: AuthModule()),
    // ModuleRoute(AppRoute.auth.path, module: UserModule()),
    ModuleRoute(AppRoute.group.path, module: GroupModule()),
    ModuleRoute(AppRoute.user.path, module: UserModule()),

    // RedirectRoute(AppRoute.home.path, to: AppRoute.test.path),
    WildcardRoute(child: (context, args) => const RouteNotFoundPage()),
    // ModuleRoute("/home", module: UserModule()),
    // ModuleRoute('/', module: SplashModule()),
    // ModuleRoute('/intro', module: OnboardingModule()),
    // ModuleRoute('/chat', module: ChatModule()),
    // ChildRoute('/settings', child: (context, args) => SettingsPage()),
  ];
}
