import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:eventify/eventify.dart' as evf;
import 'package:random_string/random_string.dart';
import 'package:rxdart/subjects.dart';
import 'package:tello_social_app/modules/core/services/interfaces/iconnectivity_service.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/handshake.entity.dart';
import '../../domain/entities/socket_request.dart';
import 'websocket.dart';

class Signaling extends evf.EventEmitter {
  // static final Signaling _singleton = Signaling._();

  // factory Signaling() => _singleton;

  final HandshakeEntity handshakeEntity;
  final IConnectivityService connectivityService;

  SimpleWebSocket? _socket;
  String? peerId;
  String? _userId;
  late BehaviorSubject<bool> connected;
  Map<int, SocketRequest>? _requestQueue;
  static bool? isBackgroundService;
  Timer? _heartbeatTimer;
  late bool _isConnecting;
  bool? startRecoverySupport;
  bool isOnline = false;
  bool disposing = false;
  StreamSubscription? _isOnlineListener;

  int socketTimeoutAsSeconds;
  int heartbeatPeriodAsSeconds;
  String webSocketSchema;
  String webSocketAddress;
  int wwsPort;
  Signaling({
    required this.handshakeEntity,
    required this.connectivityService,
    required this.socketTimeoutAsSeconds,
    required this.heartbeatPeriodAsSeconds,
    required this.webSocketSchema,
    required this.webSocketAddress,
    required this.wwsPort,
  });

  void _log(String str) {
    print(str);
    // _log(str);
  }

  void init(String userId) {
    _log('Signaling init started...');
    _userId = userId;
    startRecoverySupport = true;
    _isConnecting = false;
    isBackgroundService = false;
    _requestQueue = {};
    connected = BehaviorSubject();

    _isOnlineListener = connectivityService.statusStream.listen((isConnected) {
      switch (isConnected) {
        case true:
          isOnline = true;
          _log('[Media Signaling]Data connection is available.');
          connect();
          break;
        case false:
          isOnline = false;
          _log('[Media  Signaling]You are disconnected from the internet.');
          if (!_isConnecting) disconnect(closeSocket: true);
          break;
      }
    });

    _heartbeatTimer = Timer.periodic(Duration(seconds: heartbeatPeriodAsSeconds), (timer) async {
      final int isolateId = Isolate.current.hashCode;
      if (_userId != null) {
        if (connected.value == true) {
          _log('[Signalling $peerId $processLabel $isolateId] < -- Heartbeat --- >');
          final dynamic response = await sendWithTimeout('heartbeat', {}, withConnect: true);
          emit('signalingHeartbeatResponse', this, response);
        } else {
          _log('[Signaling $peerId $processLabel] Reconnecting...');
          connect();
        }
      }
    });
    _log('Signaling init ended.');
  }

  Future<void> dispose() async {
    _log('[Signaling IS DISPOSING START]');
    disposing = true;
    startRecoverySupport = false;
    _heartbeatTimer?.cancel();
    _isOnlineListener?.cancel();
    await disconnect(closeSocket: true);
    if (_socket != null) {
      _socket!.onMessage = null;
      _socket!.onOpen = null;
      _socket!.onClose = null;
      _socket = null;
    }

    connected.close();
    peerId = null;
    _userId = null;
    _requestQueue = null;
    isBackgroundService = false;
    _isConnecting = false;
    super.clear();
    disposing = false;
    _log('[Signaling IS DISPOSING DONE]');
  }

  String get processLabel => isBackgroundService! ? 'background' : 'foreground';

