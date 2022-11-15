abstract class IConnectivityService {
  Future<bool> get isConnected;
  Stream<bool> get statusStream;
}
