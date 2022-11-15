import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt_soup/mediasoup_signaling_svc.dart';

class MediaSoupCoreSvc {
  final Function onProducerTrackended;
  final Function(Producer) onProducerJoined;
  final Function(Consumer) onConsumer;

  final MediaSoupSignalingSvc signalingSvc;

  Device? _mediasoupDevice;
  Transport? _receiveTransport;
  Transport? _sendTransport;

  MediaSoupCoreSvc(
    this.signalingSvc, {
    required this.onProducerTrackended,
    required this.onProducerJoined,
    required this.onConsumer,
  });

  get sendTransport => _sendTransport;

  get device => _mediasoupDevice;

  void createDevice() {
    _mediasoupDevice = Device();
  }

  dynamic getDeviceRtpCapabilities() {
    return _mediasoupDevice!.rtpCapabilities;
  }

  bool canProduceAudio() => _mediasoupDevice?.canProduce(RTCRtpMediaType.RTCRtpMediaTypeAudio) ?? false;
  bool canProduce() {
    return _mediasoupDevice!.canProduce(RTCRtpMediaType.RTCRtpMediaTypeAudio) == true ||
        _mediasoupDevice!.canProduce(RTCRtpMediaType.RTCRtpMediaTypeVideo) == true;
  }

  Future getAndLoadRouterCapabilities() async {
    final Map<String, dynamic> routerRtpCapabilities = await signalingSvc.getRouterRtpCapabilities();
    final rtpCapabilities = RtpCapabilities.fromMap(routerRtpCapabilities);
    rtpCapabilities.headerExtensions.removeWhere((he) => he.uri == 'urn:3gpp:video-orientation');
    return _mediasoupDevice!.load(routerRtpCapabilities: rtpCapabilities);
  }

  Future _createTransportData(bool isProducing) => signalingSvc.createWebRtcTransport({
        'forceTcp': false,
        'producing': isProducing,
        'consuming': !isProducing,
        'sctpCapabilities': _mediasoupDevice!.sctpCapabilities.toMap(),
      });

  Future createReceiveTransport() async {
    Map transportInfo = await _createTransportData(false);

    _receiveTransport = _mediasoupDevice!.createRecvTransportFromMap(
      transportInfo,
      consumerCallback: _consumerCallback,
    );

    _receiveTransport!.on(
      'connect',
      (data) {
        _log("_recvTransport.connect");
        signalingSvc
            .connectWebRtcTransport(
              {
                'transportId': _receiveTransport!.id,
                'dtlsParameters': data['dtlsParameters'].toMap(),
              },
            )
            .then(data['callback'])
            .catchError(data['errback']);
      },
    );
  }

  Future createSendTransport() async {
    Map transportInfo = await _createTransportData(true);

    _sendTransport = _mediasoupDevice!.createSendTransportFromMap(
      transportInfo,
      producerCallback: _producerCallback,
    );

    _sendTransport!.on('connect', (Map data) {
      signalingSvc
          .connectWebRtcTransport({
            'transportId': _sendTransport!.id,
            'dtlsParameters': data['dtlsParameters'].toMap(),
          })
          .then(data['callback'])
          .catchError(data['errback']);
    });

    _sendTransport!.on('produce', (Map data) async {
      _log("_sendTransport.produce");
      try {
        Map response = await signalingSvc.produce(
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
        Map response = await signalingSvc.produceData({
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

  void consume(Map<String, dynamic> map, {Function? accept}) {
    _receiveTransport!.consume(
      id: map['id'],
      producerId: map['producerId'],
      kind: RTCRtpMediaTypeExtension.fromString(map['kind']),
      rtpParameters: RtpParameters.fromMap(map['rtpParameters']),
      appData: Map<String, dynamic>.from(map['appData']),
      peerId: map['peerId'],
      accept: accept,
    );
  }

  void _producerCallback(Producer producer) {
    producer.on('trackended', () {
      onProducerTrackended();
      // disableMic().catchError((data) {});
    });
    onProducerJoined(producer);
    // producersBloc.add(producer);
  }

  void _consumerCallback(Consumer consumer, [dynamic accept]) {
    ScalabilityMode scalabilityMode = ScalabilityMode.parse(consumer.rtpParameters.encodings.first.scalabilityMode);

    accept({});
    onConsumer(consumer);

    // peersBloc.add(PeerAddConsumer(peerId: consumer.peerId, consumer: consumer));
  }

  void _log(String str) {
    log("$runtimeType $str");
    // onLogCallBack?.call(str);
  }

  void onDisconnected() {
    if (_sendTransport != null) {
      _sendTransport!.close();
      _sendTransport = null;
    }
    if (_receiveTransport != null) {
      _receiveTransport!.close();
      _receiveTransport = null;
    }
  }

  void close() {
    _sendTransport?.close();
    _receiveTransport?.close();
  }

  void produce(MediaStream audioStream) {
    final MediaStreamTrack track = audioStream.getAudioTracks().first;
    _sendTransport!.produce(
      track: track,
      codecOptions: ProducerCodecOptions(opusStereo: 1, opusDtx: 1),
      stream: audioStream,
      appData: {
        'source': 'mic',
      },
      source: 'mic',
    );
  }
}
