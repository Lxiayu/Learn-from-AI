import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/profile/presentation/achievements_gallery_screen.dart';
import 'package:flutter_app/src/features/profile/presentation/learning_insights_report_screen.dart';
import 'package:flutter_app/src/features/profile/presentation/new_achievement_notification_screen.dart';

void main() {
  testWidgets('learning insights report shows the weekly report cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const LearningInsightsReportScreen(),
      ),
    );

    expect(find.text('Weekly Cognitive Report'), findsWidgets);
    expect(find.text('Mastery Velocity'), findsOneWidget);
    expect(find.text('AI Coach Perspective'), findsOneWidget);
  });

  testWidgets('achievements gallery renders the achievement grid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const AchievementsGalleryScreen(),
      ),
    );

    expect(find.text('Your Achievements'), findsOneWidget);
    expect(find.text('Elite'), findsOneWidget);
    expect(find.text('Socratic Master'), findsOneWidget);
  });

  testWidgets('new achievement notification celebrates the unlock', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const NewAchievementNotificationScreen(),
      ),
    );

    expect(find.text('New Achievement Unlocked!'), findsOneWidget);
    expect(find.text('The Deep Diver'), findsOneWidget);
    expect(find.text('Share Achievement'), findsOneWidget);
  });
}
