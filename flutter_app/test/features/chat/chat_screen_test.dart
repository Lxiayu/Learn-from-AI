import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/app.dart';
import 'package:flutter_app/src/app/router/app_router.dart';
import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/learning/data/learning_providers.dart';
import 'package:flutter_app/src/features/learning/domain/loaded_chat_session.dart';
import 'package:flutter_app/src/features/chat/presentation/chat_screen.dart';
import 'package:flutter_app/src/shared/mock/mock_learning_data.dart';
import 'package:flutter_app/src/shared/models/chat_session_models.dart';

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

  testWidgets('Chat can complete a transfer-stage session and open review', (
    WidgetTester tester,
  ) async {
    final fakeRepository = FakeLearningRepository(
      loadedChatSession: LoadedChatSession(
        sessionId: 'session-transfer',
        state: mockChatSessionState.copyWith(
          sessionId: 'session-transfer',
          currentStage: ChatPromptStage.transfer,
          questionIndex: 4,
          totalQuestions: 4,
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          learningRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: const LearnAiApp(),
      ),
    );
    appRouter.go('/chat');
    await tester.pumpAndSettle();

    expect(find.text('Complete this session'), findsOneWidget);

    await tester.ensureVisible(find.text('Complete this session'));
    await tester.tap(find.text('Complete this session'));
    await tester.pumpAndSettle();

    expect(fakeRepository.completedSessionId, 'session-transfer');
    expect(find.text('Due today'), findsOneWidget);
    expect(find.text('Session wrapped up'), findsOneWidget);
  });
}
