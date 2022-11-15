import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_socket.dart';

class MediaSoupSignalingSvc {
  final ISocket socket;

  MediaSoupSignalingSvc(this.socket);
  Future join(Map<String, dynamic> data) => _sendAction("join", data);

  Future getRouterRtpCapabilities() => _sendAction("getRouterRtpCapabilities", {});
  Future createWebRtcTransport(Map<String, dynamic> data) => _sendAction("createWebRtcTransport", data);
  Future connectWebRtcTransport(Map<String, dynamic> data) => _sendAction("connectWebRtcTransport", data);
  Future produce(Map<String, dynamic> data) => _sendAction("produce", data);
  Future produceData(Map<String, dynamic> data) => _sendAction("produceData", data);
  Future closeProducer(String producerId) => _sendAction("closeProducer", {'producerId': producerId});
  Future pauseProducer(String producerId) => _sendAction("pauseProducer", {'producerId': producerId});
  Future resumeProducer(String producerId) => _sendAction("resumeProducer", {'producerId': producerId});

  Future _sendAction(String type, Map<String, dynamic> data) {
    return socket.request(type, data);
  }
}
