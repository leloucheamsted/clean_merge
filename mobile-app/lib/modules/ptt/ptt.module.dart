import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/ptt/infra/services/implementations/audio_manager_impl.dart';
import 'package:tello_social_app/modules/ptt/infra/services/implementations/proto_websocket.dart';
import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_audio_device_manager.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt/blocs/mediadevices_bloc.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt/blocs/peers_bloc.dart';
// import 'package:tello_social_app/modules/ptt/infra/services/ptt/ptt_service.dart.all';
import 'package:tello_social_app/modules/ptt/infra/services/ptt_soup/blocs/producers_bloc.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt_soup/room_client_repository.dart';
import 'package:tello_social_app/modules/ptt/presentation/blocs/test_ptt_bloc.dart';
import 'package:tello_social_app/modules/ptt/presentation/pages/test_ptt_page.dart';

import 'package:tello_social_app/routes/app_routes.enum.dart';

import '../user/user.module.dart';
import 'presentation/blocs/ptt_bloc.dart';

class PttModule extends Module {
  @override
  // List<Module> get imports => [UserModule()];
  List<Module> get imports => super.imports;

  @override
  List<Bind<Object>> get binds => [
        Bind.factory((i) => TestPttBloc(), export: false),

        Bind.lazySingleton((i) => PttBloc(), export: true),

        Bind.factory((i) => ProtoWebSocket(), export: false),
        // Bind.lazySingleton((i) => PttService(i()), export: false),

        Bind.lazySingleton((i) => MediaDevicesBloc(), export: false),
        Bind.factory((i) => ProducersBloc(), export: false),
        Bind.factory<PeersBloc>((i) => PeersBloc(), export: false),

        Bind.lazySingleton<IAudioDeviceManager>((i) => AudioManagerImpl(), export: true),
        // Bind.lazySingleton((i) => RoomClientRepository(), export: false),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(AppRoute.pttTest.pathAsChild, child: (context, args) => const TestPttPage()),
      ];
}
