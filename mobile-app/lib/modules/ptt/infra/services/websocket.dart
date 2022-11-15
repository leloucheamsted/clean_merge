import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_socket.dart';

import '../../domain/entities/handshake.entity.dart';

typedef OnMessageCallback = void Function(String msg);
typedef OnCloseCallback = void Function(int? code, String? reason);
typedef OnOpenCallback = void Function();
typedef OnTimeoutCallback = void Function();

typedef GetTokenAction = String Function();

class SimpleWebSocket implements ISocket {
  WebSocket? _socket;
  OnOpenCallback? onOpen;
  OnMessageCallback? onMessage;
  OnCloseCallback? onClose;
  OnTimeoutCallback? onTimeout;
  String? peerId;
  String? userId;
  String? groupId;
  bool? isBackgroundService;
  bool failedCreatingSocket = false;
  StreamSubscription? _socketSub;

  // final String Function() getToken;

  final HandshakeEntity handshakeEntity;
  final GetTokenAction getToken;

  SimpleWebSocket({
    required this.handshakeEntity,
    required this.getToken,
    this.peerId,
    this.userId,
    this.groupId,
    this.isBackgroundService,
    this.onTimeout,
  });

  @override
  Future<void> connect() async {
    try {
      _socket =
          await _connectForSelfSignedCert(handshakeEntity.schema, handshakeEntity.host, port: handshakeEntity.port);
      if (_socket == null) {
        failedCreatingSocket = true;
        onTimeout?.call();
        return;
      }

      failedCreatingSocket = false;
      if (onOpen != null) {
        _log("onOpen");
        onOpen?.call();
      }
      _socketSub = _socket!.listen((data) {
        _log("onMessage $data");
        onMessage?.call(data.toString());
      }, onDone: () {
        _log("onDone.onClose");
        onClose?.call(_socket!.closeCode, _socket!.closeReason);
      }, onError: (e) {
        // TelloLogger().e('SimpleWebSocket error: $e');
        _log("onError $e");
        onClose?.call(_socket!.closeCode, _socket!.closeReason);
      });
    } catch (e) {
      failedCreatingSocket = true;
      _log("error $e");

      onClose?.call(500, e.toString());
    }
  }

  void _log(String msg) {
    print("#$runtimeType=>$msg");
    // log("#$runtimeType=>$msg");
  }

  @override
  Future request(String type, Map<String, dynamic> data) {
    _socket!.add(type);
    return Future.value();
  }

  void send(String data) {
    if (_socket != null) {
      _socket!.add(data);
      // TelloLogger().i('websocket send data: $data');
    }
  }

  Future<void> close() async {
    _socketSub?.cancel();
    await _socket?.close();
  }

  Future<WebSocket?> _connectForSelfSignedCert(String? schema, String? host, {int? port}) async {
    try {
      final String key = base64.encode(List<int>.generate(8, (_) => math.Random().nextInt(255)));
      final SecurityContext securityContext = SecurityContext();
      final HttpClient client = HttpClient(context: securityContext);
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        // TelloLogger().i('Allow self-signed certificate => $host:$port. ');
        return true;
      };
      // final String url = handshakeEntity.url;
      final Uri uri = handshakeEntity.uri;
      // TelloLogger().i("GET REQUEST 00000000 $url");
      // TelloLogger().i(url);

      // final HttpClientRequest request = await client.getUrl(Uri.parse(url));

      // bool timeOutHappened = false;
      _log("upgrading socket $uri");
      final HttpClientRequest request =
          await client.getUrl(uri).timeout(const Duration(seconds: 5)); // form the correct url here

      request.headers.add('Connection', 'Upgrade');
      request.headers.add('Upgrade', 'websocket');
      request.headers.add('Sec-WebSocket-Version', '13'); // insert the correct version here
      request.headers.add('Sec-WebSocket-Key', key.toLowerCase());
      request.headers.add('sec-websocket-protocol', 'protoo');

      final HttpClientResponse response = await request.close();

      if (response.statusCode != 200 && response.statusCode != 101) {
        //TODO: handle this error case
        //not success probably timeout
        throw Exception("#SocketUpgrade.Failed code:${response.statusCode} ${response.reasonPhrase}");
        return null;
      }
      final Socket socket = await response.detachSocket();
      final webSocket = WebSocket.fromUpgradedSocket(
        socket,
        protocol: 'signaling',
        serverSide: false,
      );
      return webSocket;
    } catch (e, s) {
      // TelloLogger().e('_connectForSelfSignedCert error: $e', stackTrace: s);
      rethrow;
    }
  }

  @override
  bool get isConnected => throw UnimplementedError();
}
