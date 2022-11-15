import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/common/presentation/upload_avatar/select_upload_image.bloc.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/services/implementations/connectivity/connectivity_service.dart';
import 'package:tello_social_app/modules/core/services/implementations/http/diohttpclient_service.dart';
import 'package:tello_social_app/modules/core/services/implementations/image_picker_provider.dart';
import 'package:tello_social_app/modules/core/services/interfaces/i_image_picker_provider.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_clear.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_exists.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_read_phone_number.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_save_phone_number.usecase.dart';

import '../../routes/nav_observer.dart';
import '../chat/domain/usecases/group_fetchlist.usecase.dart';
import '../chat/external/datasources/remote_group.datasource.dart';
import '../chat/infra/datasource/i_group_datasource.dart';
import '../chat/infra/repositories/group.repository.dart';
import '../chat/presentation/blocs/fetch_grop_list_bloc.dart';
import '../contact/domain/usecases/fetch_contacts.usecase.dart';
import '../contact/external/datasources/flutter_contacts_datasource.dart';
import '../contact/external/datasources/remote_contacts.datasource.dart';
import '../contact/external/datasources/sqflite_contacts_datasource.dart';
import '../contact/infra/datasources/i_phonebook.datasource.dart';
import '../contact/infra/repositories/contact_repo.dart';
import '../ptt/presentation/blocs/ptt_bloc.dart';
import '../user/domain/usecases/session_read_token.usecase.dart';
import '../user/domain/usecases/session_save_token.usecase.dart';
import '../user/domain/usecases/user_get_details.usecase.dart';
import '../user/external/datasources/local_session.datasource.dart';
import '../user/external/datasources/user_remote.datasource.dart';
import '../user/infra/datasources/i_session.datasource.dart';
import '../user/infra/datasources/i_user.datasource.dart';
import '../user/infra/repositories/session_repo.dart';
import '../user/infra/repositories/user.repo.dart';
import '../user/presentation/blocs/user_profile_bloc.dart';
import 'blocs/app_state_bloc.dart';
import 'services/interfaces/iconnectivity_service.dart';

ServerFailure _serverFailurerMapper(dynamic response) {
  try {
    if (response.data == "") {
      return ServerFailure(
        code: response.statusCode.toString(),
        message: response.statusMessage,
      );
    }
    final Map<String, dynamic> map = response.data;
    List<String> errorArr = [map["detail"]];
    final Map<String, dynamic>? mapErrors = map["errors"];
    if (mapErrors != null) {
      final List<String> errorKeys = mapErrors.keys.toList();
      for (String key in errorKeys) {
        errorArr.add(mapErrors[key].join("\n"));
      }
    }

    return ServerFailure(
      code: map["status"]?.toString() ?? "-1",
      message: errorArr.join("\n"),
    );
  } catch (e) {
    throw Exception("_serverFailurerMapper.exception ${response.data}");
  }

// 944337
}

class CoreModule extends Module {
  @override
  List<Bind> get binds => [
        // Bind.lazySingleton((i) => PttBloc(), export: true),

        Bind.lazySingleton<FetchGroupListBloc>(
          (i) => FetchGroupListBloc(),
          export: true,
          onDispose: (value) => value.dipose(),
        ),
        Bind.lazySingleton((i) => GroupFetchListUseCase(i()), export: true),
        Bind.lazySingleton((i) => GroupRepository(i()), export: true),

        Bind.lazySingleton<IGroupDataSource>((i) => RemoteGroupDataSource(i()), export: true),

        //Services
        Bind.lazySingleton((i) => NavObserver(), export: true),

        Bind.lazySingleton<IConnectivityService>((i) => ConnectivityService(), export: true),

        Bind.lazySingleton((i) => AppStateBloc(), export: true),
        // Bind.lazySingleton((i) => HiveCacheService(), export: true),
        //Others
        // Bind.lazySingleton((i) => Connectivity(), export: true),
        // https://api.dev.tello-social.tello-technologies.com/api/v1/Authenticate/SignIn

        //USER

        Bind.factory((i) => UserGetDetailsUseCase(i()), export: true),
        Bind.lazySingleton((i) => UserRepo(i()), export: true),
        Bind.lazySingleton<IUserDataSource>((i) => UserRemoteDataSource(i()), export: true),
        //CONTACT
        Bind.lazySingleton((i) => FetchContactsUseCase(i()), export: true),
        Bind.lazySingleton((i) => ContactRepo(i(), i(), i()), export: true),
        Bind.lazySingleton((i) => RemoteContactsDataSource(i()), export: true),
        Bind.lazySingleton((i) => SqfliteContactsDataSource(), export: true),

        // Bind.lazySingleton<IPhoneBookDataSource>((i) => FakeContactsDataSource(i()), export: false),
        Bind.lazySingleton<IPhoneBookDataSource>((i) => FlutterContactsDataSource(), export: true),
        //SESSION
        Bind.factory((i) => SessionClearUseCase(i()), export: true),
        Bind.factory((i) => SessionExistsUseCase(i()), export: true),
        Bind.factory((i) => SessionSaveTokenUseCase(i()), export: true),
        Bind.factory((i) => SessionSavePhoneNumberUseCase(i()), export: true),
        Bind.factory((i) => SessionReadTokenUseCase(i()), export: true),
        Bind.factory((i) => SessionReadPhoneNumberUseCase(i()), export: true),
        Bind.lazySingleton((i) => SessionRepo(i()), export: true),
        Bind.lazySingleton<ISessionDataSource>((i) => LocalSessionDataSource(), export: true),

        Bind.factory(
          (i) => SelectUploadImageBloc(httpClientService: i(), imgPicker: i()),
          export: true,
        ),
        Bind.singleton<IImagePickerProvider>((i) => ImagePickerProvider(),
            // onDispose: (value) => value.dispose(),
            export: true),

        Bind.singleton(
            (i) => DioHttpClientService(
                  dio: i(),
                  // sessionReadUseCase: i(),
                  customErrorParser: _serverFailurerMapper,
                ),
            // onDispose: (value) => value.dispose(),
            export: true),

        Bind.singleton<Dio>(
            (i) => Dio(BaseOptions(
                  baseUrl: 'https://api.dev.tello-social.tello-technologies.com/api/v1',
                  // baseUrl: 'https://api.staging.dev.tello-social.tello-technologies.com/api/v1/',
                  headers: {
                    "content-type": "application/json",
                  },
                )),
            export: true),
        // Bind.lazySingleton((i) => HiveCacheService(), export: true),
        //Others
        // Bind.lazySingleton((i) => Connectivity(), export: true),
        // https://api.dev.tello-social.tello-technologies.com/api/v1/Authenticate/SignIn
      ];
}
