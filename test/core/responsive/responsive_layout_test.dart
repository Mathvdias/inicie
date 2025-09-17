import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inicie/core/responsive/responsive_layout.dart';

void main() {
  group('ResponsiveLayout', () {
    testWidgets('shows mobileBody when width is less than 600', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayout(
            mobileBody: Container(key: const Key('mobile')),
            desktopBody: Container(key: const Key('desktop')),
          ),
        ),
      );

      tester.binding.window.physicalSizeTestValue = const Size(500, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('mobile')), findsOneWidget);
      expect(find.byKey(const Key('desktop')), findsNothing);

      tester.binding.window.clearAllTestValues();
    });

    testWidgets('shows tabletBody when width is between 600 and 1200', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayout(
            mobileBody: Container(key: const Key('mobile')),
            tabletBody: Container(key: const Key('tablet')),
            desktopBody: Container(key: const Key('desktop')),
          ),
        ),
      );

      tester.binding.window.physicalSizeTestValue = const Size(800, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('tablet')), findsOneWidget);
      expect(find.byKey(const Key('mobile')), findsNothing);
      expect(find.byKey(const Key('desktop')), findsNothing);

      tester.binding.window.clearAllTestValues();
    });

    testWidgets('shows desktopBody when width is 1200 or more', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayout(
            mobileBody: Container(key: const Key('mobile')),
            desktopBody: Container(key: const Key('desktop')),
          ),
        ),
      );

      tester.binding.window.physicalSizeTestValue = const Size(1300, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('desktop')), findsOneWidget);
      expect(find.byKey(const Key('mobile')), findsNothing);

      tester.binding.window.clearAllTestValues();
    });

    testWidgets(
      'shows desktopBody when tabletBody is null and width is between 600 and 1200',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ResponsiveLayout(
              mobileBody: Container(key: const Key('mobile')),
              desktopBody: Container(key: const Key('desktop')),
            ),
          ),
        );

        tester.binding.window.physicalSizeTestValue = const Size(800, 800);
        tester.binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('desktop')), findsOneWidget);
        expect(find.byKey(const Key('mobile')), findsNothing);

        tester.binding.window.clearAllTestValues();
      },
    );
  });
}