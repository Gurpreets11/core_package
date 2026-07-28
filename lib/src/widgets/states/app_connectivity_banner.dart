import 'dart:async';

import 'package:flutter/material.dart';

import '../../connectivity/connectivity_service.dart';
import '../../theme/app_theme_scope.dart';

/// Wraps [child] with a slide-down banner shown whenever
/// [connectivityService] reports no connection, and hidden again once
/// connectivity returns.
///
/// This widget takes a [ConnectivityService] directly (not a Riverpod
/// provider), so `core_package` doesn't need to depend on any specific
/// state-management package — wire it up in your app like:
///
/// ```dart
/// AppConnectivityBanner(
///   connectivityService: ref.watch(connectivityServiceProvider),
///   child: MaterialApp.router(routerConfig: router),
/// )
/// ```
class AppConnectivityBanner extends StatefulWidget {
  /// Creates an [AppConnectivityBanner].
  const AppConnectivityBanner({
    required this.connectivityService,
    required this.child,
    this.message = 'No internet connection',
    super.key,
  });

  /// The service used to detect connectivity changes.
  final ConnectivityService connectivityService;

  /// The app content to wrap. The banner overlays above it, at the top
  /// of the screen, when offline.
  final Widget child;

  /// The text shown in the banner.
  final String message;

  @override
  State<AppConnectivityBanner> createState() => _AppConnectivityBannerState();
}

class _AppConnectivityBannerState extends State<AppConnectivityBanner> {
  StreamSubscription<bool>? _subscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    widget.connectivityService.isConnected.then((connected) {
      if (mounted) setState(() => _isOffline = !connected);
    });
    _subscription = widget.connectivityService.onConnectivityChanged.listen(
      (connected) {
        if (mounted) setState(() => _isOffline = !connected);
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: _isOffline ? 32 : 0,
          color: config.error,
          width: double.infinity,
          child: _isOffline
              ? Center(
                  child: Text(
                    widget.message,
                    style: TextStyle(color: config.onError, fontSize: 12),
                  ),
                )
              : null,
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
