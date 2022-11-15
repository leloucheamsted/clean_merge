import 'dart:async';
import 'dart:developer';

// import 'package:example/features/me/bloc/me_bloc.dart';
// import 'package:example/features/media_devices/bloc/media_devices_bloc.dart';
// import 'package:example/features/peers/bloc/peers_bloc.dart';
// import 'package:example/features/producers/bloc/producers_bloc.dart';
// import 'package:example/features/room/bloc/room_bloc.dart';

// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:tello_social_app/modules/ptt/infra/services/implementations/proto_websocket.dart';
import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_socket.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt_soup/mediasoup_core_svc.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt_soup/mediasoup_signaling_svc.dart';

import 'blocs/mediadevices_bloc.dart';
import 'blocs/peers_bloc.dart';
import 'blocs/producers_bloc.dart';

// typedef OnActiveSpeaker = Function(String? peerId);

class MediaSoupRepo {
  final ProducersBloc producersBloc;
  final PeersBloc peersBloc;
  // final MeBloc meBloc;
  // final RoomBloc roomBloc;
  final MediaDevicesBloc mediaDevicesBloc;

  final String? url;
  final String displayName;

  bool _closed = false;

  // WebSocket? _webSocket;
  BaseSocket? _webSocket;
  MediaSoupSignalingSvc? _mediaSoupSignalingSvc;
  MediaSoupCoreSvc? _mediaSoupCoreSvc;

  bool _produce = false;
  bool _consume = true;

  bool _isProducing = false;
  bool get isProducing => _isProducing;
  // StreamSubscription<MediaDevicesState>? _mediaDevicesBlocSubscription;
  late StreamSubscription _mediaDevicesAudioInputSub;
  String? audioInputDeviceId;
  String? audioOutputDeviceId;
  String? videoInputDeviceId;

  final Function(String)? onLogCallBack;

  final Function? onProducerTrackendedCallback;
  final Function(Producer)? onProducerCallback;
  final Function(Consumer? consumer, bool flagStart)? onConsumerCallback;
  final Function(String? peerId)? onActiveSpeaker;
  final Function()? onRoomJoined;
  final Function()? onSocketClosed;

  final bool isLiveCall;

  MediaSoupRepo({
    required this.producersBloc,
    required this.peersBloc,
    this.isLiveCall = true,
    // required this.meBloc,
    // required this.roomBloc,
    // required this.roomId,
    // required this.peerId,
    this.url,
    required this.displayName,
    required this.mediaDevicesBloc,
    this.onLogCallBack,
    this.onProducerTrackendedCallback,
    this.onProducerCallback,
    this.onConsumerCallback,
    this.onActiveSpeaker,
    this.onRoomJoined,
    this.onSocketClosed,
  }) {
    _mediaDevicesAudioInputSub = mediaDevicesBloc.outAudioInput.listen((event) async {
      if (event != null && audioInputDeviceId != event.deviceId) {
        // await disableMic();
        // enableMic();
      }
    });
  }

  void close() {
    if (_closed) {
      return;
    }

    _webSocket?.close();

    _mediaSoupCoreSvc!.close();

    // _mediaDevicesBlocSubscription?.cancel();
  }

  void enableMic() async {
    if (_isProducing) {
      _log("already.producing!");
      return;
    }

    if (!_mediaSoupCoreSvc!.canProduceAudio()) {
      return;
    }
    if (_mediaSoupCoreSvc!.sendTransport == null) return;
    _isProducing = true;

    MediaStream? audioStream;

    try {
      audioStream = await createAudioStream();

      _mediaSoupCoreSvc!.produce(audioStream);
    } catch (error) {
      if (audioStream != null) {
        await audioStream.dispose();
      }
      _isProducing = false;
    }
  }

  Future<void> disableMic() async {
    // String micId = producersBloc.state.mic!.id;

    // producersBloc.add(ProducerRemove(source: 'mic'));
    String? producerId = producersBloc.producer?.id;
    if (producerId == null) return;
    _isProducing = false;
    producersBloc.remove();

    try {
      await _mediaSoupSignalingSvc!.closeProducer(producerId);
    } catch (error) {}
  }

  Future<void> muteMic() async {
    String producerId = producersBloc.producer!.id;
    producersBloc.pause();

    // producersBloc.add(ProducerPaused(source: 'mic'));

    try {
      await _mediaSoupSignalingSvc!.pauseProducer(producerId);
    } catch (error) {}
  }

  Future<void> unmuteMic() async {
    // producersBloc.add(ProducerResumed(source: 'mic'));
    String producerId = producersBloc.producer!.id;
    producersBloc.resume();

    try {
      await _mediaSoupSignalingSvc!.resumeProducer(producerId);
    } catch (error) {}
  }

  Future<MediaStream> createAudioStream() async {
    // audioInputDeviceId = mediaDevicesBloc.state.selectedAudioInput!.deviceId;
    audioInputDeviceId = mediaDevicesBloc.audioInput!.deviceId;
    Map<String, dynamic> mediaConstraints = {
      'audio': {
        'optional': [
          {
            'sourceId': audioInputDeviceId,
          },
        ],
      },
    };

    MediaStream stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

    return stream;
  }

