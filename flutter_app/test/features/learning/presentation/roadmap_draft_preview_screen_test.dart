import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/app.dart';
import 'package:flutter_app/src/app/router/app_router.dart';
import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/learning/data/learning_providers.dart';
import 'package:flutter_app/src/features/learning/domain/learning_goal_setup_models.dart';
import 'package:flutter_app/src/features/learning/presentation/roadmap_draft_preview_screen.dart';

import '../../../test_helpers/fake_learning_repository.dart';

void main() {
  testWidgets('roadmap draft preview shows stages and confirm action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildAppTheme(),
          home: RoadmapDraftPreviewScreen(
            draft: const LearningRoadmapDraft(
              roadmapId: 'roadmap-1',
              title: 'Linear Algebra',
              summary: 'A focused path from vectors to matrices.',
              estimatedDurationMinutes: 360,
              stages: <LearningRoadmapDraftStage>[
                LearningRoadmapDraftStage(
                  orderIndex: 1,
                  title: 'Core concepts',
                  objective: 'Understand vectors and spans.',
                  completionCriteria: 'Explain vectors with one concrete example.',
                  status: 'available',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Linear Algebra'), findsOneWidget);
    expect(find.text('Core concepts'), findsOneWidget);
    expect(find.text('Confirm and start learning'), findsOneWidget);
  });

  testWidgets('confirming a roadmap opens the chat workspace', (
    WidgetTester tester,
  ) async {
    final fakeRepository = FakeLearningRepository();
    const draft = LearningRoadmapDraft(
      roadmapId: 'roadmap-1',
      title: 'Linear Algebra',
      summary: 'A focused path from vectors to matrices.',
      estimatedDurationMinutes: 360,
      stages: <LearningRoadmapDraftStage>[
        LearningRoadmapDraftStage(
          orderIndex: 1,
          title: 'Core concepts',
          objective: 'Understand vectors and spans.',
          completionCriteria: 'Explain vectors with one concrete example.',
          status: 'available',
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: const LearnAiApp(),
      ),
    );

    appRouter.go('/learning-goal/preview', extra: draft);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Confirm and start learning'));
    await tester.pumpAndSettle();

    expect(fakeRepository.confirmedRoadmapId, 'roadmap-1');
    expect(find.text('Current task'), findsOneWidget);
  });
}
