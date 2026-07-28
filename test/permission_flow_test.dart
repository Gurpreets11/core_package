import 'dart:async';

import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPermissionService extends Mock implements PermissionService {}

void main() {
  setUpAll(() {
    registerFallbackValue(AppPermission.camera);
  });

  late _MockPermissionService service;
  late BuildContext capturedContext;

  setUp(() async {
    service = _MockPermissionService();
  });

  Future<void> pumpHost(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  group('PermissionFlow.ensureGranted', () {
    testWidgets('returns true immediately if already granted', (
      tester,
    ) async {
      await pumpHost(tester);
      when(
        () => service.check(AppPermission.camera),
      ).thenAnswer((_) async => AppPermissionStatus.granted);

      final result = await PermissionFlow.ensureGranted(
        capturedContext,
        service: service,
        permission: AppPermission.camera,
        rationaleTitle: 'Camera needed',
        rationaleMessage: 'To take a photo.',
      );

      expect(result, isTrue);
      verifyNever(() => service.request(any()));
    });

    testWidgets(
      'shows a rationale dialog and requests when denied, confirmed',
      (tester) async {
        await pumpHost(tester);
        when(
          () => service.check(AppPermission.camera),
        ).thenAnswer((_) async => AppPermissionStatus.denied);
        when(
          () => service.request(AppPermission.camera),
        ).thenAnswer((_) async => AppPermissionStatus.granted);

        bool? result;
        unawaited(
          PermissionFlow.ensureGranted(
            capturedContext,
            service: service,
            permission: AppPermission.camera,
            rationaleTitle: 'Camera needed',
            rationaleMessage: 'To take a photo.',
          ).then((value) => result = value),
        );
        await tester.pumpAndSettle();

        expect(find.text('Camera needed'), findsOneWidget);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        verify(() => service.request(AppPermission.camera)).called(1);
        expect(result, isTrue);
      },
    );

    testWidgets(
      'offers to open Settings when permanently denied, without requesting',
      (tester) async {
        await pumpHost(tester);
        when(
          () => service.check(AppPermission.location),
        ).thenAnswer((_) async => AppPermissionStatus.permanentlyDenied);
        when(() => service.openAppSettings()).thenAnswer((_) async => true);

        bool? result;
        unawaited(
          PermissionFlow.ensureGranted(
            capturedContext,
            service: service,
            permission: AppPermission.location,
            rationaleTitle: 'Location needed',
            rationaleMessage: 'To check in.',
          ).then((value) => result = value),
        );
        await tester.pumpAndSettle();

        expect(find.text('Permission required'), findsOneWidget);
        await tester.tap(find.text('Open Settings'));
        await tester.pumpAndSettle();

        verify(() => service.openAppSettings()).called(1);
        verifyNever(() => service.request(any()));
        expect(result, isFalse);
      },
    );
  });
}
