import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('Home matches the stitched dashboard structure', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const HomeScreen(),
      ),
    );

    expect(find.text('Good Morning, Alex!'), findsOneWidget);
    expect(find.text('Current Focus'), findsOneWidget);
    expect(find.text('Quantum Physics Fundamentals'), findsOneWidget);
    expect(find.text('Upcoming Reviews'), findsOneWidget);
    expect(find.text('Daily Learning Goal'), findsOneWidget);
    expect(find.textContaining('Curator'), findsWidgets);
  });
}
