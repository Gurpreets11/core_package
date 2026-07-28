/// A permission this package knows how to request. Deliberately a small,
/// curated set rather than exposing every OS permission — add more here
/// as real apps need them.
enum AppPermission {
  /// Camera access (e.g. product photo capture).
  camera,

  /// Precise/approximate location (e.g. field visit check-ins).
  location,

  /// Photo library access (e.g. picking an existing image to upload).
  photos,

  /// Local/push notification delivery.
  notifications,

  /// Microphone access (e.g. voice notes).
  microphone,
}

/// The result of checking or requesting an [AppPermission].
enum AppPermissionStatus {
  /// The permission is granted.
  granted,

  /// The permission was denied, but can be requested again.
  denied,

  /// The permission was denied permanently — the OS will no longer show
  /// the request dialog; the user must enable it from Settings.
  permanentlyDenied,

  /// The permission isn't available on this platform/device (e.g. no
  /// camera hardware).
  restricted,
}

/// An abstraction over runtime permission requests, so app code depends
/// on this small, stable enum-based interface rather than directly on
/// `permission_handler`'s API — if that package's API changes, only
/// this package's implementation needs updating, not every app.
abstract interface class PermissionService {
  /// Checks the current status of [permission] without prompting.
  Future<AppPermissionStatus> check(AppPermission permission);

  /// Requests [permission], showing the OS prompt if not already
  /// decided. Returns the resulting status.
  Future<AppPermissionStatus> request(AppPermission permission);

  /// Opens the OS app-settings screen (for when a permission is
  /// [AppPermissionStatus.permanentlyDenied] and the user needs to
  /// enable it manually). Returns `true` if the settings screen could
  /// be opened.
  Future<bool> openAppSettings();
}
