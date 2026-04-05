import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/app.dart';
import 'package:flutter_app/src/features/learning/data/learning_providers.dart';

import 'test_helpers/fake_learning_repository.dart';

void main() {
  testWidgets('app boots into Home', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
        ],
        child: const LearnAiApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Good Morning, Alex!'), findsOneWidget);
    expect(find.text('Today loop'), findsOneWidget);
  });
}
