import 'package:permission_handler/permission_handler.dart' as ph;

import 'permission_service.dart';

/// The real [PermissionService] implementation, backed by
/// `permission_handler`. Maps that package's [ph.Permission] and
/// [ph.PermissionStatus] to this package's own [AppPermission] /
/// [AppPermissionStatus] enums, so consuming apps never import
/// `permission_handler` directly.
class PermissionServiceImpl implements PermissionService {
  @override
  Future<AppPermissionStatus> check(AppPermission permission) async {
    final status = await _toPhPermission(permission).status;
    return _toAppStatus(status);
  }

  @override
  Future<AppPermissionStatus> request(AppPermission permission) async {
    final status = await _toPhPermission(permission).request();
    return _toAppStatus(status);
  }

  @override
  Future<bool> openAppSettings() => ph.openAppSettings();

  ph.Permission _toPhPermission(AppPermission permission) {
    return switch (permission) {
      AppPermission.camera => ph.Permission.camera,
      AppPermission.location => ph.Permission.location,
      AppPermission.photos => ph.Permission.photos,
      AppPermission.notifications => ph.Permission.notification,
      AppPermission.microphone => ph.Permission.microphone,
    };
  }

  AppPermissionStatus _toAppStatus(ph.PermissionStatus status) {
    return switch (status) {
      ph.PermissionStatus.granted ||
      ph.PermissionStatus.limited ||
      ph.PermissionStatus.provisional =>
        AppPermissionStatus.granted,
      ph.PermissionStatus.denied => AppPermissionStatus.denied,
      ph.PermissionStatus.permanentlyDenied =>
        AppPermissionStatus.permanentlyDenied,
      ph.PermissionStatus.restricted => AppPermissionStatus.restricted,
    };
  }
}
