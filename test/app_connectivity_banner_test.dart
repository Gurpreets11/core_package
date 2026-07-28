import 'dart:async';

import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeConnectivityService implements ConnectivityService {
  _FakeConnectivityService({required bool initiallyConnected})
      : _connected = initiallyConnected;

  bool _connected;
  final _controller = StreamController<bool>.broadcast();

  void setConnected(bool connected) {
    _connected = connected;
    _controller.add(connected);
  }

  void dispose() => _controller.close();

  @override
  Future<bool> get isConnected async => _connected;

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;
}

void main() {
  group('AppConnectivityBanner', () {
    testWidgets('shows no banner when initially connected', (tester) async {
      final service = _FakeConnectivityService(initiallyConnected: true);
      addTearDown(service.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: AppConnectivityBanner(
            connectivityService: service,
            child: const Text('content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No internet connection'), findsNothing);
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('shows the banner when initially offline', (tester) async {
      final service = _FakeConnectivityService(initiallyConnected: false);
      addTearDown(service.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: AppConnectivityBanner(
            connectivityService: service,
            child: const Text('content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No internet connection'), findsOneWidget);
    });

    testWidgets('shows/hides the banner as connectivity changes', (
      tester,
    ) async {
      final service = _FakeConnectivityService(initiallyConnected: true);
      addTearDown(service.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: AppConnectivityBanner(
            connectivityService: service,
            child: const Text('content'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No internet connection'), findsNothing);

      service.setConnected(false);
      await tester.pumpAndSettle();
      expect(find.text('No internet connection'), findsOneWidget);

      service.setConnected(true);
      await tester.pumpAndSettle();
      expect(find.text('No internet connection'), findsNothing);
    });
  });
}
