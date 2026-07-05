import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protfolio/main.dart';

void main() {
  testWidgets('Portfolio app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PortfolioApp());

    // Verify that we render key sections/titles.
    expect(find.byType(PortfolioApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
