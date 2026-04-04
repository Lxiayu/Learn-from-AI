import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/features/chat/application/chat_session_controller.dart';
import 'package:flutter_app/src/shared/models/chat_session_models.dart';

void main() {
  test('chat controller advances from explain to example after submit', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(chatSessionControllerProvider.notifier);
    notifier.updateDraft('Justice is deeper than law.');
    notifier.submitDraft();

    final state = container.read(chatSessionControllerProvider);

    expect(state.currentStage, ChatPromptStage.example);
    expect(state.messages.last.role, ChatMessageRole.coach);
    expect(state.draft, isEmpty);
  });
}
