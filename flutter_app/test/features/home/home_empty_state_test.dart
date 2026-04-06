import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/home/presentation/home_screen.dart';
import 'package:flutter_app/src/features/learning/data/learning_providers.dart';
import 'package:flutter_app/src/features/learning/data/learning_repository.dart';
import 'package:flutter_app/src/shared/models/home_dashboard_models.dart';

import '../../test_helpers/noop_learning_api.dart';

void main() {
  testWidgets('home shows learning-plan empty state when no roadmap exists', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(
            _MissingPlanRepository(),
          ),
        ],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create your learning plan'), findsOneWidget);
    expect(find.text('Start with a goal'), findsOneWidget);
  });
}

class _MissingPlanRepository extends LearningRepository {
  _MissingPlanRepository() : super(api: NoopLearningApi());

  @override
  Future<HomeDashboardState> loadHomeDashboard() async {
    throw const MissingLearningPlanException();
  }
}
