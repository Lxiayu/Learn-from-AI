import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/home/presentation/home_screen.dart';
import 'package:flutter_app/src/features/learning/data/learning_providers.dart';

import '../../test_helpers/fake_learning_repository.dart';

void main() {
  testWidgets('Home behaves like a task-first learning console', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
        ],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Continue current learning'), findsOneWidget);
    expect(find.textContaining('You paused at'), findsOneWidget);
    expect(find.text('Today loop'), findsOneWidget);
    expect(find.text('Explore after the main path'), findsOneWidget);
  });
}
