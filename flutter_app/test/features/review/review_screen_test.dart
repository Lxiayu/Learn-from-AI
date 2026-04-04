import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/review/presentation/review_screen.dart';

void main() {
  testWidgets('Review shows schedule, weak points, and quiz entry', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const ReviewScreen(),
      ),
    );

    expect(find.text('Review Schedule'), findsOneWidget);
    expect(find.text('Weak Points'), findsOneWidget);
    expect(find.text('Mastery Quiz'), findsOneWidget);
  });
}
