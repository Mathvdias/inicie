import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/di/service_locator.dart';
import 'package:inicie/main.dart';

void main() {
  setUp(() {
    setupLocator();
  });

  testWidgets('MyApp builds correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const InicieApp());

    // Verify that our app has a title.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
