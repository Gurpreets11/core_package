import 'package:connectivity_plus/connectivity_plus.dart';

import 'connectivity_service.dart';

/// The real [ConnectivityService] implementation, backed by
/// `connectivity_plus`.
class ConnectivityServiceImpl implements ConnectivityService {
  /// Creates a [ConnectivityServiceImpl].
  ///
  /// Pass a custom [connectivity] instance in tests; defaults to a real
  /// [Connectivity].
  ConnectivityServiceImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}
