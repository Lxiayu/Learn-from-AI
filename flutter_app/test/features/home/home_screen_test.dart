import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('Home shows learning task and review task cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const HomeScreen(),
      ),
    );

    expect(find.text('Continue Learning'), findsOneWidget);
    expect(find.text('Today Review'), findsOneWidget);
  });
}
