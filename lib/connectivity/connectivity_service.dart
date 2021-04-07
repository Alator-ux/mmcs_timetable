import 'dart:async';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  StreamController<ConnectionStatus> ConnectionStatusController =
      StreamController<ConnectionStatus>.broadcast();
  Connectivity connectivity = Connectivity();

  Future<ConnectionStatus> get currentStatus async {
    var result = await connectivity.checkConnectivity();
    return _getStatusFromResult(result);
  }

  ConnectivityService() {
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      ConnectionStatusController.add(_getStatusFromResult(result));
    });
  }

  ConnectionStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectionStatus.Online;
      case ConnectivityResult.wifi:
        return ConnectionStatus.Online;
      case ConnectivityResult.none:
        return ConnectionStatus.Offline;
      default:
        return ConnectionStatus.Offline;
    }
  }
}

enum ConnectionStatus { Online, Offline }
