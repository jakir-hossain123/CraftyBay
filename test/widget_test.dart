import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:crafty_bay/presentation/features/auth/login/view/login_page.dart';
import 'package:crafty_bay/presentation/features/auth/viewmodel/auth_provider.dart';

void main() {
  testWidgets('login form validates required fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: const MaterialApp(home: LoginPage()),
      ),
    );
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
  });
}
