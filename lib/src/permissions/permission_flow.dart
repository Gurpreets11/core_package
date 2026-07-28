import 'package:flutter/material.dart';

import '../widgets/dialogs/app_dialogs.dart';
import 'permission_service.dart';

/// A ready-made permission request flow: check → (if needed) show a
/// rationale dialog → request → if permanently denied, offer to open
/// Settings. Every app tends to get this UX slightly wrong (skipping
/// the rationale, or leaving the user stuck after a permanent denial
/// with no way forward) — this centralizes the correct sequence once.
///
/// ```dart
/// final granted = await PermissionFlow.ensureGranted(
///   context,
///   service: permissionService,
///   permission: AppPermission.camera,
///   rationaleTitle: 'Camera access needed',
///   rationaleMessage: 'To attach a photo to this lead, allow camera access.',
/// );
/// if (granted) {
///   // proceed to open the camera
/// }
/// ```
abstract final class PermissionFlow {
  /// Runs the full check/request/settings flow for [permission].
  /// Returns `true` only if the permission ends up granted.
  static Future<bool> ensureGranted(
    BuildContext context, {
    required PermissionService service,
    required AppPermission permission,
    required String rationaleTitle,
    required String rationaleMessage,
    String settingsTitle = 'Permission required',
    String settingsMessage =
        'This permission was previously denied. Please enable it from '
            'Settings to continue.',
  }) async {
    final currentStatus = await service.check(permission);
    if (currentStatus == AppPermissionStatus.granted) return true;

    if (currentStatus == AppPermissionStatus.permanentlyDenied) {
      if (!context.mounted) return false;
      final shouldOpenSettings = await AppDialogs.showConfirm(
        context,
        title: settingsTitle,
        message: settingsMessage,
        confirmLabel: 'Open Settings',
      );
      if (shouldOpenSettings) await service.openAppSettings();
      return false;
    }

    if (!context.mounted) return false;
    final shouldRequest = await AppDialogs.showConfirm(
      context,
      title: rationaleTitle,
      message: rationaleMessage,
      confirmLabel: 'Continue',
    );
    if (!shouldRequest) return false;

    final result = await service.request(permission);
    return result == AppPermissionStatus.granted;
  }
}
