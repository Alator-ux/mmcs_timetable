import 'dart:async';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  StreamController<ConnectionStatus> ConnectionStatusController =
      StreamController<ConnectionStatus>.broadcast();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
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
