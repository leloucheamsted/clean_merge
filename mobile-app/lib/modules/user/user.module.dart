import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/user/domain/usecases/user_get_details.usecase.dart';
import 'package:tello_social_app/modules/user/external/datasources/user_remote.datasource.dart';
import 'package:tello_social_app/modules/user/infra/datasources/i_user.datasource.dart';
import 'package:tello_social_app/modules/user/infra/repositories/user.repo.dart';
import 'package:tello_social_app/modules/user/presentation/blocs/user_profile_bloc.dart';

import 'package:tello_social_app/modules/user/presentation/pages/user_profile.page.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import 'domain/usecases/user_rename.usecase.dart';

class UserModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.factory((i) => UserRenameUseCase(i()), export: false),
        Bind.lazySingleton((i) => UserProfileBloc(), export: false),
        // Bind.lazySingleton((i) => UserProfileBloc(), export: false),
        // Bind.factory((i) => UserGetDetailsUseCase(i()), export: false),
        // Bind.lazySingleton((i) => UserRepo(i()), export: false),
        // Bind.lazySingleton<IUserDataSource>((i) => UserRemoteDataSource(i()), export: false),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(AppRoute.userProfileCurrent.pathAsChild, child: (context, args) => const UserProfilePage()),
      ];
}
