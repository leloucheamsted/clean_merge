import 'dart:async';

import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketIoClient extends BaseSocket {
  late io.Socket _socket;
  SocketIoClient({
    super.connectionPath,
    super.onSocketEventCallBack,
  }) {
    // final signaling = '$url/?peerId=$peerId&roomId=$roomId';
    /*final String peerId = "testPeerID";
    final String roomId = "testRoomID";
    _socket = io.io(
        connectionPath,
        io.OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
            .setExtraHeaders({
          'peerId': peerId,
          'roomId': roomId,
        }) // optional
            .build());*/
  }
  @override
  void init() {
    _socket = io.io(
        connectionPath,
        io.OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
            .setExtraHeaders({
          // 'peerId': peerId,
          // 'roomId': roomId,
        }) // optional
            .build());
    _socket.on('connect', (_) {
      onSocketEvent(SocketEventType.open);
    });

    _socket.on('disconnect', (_) {
      onSocketEvent(SocketEventType.disconnected);
    });

    _socket.on('close', (_) {
      onSocketEvent(SocketEventType.close);
    });

    _socket.on('error', (_) {
      onSocketEvent(SocketEventType.failed);
    });

    _socket.on('request', (dynamic request) {
      if (onRequest != null) {
        onRequest!(request, (dynamic response) {
          _socket.emit('response', response);
        }, (dynamic error) {
          _socket.emit('response', error);
        });
      }
    });

    _socket.on('notification', (dynamic notification) {
      if (onNotification != null) {
        onNotification!(notification);
      }
    });

    _socket.connect();

    super.init();
  }

  @override
  Future close() {
    _socket.close();
    // _socket.disconnect();
    return Future.value(null);
  }

  @override
  Future connect() {
    super.connect();
    return Future.value(null);
  }

  @override
  // TODO: implement isConnected
  bool get isConnected => _socket.connected;

  @override
  Future request(String type, Map<String, dynamic> data) {
    final completer = Completer<dynamic>();
    final requestId = _socket.id;

    _socket.emitWithAck(
      'request',
      {
        'method': type,
        'data': data,
        'requestId': requestId,
      },
      ack: (response) {
        log('Event $type: $response');
        completer.complete(response[1]);
      },
    );
    return completer.future;
    // _socket.emit(type, data);
    // return Future.value(null);
  }
  // SocketIoClient({required super.connectionPath, required super.onSocketEvent});

}
