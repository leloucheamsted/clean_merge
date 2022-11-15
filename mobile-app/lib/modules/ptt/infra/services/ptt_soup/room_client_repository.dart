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

import 'blocs/mediadevices_bloc.dart';
import 'blocs/peers_bloc.dart';
import 'blocs/producers_bloc.dart';
import 'web_socket.dart';

class RoomClientRepository {
  final ProducersBloc producersBloc;
  final PeersBloc peersBloc;
  // final MeBloc meBloc;
  // final RoomBloc roomBloc;
  final MediaDevicesBloc mediaDevicesBloc;

  // final String roomId;
  // final String peerId;
  final String url;
  final String displayName;

  bool _closed = false;

  WebSocket? _webSocket;
  Device? _mediasoupDevice;
  Transport? _sendTransport;
  Transport? _recvTransport;
  bool _produce = false;
  bool _consume = true;
  // StreamSubscription<MediaDevicesState>? _mediaDevicesBlocSubscription;
  late StreamSubscription _mediaDevicesAudioInputSub;
  String? audioInputDeviceId;
  String? audioOutputDeviceId;
  String? videoInputDeviceId;

  Function(String)? onLogCallBack;

  RoomClientRepository({
    required this.producersBloc,
    required this.peersBloc,
    // required this.meBloc,
    // required this.roomBloc,
    // required this.roomId,
    // required this.peerId,
    required this.url,
    required this.displayName,
    required this.mediaDevicesBloc,
    this.onLogCallBack,
  }) {
    _mediaDevicesAudioInputSub = mediaDevicesBloc.outAudioInput.listen((event) async {
      if (event != null && audioInputDeviceId != event.deviceId) {
        await disableMic();
        enableMic();
      }
    });
    // mediaDevicesBloc.actionLoad();
    /*_mediaDevicesBlocSubscription =
        mediaDevicesBloc.stream.listen((MediaDevicesState state) async {
      if (state.selectedAudioInput != null &&
          state.selectedAudioInput?.deviceId != audioInputDeviceId) {
        await disableMic();
        enableMic();
      }

    });*/
  }

  void close() {
    if (_closed) {
      return;
    }

    _webSocket?.close();
    _sendTransport?.close();
    _recvTransport?.close();
    // _mediaDevicesBlocSubscription?.cancel();
  }

  Future<void> disableMic() async {
    // String micId = producersBloc.state.mic!.id;

    // producersBloc.add(ProducerRemove(source: 'mic'));
    String? producerId = producersBloc.producer?.id;
    if (producerId == null) return;
    producersBloc.remove();

    try {
      await _webSocket!.socket.request('closeProducer', {
        'producerId': producerId,
      });
    } catch (error) {}
  }

  Future<void> muteMic() async {
    String producerId = producersBloc.producer!.id;
    producersBloc.pause();

    // producersBloc.add(ProducerPaused(source: 'mic'));

    try {
      await _webSocket!.socket.request('pauseProducer', {
        'producerId': producerId,
      });
    } catch (error) {}
  }

  Future<void> unmuteMic() async {
    // producersBloc.add(ProducerResumed(source: 'mic'));
    String producerId = producersBloc.producer!.id;
    producersBloc.resume();

    try {
      await _webSocket!.socket.request('resumeProducer', {
        'producerId': producerId,
      });
    } catch (error) {}
  }

  void _producerCallback(Producer producer) {
    producer.on('trackended', () {
      disableMic().catchError((data) {});
    });
    producersBloc.add(producer);
  }

