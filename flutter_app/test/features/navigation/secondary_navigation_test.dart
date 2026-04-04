import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';
import 'package:flutter_app/src/app/router/app_router.dart';

void main() {
  testWidgets('chat secondary screens can be opened from the primary page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    appRouter.go('/home');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Focus Mode'));
    await tester.tap(find.text('Focus Mode'));
    await tester.pumpAndSettle();
    expect(find.text('Exit Focus'), findsOneWidget);
  });

  testWidgets('review secondary screens can be opened from the primary page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    appRouter.go('/home');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Open Quiz'));
    await tester.tap(find.text('Open Quiz'));
    await tester.pumpAndSettle();
    expect(find.text('Question 07 of 12'), findsOneWidget);
  });

  testWidgets('roadmap graph view can be opened from the primary page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    appRouter.go('/home');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Roadmap'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Open Graph View'));
    await tester.tap(find.text('Open Graph View'));
    await tester.pumpAndSettle();
    expect(find.text('Knowledge Graph View'), findsOneWidget);
  });

  testWidgets('profile insight report can be opened from the primary page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    appRouter.go('/home');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Weekly Cognitive Report'));
    await tester.tap(find.text('Weekly Cognitive Report'));
    await tester.pumpAndSettle();
    expect(find.text('Mastery Velocity'), findsOneWidget);
  });
}
