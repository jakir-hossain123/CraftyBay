import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crafty_bay/presentation/features/auth/login/view/login_page.dart';

void main() {
  testWidgets('valid login navigates to OTP verification', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Enter OTP Code'), findsOneWidget);
  });
}
