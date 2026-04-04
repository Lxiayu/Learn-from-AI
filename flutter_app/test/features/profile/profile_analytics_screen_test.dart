import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/profile/presentation/profile_analytics_screen.dart';

void main() {
  testWidgets('Profile matches the stitched analytics layout',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const ProfileAnalyticsScreen(),
      ),
    );

    expect(find.text('Personal Dashboard'), findsOneWidget);
    expect(find.text('Alex Harrison'), findsOneWidget);
    expect(find.text('24 Days'), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Account Settings'), findsOneWidget);
  });
}
