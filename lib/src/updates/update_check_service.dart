import 'package:meta/meta.dart';

import '../base/result.dart';

/// The result of an [UpdateCheckService.checkForUpdate] call.
@immutable
class AppVersionInfo {
  /// Creates an [AppVersionInfo].
  const AppVersionInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.updateRequired,
    this.updateUrl,
  });

  /// The version currently installed (typically from `package_info_plus`).
  final String currentVersion;

  /// The latest version available, per whatever source
  /// [UpdateCheckService] consults.
  final String latestVersion;

  /// Whether the app should block usage until updated — as opposed to
  /// merely suggesting an update is available. The distinction between
  /// "required" and "optional" updates is an app-level policy decision
  /// (usually driven by a minimum-supported-version value from the
  /// backend), so this is a plain field the app's implementation sets,
  /// not something this package computes.
  final bool updateRequired;

  /// Where to send the user to update (app store URL), if known.
  final String? updateUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppVersionInfo &&
          currentVersion == other.currentVersion &&
          latestVersion == other.latestVersion &&
          updateRequired == other.updateRequired &&
          updateUrl == other.updateUrl);

  @override
  int get hashCode =>
      Object.hash(currentVersion, latestVersion, updateRequired, updateUrl);
}

/// An abstraction over checking whether the app needs to update.
///
/// Unlike most other services in this package, **there is no bundled
/// implementation** — whether an update is "required" depends entirely
/// on each app's own backend or remote-config source, which this
/// package has no way to know in advance. Implement this interface in
/// the app itself once that source exists:
///
/// ```dart
/// class RemoteConfigUpdateCheckService implements UpdateCheckService {
///   @override
///   Future<Result<AppVersionInfo>> checkForUpdate() async {
///     try {
///       final info = await PackageInfo.fromPlatform();
///       final minVersion = await myRemoteConfig.getMinSupportedVersion();
///       return Result.success(
///         AppVersionInfo(
///           currentVersion: info.version,
///           latestVersion: await myRemoteConfig.getLatestVersion(),
///           updateRequired: _isOlder(info.version, minVersion),
///           updateUrl: myRemoteConfig.getStoreUrl(),
///         ),
///       );
///     } catch (error) {
///       return Result.failure(ExceptionMapper.toFailure(error));
///     }
///   }
/// }
/// ```
abstract interface class UpdateCheckService {
  /// Checks for an available/required update.
  Future<Result<AppVersionInfo>> checkForUpdate();
}