  Future<void> connect() async {
    if (_userId == null) return _log('Signaling: _userId is null, returning...');

    final schema = webSocketSchema;
    final host = webSocketAddress;
    final port = wwsPort;

    try {
      _log('[Signalling  connect request $_isConnecting');
      if (_isConnecting) return;
      _isConnecting = true;

      _log('[Signalling $peerId $processLabel] connect request $_userId [$processLabel]');
      if (connected.hasValue && connected.value == true) {
        _log('[Signalling $peerId $processLabel] already connected $_userId [$processLabel]');
        _isConnecting = false;
        return;
      }
      // var url = 'http://$_host:$_port';
      peerId = const Uuid().v1();
      if (_socket != null) {
        await _socket!.close();
        _socket = null;
      }
      _log('[Signaling $peerId $processLabel $schema $host $port] connecting $_userId');

      _socket = SimpleWebSocket(
        handshakeEntity: handshakeEntity,
        // isBackgroundService: isBackgroundService,
        onTimeout: () {
          _log('[Signaling timeout connecting $_userId');
          disconnect();
        },
        getToken: () {
          return "todo";
        },
      );

      _socket!.onOpen = () async {
        _log('[Media Soap Signaling $peerId $processLabel $schema $host $port] onOpen');
        connected.add(true);
        _isConnecting = false;
      };
      _log('[Signaling ====> 0000000] connecting $_userId');
      _socket!.onMessage = (message) {
        const JsonDecoder decoder = JsonDecoder();
        if (onMessage != null) {
          onMessage(decoder.convert(message) as Map<String, dynamic>);
        }
      };

      _socket!.onClose = (int? code, String? reason) async {
        _log(
            '[Media Soap Signaling ${connected.value} ${connected.isClosed} $peerId $processLabel] Closed by server [$code => $reason]!');
        // if (isOnline && !disposing) await AppSettings().tryUpdate();
        disconnect();
      };
      _log('[Signaling ====> 111111111] connecting $_userId');
      await _socket!.connect();
    } catch (e, s) {
      // if (isOnline && !disposing) await AppSettings().tryUpdate();
      // TelloLogger().e("Media Soap  Connection error $e", stackTrace: s);
      disconnect();
    }
  }

  Future<void> disconnect({bool closeSocket = false}) async {
    if (closeSocket && _socket != null) {
      _log("[Signaling $peerId $processLabel] disconnecting...");
      await _socket!.close();
    }
    if (!connected.isClosed) connected.add(false);
    _isConnecting = false;
  }

  Future<void> onMessage(Map<String, dynamic> message) async {
    final data = message['data'] as Map<String, dynamic>?;
    final requestId = message['id'] as int?;
    final method = message['method'] as String?;

    if (_requestQueue!.containsKey(requestId)) {
      _requestQueue![requestId!]!.completer.complete(data);
    }
    if (method != null) {
      emit(method, this, message);
      // _log('onMessage() peerId: $peerId, processLabel: $processLabel', data: message, caller: 'Signaling');
    }

    _requestQueue!.remove(requestId);
  }

  Future<dynamic> sendWithTimeout(String method, Map<String, dynamic>? data, {bool withConnect = false}) async {
    return _send(method, data).timeout(
      Duration(seconds: socketTimeoutAsSeconds),
      onTimeout: () {
        /*TelloLogger().w(
          '[Signalling timeout => $peerId $processLabel] $method ${AppSettings().socketTimeout}',
          data: data,
        );*/
        // disconnect();
        if (withConnect) {
          connected.add(false);
          connect();
        }
      },
    );
  }

  void acceptWithTimeout(
    Map<String, dynamic> message, {
    Map<String, dynamic> data = const {},
  }) {
    //timeout was redundant as method not returns a future
    _accept(message, data: data);
    /*_accept(message, data: data).timeout(
      Duration(seconds: AppSettings().socketTimeout),
      onTimeout: () {
        TelloLogger().w('[Accept timeout!', data: data);
      },
    );*/
  }

  void _accept(
    Map<String, dynamic> message, {
    Map<String, dynamic> data = const {},
  }) {
    const JsonEncoder encoder = JsonEncoder();
    _socket!.send(encoder.convert({
      "response": true,
      "id": message["id"],
      "ok": true,
      "data": data,
    }));
  }

  Future<dynamic> _send(String method, Map<String, dynamic>? data) async {
    if (_socket == null) {
      return null;
    }

    final payload = <String, dynamic>{};
    int requestId;
    do {
      requestId = int.parse(randomNumeric(8));
    } while (_requestQueue!.containsKey(requestId));

    payload['method'] = method;
    payload['request'] = true;
    payload['id'] = requestId;
    payload['data'] = data;
    _log("Signaling is sending request $method id: $requestId");
    _requestQueue![requestId] = SocketRequest(payload);
    const JsonEncoder encoder = JsonEncoder();
    _socket!.send(encoder.convert(payload));

    return _requestQueue![requestId]!.completer.future;
  }

  void log(String msg) {
    print("$runtimeType.$msg");
  }
}
