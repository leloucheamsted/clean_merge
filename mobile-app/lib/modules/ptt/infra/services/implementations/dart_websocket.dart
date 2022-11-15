import 'dart:async';

import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_socket.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:math';

class DartWebSocket extends BaseSocket {
  // late final WebSocket _websocket;
  WebSocket? _websocket;
  bool isSocketReady = false;
  StreamSubscription? _socketSub;
  DartWebSocket({
    super.connectionPath,
    super.onSocketEventCallBack,
  }) {
    // _connect();
  }

  Future<void> _connect() async {
    try {
      WebSocket? ws = await _connectForSelfSignedCert();
      if (ws == null) {
        // failedCreatingSocket = true;
        // onTimeout?.call();
        return;
      }

      isSocketReady = true;
      _websocket = ws;
      onSocketEvent(SocketEventType.open);

      _socketSub = _websocket!.listen((data) {
        // onMessage?.call(data.toString());
        onSocketEvent(SocketEventType.notification);
      }, onDone: () {
        // onClose?.call(_socket!.closeCode, _socket!.closeReason);
        onSocketEvent(SocketEventType.close);
      }, onError: (e) {
        onSocketEvent(SocketEventType.failed);
        // TelloLogger().e('SimpleWebSocket error: $e');
        // onClose?.call(_socket!.closeCode, _socket!.closeReason);
      });
    } catch (e) {
      onSocketEvent(SocketEventType.close);
      // onClose?.call(500, e.toString());
    }
  }

  Future<WebSocket?> _connectForSelfSignedCert() async {
    try {
      final String key = base64.encode(List<int>.generate(8, (_) => Random().nextInt(255)));
      final SecurityContext securityContext = SecurityContext();
      final HttpClient client = HttpClient(context: securityContext);
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        // TelloLogger().i('Allow self-signed certificate => $host:$port. ');
        return true;
      };
      /*String? urlSchema = schema;
      if (schema == "ws") {
        urlSchema = "http";
      } else if (schema == "wss") {
        urlSchema = "https";
      }*/
      final HttpClientRequest request = await client
          .getUrl(Uri.parse(connectionPath!))
          .timeout(const Duration(seconds: 5)); // form the correct url here

      request.headers.add('Connection', 'Upgrade');
      request.headers.add('Upgrade', 'websocket');
      request.headers.add('Sec-WebSocket-Version', '13'); // insert the correct version here
      request.headers.add('Sec-WebSocket-Key', key.toLowerCase());
      request.headers.add('sec-websocket-protocol', 'protoo');

      final HttpClientResponse response = await request.close();
      if (response.statusCode != 200 && response.statusCode != 101) {
        //not success probably timeout
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
      rethrow;
    }
  }

  @override
  Future close() {
    _socketSub?.cancel();
    if (!isSocketReady || _websocket == null) return Future.value();
    return _websocket!.close(); //TODO await future
  }

  @override
  Future request(String type, Map<String, dynamic> data) {
    if (_websocket != null) {
      _websocket!.add(data);
      print('send: $data');
    }
    return Future.value();
  }

  @override
  Future connect() {
    // TODO: implement connect
    throw UnimplementedError();
  }
}
