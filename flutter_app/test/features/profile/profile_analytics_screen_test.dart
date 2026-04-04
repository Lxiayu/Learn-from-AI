import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/profile/presentation/profile_analytics_screen.dart';

void main() {
  testWidgets('Profile & Analytics shows stats, streak, and achievements entry',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const ProfileAnalyticsScreen(),
      ),
    );

    expect(find.text('Learning Insights'), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Current Streak'), findsOneWidget);
  });
}
