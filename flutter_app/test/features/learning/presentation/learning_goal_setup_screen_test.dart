import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/learning/presentation/learning_goal_setup_screen.dart';

void main() {
  testWidgets('learning goal setup screen collects goal inputs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const LearningGoalSetupScreen(),
        ),
      ),
    );

    expect(find.text('What do you want to learn?'), findsOneWidget);
    expect(find.text('Target outcome'), findsOneWidget);
    expect(find.text('Generate roadmap'), findsOneWidget);
  });
}
