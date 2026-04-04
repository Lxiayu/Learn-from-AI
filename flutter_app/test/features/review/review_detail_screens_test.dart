import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/review/presentation/mastery_quiz_screen.dart';
import 'package:flutter_app/src/features/review/presentation/mistakes_mastered_celebration_screen.dart';
import 'package:flutter_app/src/features/review/presentation/quiz_results_summary_screen.dart';
import 'package:flutter_app/src/features/review/presentation/review_mistakes_detail_screen.dart';

void main() {
  testWidgets('mastery quiz renders the advanced physics prompt', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const MasteryQuizScreen(),
      ),
    );

    expect(find.text('Mastery Quiz'), findsOneWidget);
    expect(find.text('Question 07 of 12'), findsOneWidget);
    expect(find.text('Submit Answer'), findsOneWidget);
  });

  testWidgets('quiz results summary shows score and next actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const QuizResultsSummaryScreen(),
      ),
    );

    expect(find.text('Learning Progress'), findsOneWidget);
    expect(find.text('92%'), findsWidgets);
    expect(find.text('Continue Journey'), findsOneWidget);
  });

  testWidgets('review mistakes detail explains the wrong answer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const ReviewMistakesDetailScreen(),
      ),
    );

    expect(find.text('Review Mistakes'), findsOneWidget);
    expect(find.text('AI Coach Explanation'), findsOneWidget);
    expect(find.text('Got It, Next Mistake'), findsOneWidget);
  });

  testWidgets('mistakes mastered celebration shows mastered state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const MistakesMasteredCelebrationScreen(),
      ),
    );

    expect(find.text('Mistakes Mastered'), findsWidgets);
    expect(find.text('MASTERED'), findsOneWidget);
    expect(find.text('Continue Journey'), findsOneWidget);
  });
}
