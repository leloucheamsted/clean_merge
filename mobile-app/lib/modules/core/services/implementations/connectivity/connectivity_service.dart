import 'package:connectivity_plus/connectivity_plus.dart';

import '../../interfaces/iconnectivity_service.dart';

class ConnectivityService implements IConnectivityService {
  // late final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> get isConnected async {
    final connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  @override
  Stream<bool> get statusStream =>
      Connectivity().onConnectivityChanged.map((result) => result != ConnectivityResult.none);
}