  Future<void> _joinRoom() async {
    _log("joining room...");
    try {
      _mediaSoupCoreSvc!.createDevice();
      await _mediaSoupCoreSvc!.getAndLoadRouterCapabilities();
      _produce = _mediaSoupCoreSvc!.canProduceAudio();
      // _produce = _mediaSoupCoreSvc!.canProduce();

      if (_produce) {
        await _mediaSoupCoreSvc!.createSendTransport();
      }

      if (_consume) {
        _mediaSoupCoreSvc!.createReceiveTransport();
      }

      Map response = await _mediaSoupSignalingSvc!.join({
        'displayName': displayName,
        'device': {
          'name': "Flutter",
          'flag': 'flutter',
          'version': '0.8.0',
        },
        'rtpCapabilities': _mediaSoupCoreSvc!.device!.rtpCapabilities.toMap(),
        'sctpCapabilities': _mediaSoupCoreSvc!.device!.sctpCapabilities.toMap(),
      });

      onRoomJoined?.call();

      response['peers']?.forEach((value) {
        // peersBloc.add(PeerAdd(newPeer: value));
        final pr = peersBloc.add(value);
        _log("peer=>${pr.id}");
      });

      if (_produce) {
        if (isLiveCall) {
          enableMic();
        }

        _mediaSoupCoreSvc!.sendTransport!.on('connectionstatechange', (connectionState) {
          _log("_sendTransport.connectionstatechange $connectionState");
          if (connectionState == 'connected') {
            // enableChatDataProducer();
            // enableBotDataProducer();
          }
        });
      }
    } catch (error) {
      _log(error.toString());
      close();
    }
  }

  void connectToGroup(String groupId) {}

  void join({String? p_url}) {
    /*_webSocket = WebSocket(
      // peerId: peerId,
      // roomId: roomId,
      url: url,
    );*/

    _webSocket = ProtoWebSocket(connectionPath: p_url ?? this.url);

    // _webSocket.onNotificationCallBack

    _mediaSoupSignalingSvc = MediaSoupSignalingSvc(_webSocket as ISocket);

    _mediaSoupCoreSvc = MediaSoupCoreSvc(
      _mediaSoupSignalingSvc!,
      onProducerTrackended: () {
        disableMic().catchError((data) {});
        onProducerTrackendedCallback?.call();
      },
      onProducerJoined: (pr) {
        producersBloc.add(pr);
        onProducerCallback?.call(pr);
      },
      onConsumer: (cons) {
        //TODO: reflect consumer on circle _ALL
        peersBloc.addConsumer(consumer: cons);
        onConsumerCallback?.call(cons, true);
      },
    );

    _log("connecting $url");

    _webSocket!.onOpen = _joinRoom;
    _webSocket!.onFail = () {
      _log('WebSocket connection failed');
    };
    _webSocket!.onDisconnected = () {
      _log("_webSocket.onDisconnected");
      _mediaSoupCoreSvc!.onDisconnected();
    };
    _webSocket!.onClose = () {
      if (_closed) return;
      _log("_webSocket.onClose");
      onSocketClosed?.call();
      close();
    };

    _webSocket!.onRequestCallBack = (request, accept, reject) async {
      switch (request['method']) {
        case 'newConsumer':
          {
            if (!_consume) {
              reject(403, 'I do not want to consume');
              break;
            }
            try {
              _mediaSoupCoreSvc!.consume(request['data'], accept: accept);
            } catch (error) {
              _log('newConsumer request failed: $error');
              throw (error);
            }
            break;
          }
        default:
          break;
      }
    };

    _webSocket!.onNotificationCallBack = (notification) async {
      switch (notification['method']) {
        case "activeSpeaker":
          onActiveSpeaker?.call(notification['data']['peerId']);
          break;
        case 'producerScore':
          {
            break;
          }
        case 'consumerClosed':
          {
            String consumerId = notification['data']['consumerId'];
            final cons = peersBloc.removeConsumer(consumerId);
            // _log("consumerClosed peerId:${pr?.id}");
            onConsumerCallback?.call(cons, false);
            // peersBloc.add(PeerRemoveConsumer(consumerId: consumerId));

            break;
          }
        case 'consumerPaused':
          {
            String consumerId = notification['data']['consumerId'];
            _log("consumerPaused $consumerId");
            peersBloc.pauseConsumer(consumerId);
            // peersBloc.add(PeerPausedConsumer(consumerId: consumerId));
            break;
          }

        case 'consumerResumed':
          {
            String consumerId = notification['data']['consumerId'];
            _log("consumerResumed $consumerId");
            peersBloc.removeConsumer(consumerId);
            // peersBloc.add(PeerResumedConsumer(consumerId: consumerId));
            break;
          }

        case 'newPeer':
          {
            final Map<String, dynamic> newPeer = Map<String, dynamic>.from(notification['data']);
            // peersBloc.add(PeerAdd(newPeer: newPeer));
            final p = peersBloc.add(newPeer);
            _log("newPeer ${p.id}");
            break;
          }

        case 'peerClosed':
          {
            String peerId = notification['data']['peerId'];
            _log("peerClosed $peerId");
            // peersBloc.add(PeerRemove(peerId: peerId));
            peersBloc.remove(peerId);
            break;
          }

        default:
          break;
      }
    };
  }

  void dispose() {
    _mediaDevicesAudioInputSub.cancel();
    _webSocket?.close();
  }

  void _log(String str) {
    log("$runtimeType $str");
    onLogCallBack?.call(str);
  }
}
