import 'dart:async';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  static ConnectivityService _instance;
  StreamController<ConnectionStatus> _connectionStatusController =
      StreamController<ConnectionStatus>.broadcast();
  Connectivity connectivity = Connectivity();
  ConnectionStatus status;

  Future<ConnectionStatus> get currentStatus async {
    var result = await connectivity.checkConnectivity();
    return _getStatusFromResult(result);
  }

  factory ConnectivityService() {
    _instance ??= ConnectivityService._();
    return _instance;
  }
  ConnectivityService._() {
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      status = _getStatusFromResult(result);
      _connectionStatusController.add(status);
    });
  }

  StreamSubscription<ConnectionStatus> listen(
      void Function(ConnectionStatus) onData,
      {Function onError,
      void Function() onDone,
      bool cancelOnError}) {
    onData(status);
    return _connectionStatusController.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
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
