import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(this.connectivity);
  final Connectivity connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi) &&
        result.contains(ConnectivityResult.mobile) &&
        result.contains(ConnectivityResult.ethernet);
  }

  @override
  Stream<bool> get onConnectivityChanged =>
      connectivity.onConnectivityChanged.map(
        (result) =>
            result.contains(ConnectivityResult.wifi) &&
            result.contains(ConnectivityResult.mobile) &&
            result.contains(ConnectivityResult.ethernet),
      );
}
