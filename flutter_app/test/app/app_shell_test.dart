import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('boots into Home with five bottom tabs', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Roadmap'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Socratic Chat'), findsOneWidget);
    expect(find.text('Profile & Analytics'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('uses branded LearnAI theme tokens', (tester) async {
    await tester.pumpWidget(const MyApp());

    final MaterialApp app = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );
    final ThemeData theme = app.theme!;

    expect(theme.colorScheme.primary, const Color(0xFF24389C));
    expect(theme.scaffoldBackgroundColor, const Color(0xFFFBF9F9));
    expect(theme.textTheme.displayLarge?.fontSize, 56);
    expect(theme.textTheme.displayLarge?.fontWeight, FontWeight.w700);
    expect(
      theme.bottomNavigationBarTheme.selectedItemColor,
      const Color(0xFF24389C),
    );
  });
}
