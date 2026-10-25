import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pos_pro/main.dart';

void main() {
  testWidgets('launches splash screen and opens login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const POSRetailProApp());

    expect(find.text('POS Retail Pro'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to your account'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Quick Actions'), findsOneWidget);

    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();
    expect(find.text('Sales Trend'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Customers').first);
    await tester.pumpAndSettle();
    expect(find.text('+256 700 123 456'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Sale'));
    await tester.pumpAndSettle();
    expect(find.text('Complete Sale'), findsOneWidget);

    await tester.tap(find.text('Complete Sale'));
    await tester.pumpAndSettle();
    expect(find.text('Total Amount'), findsOneWidget);
  });
}
