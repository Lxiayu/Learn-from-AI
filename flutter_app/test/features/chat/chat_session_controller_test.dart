import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/features/chat/application/chat_session_controller.dart';
import 'package:flutter_app/src/features/learning/data/learning_providers.dart';
import 'package:flutter_app/src/shared/models/chat_session_models.dart';

import '../../test_helpers/fake_learning_repository.dart';

void main() {
  test('chat controller advances from explain to example after submit', () async {
    final container = ProviderContainer(
      overrides: <Override>[
        learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
      ],
    );
    addTearDown(container.dispose);

    await container.read(chatSessionControllerProvider.future);
    final notifier = container.read(chatSessionControllerProvider.notifier);
    notifier.updateDraft('Justice is deeper than law.');
    await notifier.submitDraft();

    final state = container.read(chatSessionControllerProvider).requireValue;

    expect(state.currentStage, ChatPromptStage.example);
    expect(state.messages.last.role, ChatMessageRole.coach);
    expect(state.draft, isEmpty);
  });
}
