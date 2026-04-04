import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/profile/presentation/profile_analytics_screen.dart';

void main() {
  testWidgets('Profile behaves like a learning control center',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const ProfileAnalyticsScreen(),
        ),
      ),
    );

    expect(find.text('Personal Dashboard'), findsOneWidget);
    expect(find.text('Reminder time'), findsOneWidget);
    expect(find.text('Sync status'), findsOneWidget);
    expect(find.text('Daily study target'), findsOneWidget);
    expect(find.text('Achievement momentum'), findsOneWidget);
    expect(find.text('Weekly Cognitive Report'), findsOneWidget);
    expect(find.text('Achievements Gallery'), findsOneWidget);
  });
}
