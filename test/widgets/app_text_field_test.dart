import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'AppTextField surfaces the validator error text via the Form',
    (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppTextField(
                label: 'Email',
                validator: Validators.compose([
                  Validators.required(),
                  Validators.email(),
                ]),
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('This field is required.'), findsOneWidget);
    },
  );
}
