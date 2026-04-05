import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/app.dart';
import 'package:flutter_app/src/app/router/app_router.dart';
import 'package:flutter_app/src/features/learning/data/learning_providers.dart';

import '../../test_helpers/fake_learning_repository.dart';

void main() {
  testWidgets('home primary actions open chat and review flows', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
        ],
        child: const LearnAiApp(),
      ),
    );
    appRouter.go('/home');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Continue current learning'));
    await tester.tap(find.text('Continue current learning'));
    await tester.pumpAndSettle();
    expect(find.text('Current task'), findsOneWidget);

    appRouter.go('/home');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Switch to review first'));
    await tester.tap(find.text('Switch to review first'));
    await tester.pumpAndSettle();
    expect(find.text('Due today'), findsOneWidget);
  });

  testWidgets('chat secondary screens can be opened from the primary page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
        ],
        child: const LearnAiApp(),
      ),
    );
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
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
        ],
        child: const LearnAiApp(),
      ),
    );
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
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
        ],
        child: const LearnAiApp(),
      ),
    );
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
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
        ],
        child: const LearnAiApp(),
      ),
    );
    appRouter.go('/home');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Weekly Cognitive Report'));
    await tester.tap(find.text('Weekly Cognitive Report'));
    await tester.pumpAndSettle();
    expect(find.text('Mastery Velocity'), findsOneWidget);
  });

  testWidgets('language change persists when navigating back to home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
        ],
        child: const LearnAiApp(),
      ),
    );
    appRouter.go('/profile');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('中文'));
    await tester.tap(find.text('中文'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('首页'));
    await tester.pumpAndSettle();

    expect(find.text('今日任务台'), findsOneWidget);
    expect(find.text('主线后再探索'), findsOneWidget);
  });
}
