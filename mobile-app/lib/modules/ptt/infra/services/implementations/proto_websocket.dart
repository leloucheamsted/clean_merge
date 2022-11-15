import '../interfaces/i_socket.dart';

import 'package:protoo_client/protoo_client.dart' as protoo_client;

class ProtoWebSocket extends BaseSocket {
  late final protoo_client.Peer _protoo;

  ProtoWebSocket({
    super.connectionPath,
    super.onSocketEventCallBack,
  }) {
    if (connectionPath != null) {
      init();
    }
  }
  @override
  void init() {
    _init();
    super.init();
  }

  void _init() {
    _protoo = protoo_client.Peer(
      protoo_client.Transport(connectionPath!),
    );

    _protoo.on('open', () => onSocketEvent(SocketEventType.open));
    _protoo.on('failed', () => onSocketEvent(SocketEventType.failed));
    _protoo.on('disconnected', () => onSocketEvent(SocketEventType.disconnected));
    _protoo.on('close', () => onSocketEvent(SocketEventType.close));
    _protoo.on('request', (request, accept, reject) => onRequest.call(request, accept, reject));
    _protoo.on('notification', (request, accept, reject) => onNotification.call(request));
  }

  @override
  bool get isConnected => _protoo.connected;

  @override
  Future close() {
    if (_protoo.connected) {
      _protoo.close();
    }
    return Future.value();
  }

  @override
  Future request(String type, Map<String, dynamic> data) {
    return _protoo.request(type, data);
  }

  @override
  Future connect() {
    super.connect();
    //auto connects on init _ALL
    return Future.value();
  }
}