  void _consumerCallback(Consumer consumer, [dynamic accept]) {
    ScalabilityMode scalabilityMode = ScalabilityMode.parse(consumer.rtpParameters.encodings.first.scalabilityMode);

    accept({});

    // peersBloc.add(PeerAddConsumer(peerId: consumer.peerId, consumer: consumer));
    peersBloc.addConsumer(consumer: consumer);
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

  void enableMic() async {
    if (_mediasoupDevice?.canProduce(RTCRtpMediaType.RTCRtpMediaTypeAudio) == false) {
      return;
    }
    if (_sendTransport == null) return;

    MediaStream? audioStream;
    MediaStreamTrack? track;
    try {
      audioStream = await createAudioStream();
      track = audioStream.getAudioTracks().first;
      _sendTransport!.produce(
        track: track,
        codecOptions: ProducerCodecOptions(opusStereo: 1, opusDtx: 1),
        stream: audioStream,
        appData: {
          'source': 'mic',
        },
        source: 'mic',
      );
    } catch (error) {
      if (audioStream != null) {
        await audioStream.dispose();
      }
    }
  }

  Future<void> _joinRoom() async {
    _log("joining room...");
    try {
      _mediasoupDevice = Device();

      dynamic routerRtpCapabilities = await _webSocket!.socket.request('getRouterRtpCapabilities', {});

      final rtpCapabilities = RtpCapabilities.fromMap(routerRtpCapabilities);
      rtpCapabilities.headerExtensions.removeWhere((he) => he.uri == 'urn:3gpp:video-orientation');

      _log(rtpCapabilities.toString());

      await _mediasoupDevice!.load(routerRtpCapabilities: rtpCapabilities);

      if (_mediasoupDevice!.canProduce(RTCRtpMediaType.RTCRtpMediaTypeAudio) == true ||
          _mediasoupDevice!.canProduce(RTCRtpMediaType.RTCRtpMediaTypeVideo) == true) {
        _produce = true;
      }

      if (_produce) {
        Map transportInfo = await _webSocket!.socket.request('createWebRtcTransport', {
          'forceTcp': false,
          'producing': true,
          'consuming': false,
          'sctpCapabilities': _mediasoupDevice!.sctpCapabilities.toMap(),
        });

        _sendTransport = _mediasoupDevice!.createSendTransportFromMap(
          transportInfo,
          producerCallback: _producerCallback,
        );

        _sendTransport!.on('connect', (Map data) {
          _webSocket!.socket
              .request('connectWebRtcTransport', {
                'transportId': _sendTransport!.id,
                'dtlsParameters': data['dtlsParameters'].toMap(),
              })
              .then(data['callback'])
              .catchError(data['errback']);
        });

        _sendTransport!.on('produce', (Map data) async {
          _log("_sendTransport.produce");
          try {
            Map response = await _webSocket!.socket.request(
              'produce',
              {
                'transportId': _sendTransport!.id,
                'kind': data['kind'],
                'rtpParameters': data['rtpParameters'].toMap(),
                if (data['appData'] != null) 'appData': Map<String, dynamic>.from(data['appData'])
              },
            );

            data['callback'](response['id']);
          } catch (error) {
            data['errback'](error);
          }
        });

        _sendTransport!.on('producedata', (data) async {
          _log("_sendTransport.producedata");
          try {
            Map response = await _webSocket!.socket.request('produceData', {
              'transportId': _sendTransport!.id,
              'sctpStreamParameters': data['sctpStreamParameters'].toMap(),
              'label': data['label'],
              'protocol': data['protocol'],
              'appData': data['appData'],
            });

            data['callback'](response['id']);
          } catch (error) {
            data['errback'](error);
          }
        });
      }

      if (_consume) {
        Map transportInfo = await _webSocket!.socket.request(
          'createWebRtcTransport',
          {
            'forceTcp': false,
            'producing': false,
            'consuming': true,
            'sctpCapabilities': _mediasoupDevice!.sctpCapabilities.toMap(),
          },
        );

        _recvTransport = _mediasoupDevice!.createRecvTransportFromMap(
          transportInfo,
          consumerCallback: _consumerCallback,
        );

        _recvTransport!.on(
          'connect',
          (data) {
            _log("_recvTransport.connect");
            _webSocket!.socket
                .request(
                  'connectWebRtcTransport',
                  {
                    'transportId': _recvTransport!.id,
                    'dtlsParameters': data['dtlsParameters'].toMap(),
                  },
                )
                .then(data['callback'])
                .catchError(data['errback']);
          },
        );
      }

      Map response = await _webSocket!.socket.request('join', {
        'displayName': displayName,
        'device': {
          'name': "Flutter",
          'flag': 'flutter',
          'version': '0.8.0',
        },
        'rtpCapabilities': _mediasoupDevice!.rtpCapabilities.toMap(),
        'sctpCapabilities': _mediasoupDevice!.sctpCapabilities.toMap(),
      });

      response['peers']?.forEach((value) {
        // peersBloc.add(PeerAdd(newPeer: value));
        peersBloc.add(value);
      });

      if (_produce) {
        enableMic();

        _sendTransport!.on('connectionstatechange', (connectionState) {
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

  void join() {
    _webSocket = WebSocket(
      // peerId: peerId,
      // roomId: roomId,
      url: url,
    );

    _log("connecting $url");

    _webSocket!.onOpen = _joinRoom;
    _webSocket!.onFail = () {
      _log('WebSocket connection failed');
    };
    _webSocket!.onDisconnected = () {
      _log("_webSocket.onDisconnected");
      if (_sendTransport != null) {
        _sendTransport!.close();
        _sendTransport = null;
      }
      if (_recvTransport != null) {
        _recvTransport!.close();
        _recvTransport = null;
      }
    };
    _webSocket!.onClose = () {
      if (_closed) return;
      _log("_webSocket.onClose");

      close();
    };

    _webSocket!.onRequest = (request, accept, reject) async {
      switch (request['method']) {
        case 'newConsumer':
          {
            if (!_consume) {
              reject(403, 'I do not want to consume');
              break;
            }
            try {
              _recvTransport!.consume(
                id: request['data']['id'],
                producerId: request['data']['producerId'],
                kind: RTCRtpMediaTypeExtension.fromString(request['data']['kind']),
                rtpParameters: RtpParameters.fromMap(request['data']['rtpParameters']),
                appData: Map<String, dynamic>.from(request['data']['appData']),
                peerId: request['data']['peerId'],
                accept: accept,
              );
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

    _webSocket!.onNotification = (notification) async {
      // _log("onNotification $notification");
      switch (notification['method']) {
        case 'producerScore':
          {
            break;
          }
        case 'consumerClosed':
          {
            String consumerId = notification['data']['consumerId'];
            _log("consumerClosed $consumerId");
            peersBloc.removeConsumer(consumerId);
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
