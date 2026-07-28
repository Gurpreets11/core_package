/// An abstraction over network connectivity detection, so app code
/// depends on this interface rather than directly on `connectivity_plus`
/// — keeps connectivity checks testable and swappable, same reasoning
/// as [SecureStorageService] in the storage module.
abstract interface class ConnectivityService {
  /// Returns `true` if the device currently has network connectivity.
  ///
  /// Note this reflects whether the device is connected to *a* network
  /// (WiFi/cellular), not necessarily that the internet is reachable —
  /// a captive portal or misconfigured network can still report `true`
  /// here. For most apps this distinction doesn't matter in practice.
  Future<bool> get isConnected;

  /// Emits `true`/`false` whenever connectivity changes.
  Stream<bool> get onConnectivityChanged;
}
