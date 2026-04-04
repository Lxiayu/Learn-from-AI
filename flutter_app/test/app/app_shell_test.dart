import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';
import 'package:flutter_app/src/features/navigation/presentation/app_bottom_nav.dart';

void main() {
  testWidgets('boots into Home with five bottom tabs', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('The Curator'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Roadmap'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Good Morning, Alex!'), findsOneWidget);
    expect(find.byType(AppBottomNav), findsOneWidget);
  });

  testWidgets('uses branded LearnAI theme tokens', (tester) async {
    await tester.pumpWidget(const MyApp());

    final MaterialApp app = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );
    final ThemeData theme = app.theme!;

    expect(theme.colorScheme.primary, const Color(0xFF24389C));
    expect(theme.scaffoldBackgroundColor, const Color(0xFFFBF9F9));
    expect(theme.textTheme.displayLarge?.fontSize, 48);
    expect(theme.textTheme.displayLarge?.fontWeight, FontWeight.w700);
    expect(
      theme.bottomNavigationBarTheme.selectedItemColor,
      const Color(0xFF24389C),
    );
  });

  testWidgets('can switch interface language to Chinese from settings', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('中文'));
    await tester.tap(find.text('中文'));
    await tester.pumpAndSettle();

    expect(find.text('学习策展人'), findsOneWidget);
    expect(find.text('首页'), findsWidgets);
    expect(find.text('个人看板'), findsOneWidget);
  });

  testWidgets('header actions show visible feedback instead of no-op', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Notifications will appear here soon.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Quick filters will live here soon.'), findsOneWidget);
  });
}
