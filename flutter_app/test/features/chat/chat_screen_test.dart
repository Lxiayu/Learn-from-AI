import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/chat/presentation/chat_screen.dart';
import 'package:flutter_app/src/features/learning/data/learning_providers.dart';

import '../../test_helpers/fake_learning_repository.dart';

void main() {
  testWidgets('Chat behaves like a stateful learning workspace', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
        ],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const ChatScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Current task'), findsOneWidget);
    expect(find.text('Explain'), findsOneWidget);
    expect(find.text('Give me a hint'), findsOneWidget);
    expect(find.text('Teach it another way'), findsOneWidget);
    expect(find.text('I still do not get it'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Justice requires fairness.');
    await tester.ensureVisible(find.text('Send Reflection'));
    await tester.tap(find.text('Send Reflection'));
    await tester.pumpAndSettle();

    expect(find.text('Reflection captured'), findsOneWidget);
  });
}
