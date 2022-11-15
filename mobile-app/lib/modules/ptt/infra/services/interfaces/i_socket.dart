abstract class ISocket {
  // void init(String connectionPath); //'$url/?roomId=$roomId&peerId=$peerId',
  Future connect();
  Future request(String type, Map<String, dynamic> data);
  Future close();

  bool get isConnected;
}

enum SocketEventType { open, close, failed, disconnected, request, notification }

typedef OnSocketEvent = void Function(SocketEventType eventType);

class BaseSocket implements ISocket {
  Function()? onOpen;
  Function()? onFail;
  Function()? onDisconnected;
  Function()? onClose;

  bool _isInit = false;

  Function(dynamic request, dynamic accept, dynamic reject)? onRequestCallBack; // request, accept, reject
  Function(dynamic notification)? onNotificationCallBack;

  String? connectionPath;
  OnSocketEvent? onSocketEventCallBack;
  BaseSocket({
    this.connectionPath,
    this.onSocketEventCallBack,
    // this.onNotificationCallBack,
    // this.onRequestCallBack,
  });

  void init() {
    _isInit = true;
  }

  void setConnectionPath(String path) {
    connectionPath = path;
  }

  void log(String msg) {
    print("$runtimeType.$msg");
  }

  void onSocketEvent(SocketEventType eventType) {
    switch (eventType) {
      case SocketEventType.open:
        onOpen?.call();
        break;
      case SocketEventType.failed:
        onFail?.call();
        break;
      case SocketEventType.close:
        onClose?.call();
        break;
      case SocketEventType.disconnected:
        onDisconnected?.call();
        break;
      default:
    }
    onSocketEventCallBack?.call(eventType);
  }

  void onRequest(dynamic request, dynamic accept, dynamic reject) {
    onRequestCallBack?.call(request, accept, reject);
  }

  void onNotification(dynamic notification) {
    log("onNotification.$notification");
    onNotificationCallBack?.call(notification);
  }

  @override
  Future close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future request(String type, Map<String, dynamic> data) {
    // TODO: implement request
    throw UnimplementedError();
  }

  @override
  Future connect() {
    if (!_isInit) {
      init();
    }
    return Future.value();
  }

  @override
  bool get isConnected => throw UnimplementedError();

  /*@override
  void init(String connectionPath) {
    throw UnimplementedError();
  }*/

  /*
   _protoo.on('open', () => this.onOpen?.call());
    _protoo.on('failed', () => this.onFail?.call());
    _protoo.on('disconnected', () => this.onClose?.call());
    _protoo.on('close', () => this.onClose?.call());
    _protoo.on(
        'request', (request, accept, reject) => this.onRequest?.call(request, accept, reject));
    _protoo.on('notification',
      (request, accept, reject) => onNotification?.call(request)
    );
  */
}
