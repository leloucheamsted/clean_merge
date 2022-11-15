import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tello_social_app/modules/core/blocs/app_state_bloc.dart';
import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_audio_device_manager.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt_soup/blocs/mediadevices_bloc.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt_soup/blocs/peers_bloc.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt_soup/blocs/producers_bloc.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt_soup/room_client_repository.dart';
import 'package:tello_social_app/modules/user/domain/entities/app_user.dart';
import 'package:tello_social_app/modules/user/presentation/blocs/user_profile_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/handshake.entity.dart';
import '../../infra/services/ptt_soup/mediasoup_repo.dart';
// import '../../infra/services/ptt/ptt_service.dart.all';

class TestPttBloc {
  late final _ctrlLog = ReplaySubject<String>();
  Stream<String> get outLog => _ctrlLog.stream;
  List<String> get allLogs => _ctrlLog.values;

  final ProducersBloc producersBloc = ProducersBloc();
  final PeersBloc peersBloc = PeersBloc();
  final MediaDevicesBloc mediaDevicesBloc = MediaDevicesBloc();

  final String tokenBazz =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJlbGkxMjMiLCJqdGkiOiI1Yjg4ZmU0OC0zMWQzLTRhZTYtOGY4Ni0xZmY2ZWQ3YmI0OTkiLCJyb2xlIjoiU3VwZXJ2aXNvciIsImlkIjoiNjAwNzJlNmQ5OTUwYTVkZTdlZGY0YjExIiwic2Vzc2lvbiI6IiIsImV4cCI6MTgyMzQ3NTQ0NCwiaXNzIjoiQmF6ekF1dGgiLCJhdWQiOiJCYXp6U2VydmVyR29sYXJzIn0.A_Vh6VhPwGlmsP_HeOAqfyrMUW__hhSi3EdGmFOH940";
  final String tokenSocial =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIwNzNhYWMwZjc5MTU0M2RlOGYzYTczOTkxMWU3ZTNkZiIsInVuaXF1ZV9uYW1lIjoiMDczYWFjMGY3OTE1NDNkZThmM2E3Mzk5MTFlN2UzZGYiLCJqdGkiOiIwNGNjYzc0My0wMDE2LTQ5NDUtOGZkYi03OTc5YjA3NTgyNGQiLCJpYXQiOiIxNjY1Njc5ODc1IiwiYXVkIjoiNTY5NzM0IiwibmJmIjoxNjY1Njc5ODc1LCJleHAiOjE2Njc3NTM0NzUsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjMifQ.7IXJzVZHkl8Ozx52cCtxRVI3is4gnq7eu7kb_Vi1hko";

  // late final PttService _pttService = Modular.get();
  // late final RoomClientRepository _roomClientRepository = Modular.get();
  // RoomClientRepository? _roomClientRepository;
  MediaSoupRepo? _mediaSoupRepo;

  IAudioDeviceManager? _iAudioDeviceManager;

  bool isJoined = false;

  void init() {
    _iAudioDeviceManager = Modular.get();

    _iAudioDeviceManager!.onCurrentChanged.listen((event) {
      _onLogCallBack(event.toString());
    });

    _iAudioDeviceManager!.getInputs().then((audioInputs) => audioInputs.forEach((element) {
          _onLogCallBack(element.toString());
        }));

    mediaDevicesBloc.actionLoad();
    // final ProducersBloc producersBloc = Modular.get();
    // final PeersBloc peersBloc = Modular.get();
    // final MediaDevicesBloc mediaDevicesBloc = Modular.get();

    final String uniqueId = const Uuid().v1();

    // final UserProfileBloc userProfileBloc = Modular.get();
    final AppStateBloc appStateBloc = Modular.get();

    final AppUser? appUser = appStateBloc.appUser;

    // String url = "wss://v3demo.mediasoup.org:4443/?roomId=$roomId&peerId=$peerId";
    final String peerId = appUser?.id ?? uniqueId;
    final String displayName = appUser?.displayName ?? peerId;
    const String roomId = "telloRoomTest";
    String url = "wss://mediasoup.dev.tello-social.tello-technologies.com:4443/?roomId=$roomId&peerId=$peerId";

    // String url = "wss://letsmeet.no?peerId=$peerId&roomId=$roomId";
    // '$url/?roomId=$roomId&peerId=$peerId',
    // final handShakeEntity = _createBazzHandShakeEntity();
    // final handShakeEntity = _createTelloHandShakeEntity();
    // final String url = handShakeEntity.uri.toString().replaceAll("http", "ws");

    _mediaSoupRepo = MediaSoupRepo(
      producersBloc: producersBloc,
      peersBloc: peersBloc,
      // roomId: "telloRoomTest",
      // peerId: peerId,
      url: url,
      displayName: displayName,
      mediaDevicesBloc: mediaDevicesBloc,
      onLogCallBack: _onLogCallBack,
    );
    _onLogCallBack("init done");
  }

  HandshakeEntity _createBazzHandShakeEntity() {
    return HandshakeEntity(
      schema: "https",
      // port: 3030,
      host: "ms.dev.bazzptt.com",
      token: tokenBazz,
      peerId: "3dbdf900-4176-11ed-8985-955791909b8b",
      userId: "60072e6d9950a5de7edf4b11",
      groupId: "1",
      isBackgroundService: true,
    );
  }

  HandshakeEntity _createTelloHandShakeEntity() {
    return HandshakeEntity(
      schema: "http",
      // port: 443,
      host: "mediasoup.dev.tello-social.tello-technologies.com",
      token: tokenSocial,
      peerId: "3dbdf900-4176-11ed-8985-955791909b8b",
      userId: "60072e6d9950a5de7edf4b11",
      groupId: "1",
      isBackgroundService: true,
    );
  }

  void connect() {
    if (isJoined) return;
    isJoined = true;
    if (_mediaSoupRepo == null) {
      init();
    }
    _mediaSoupRepo!.join();
    // final HandshakeEntity handshakeEntity = _createBazzHandShakeEntity();
  }

  void enableMic() {
    // _pttService.enableMic();
  }

  void dispose() {
    _mediaSoupRepo?.dispose();
    _iAudioDeviceManager?.dispose();
    _ctrlLog.close();
  }

  _onLogCallBack(String str) {
    _ctrlLog.add(str);
  }
}
