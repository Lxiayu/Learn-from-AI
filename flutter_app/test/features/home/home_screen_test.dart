import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('Home shows the main dashboard entry points', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const HomeScreen(),
      ),
    );

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Continue Learning'), findsOneWidget);
    expect(find.text('Today Review'), findsOneWidget);
    expect(find.text('Current Roadmap'), findsOneWidget);
    expect(find.text('Learning Insights'), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
  });
}
