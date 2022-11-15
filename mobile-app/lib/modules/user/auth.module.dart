import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/common/country/i_country_data_source.dart';
import 'package:tello_social_app/modules/core/core.module.dart';
import 'package:tello_social_app/modules/user/domain/usecases/get_sim_code.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/otp.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/signin.usecase.dart';
import 'package:tello_social_app/modules/user/external/datasources/auth_remote.datasource.dart';
import 'package:tello_social_app/modules/user/external/datasources/country_names_native.datasource.dart';

import 'package:tello_social_app/modules/user/infra/datasources/i_auth.datasource.dart';
import 'package:tello_social_app/modules/user/infra/repositories/auth_repo.dart';
import 'package:tello_social_app/modules/user/infra/repositories/sim_country.repo.dart';
import 'package:tello_social_app/modules/user/presentation/auth/bloc/auth_bloc.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import 'infra/datasources/sim_country/fake_simcountry.datasource.dart';
import 'presentation/auth/pages/phone_input_page.dart';
import 'presentation/auth/pages/otp_page.dart';

class AuthModule extends Module {
  @override
  // TODO: implement imports
  // List<Module> get imports => [CoreModule()];

  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton((i) => AuthBloc(i()), export: false),
        Bind.factory<ICountryDataSource>((i) => CountryNamesNativeDataSource(), export: false),
        // Bind.lazySingleton<ICountryDataSource>((i) => CountryNamesEnglishDataSource(), export: false),
        Bind.factory((i) => OtpUseCase(i()), export: false),
        Bind.factory((i) => SigninUseCase(i()), export: false),
        Bind.lazySingleton((i) => AuthRepo(i()), export: false),

        Bind.factory((i) => GetSimCodeUseCase(i()), export: false),
        Bind.factory((i) => SimCountryRepo(i()), export: false),
        Bind.factory((i) => FakeSimCountryDataSource(), export: false),
        // Bind.lazySingleton<IAuthDataSource>((i) => FakeAuthDataSource(), export: false),
        Bind.lazySingleton<IAuthDataSource>((i) => AuthApiDataSource(i()), export: false),
      ];

  @override
  List<ModularRoute> get routes => [
        // ChildRoute(AppRoute.auth.pathAsChild, child: (context, args) => const CountrySelectPage()),
        ChildRoute(AppRoute.auth.pathAsChild, child: (context, args) => const PhoneInputPage()),
        // ChildRoute('/', child: (context, args) => const CountryListPage()),
        // ChildRoute('/', child: (context, args) => PhonePluginTestPage()),
        // ChildRoute('/', child: (context, args) => const PhoneInputPage()),
        // ChildRoute('/country_list/', child: (context, args) => const CountrySelectPage()),
        ChildRoute(AppRoute.otp.pathAsChild, child: (context, args) => const OtpPage()),
      ];
}
