import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../learning/data/learning_providers.dart';
import '../../../shared/models/chat_session_models.dart';

final AsyncNotifierProvider<ChatSessionController, ChatSessionState>
chatSessionControllerProvider =
    AsyncNotifierProvider<ChatSessionController, ChatSessionState>(
      ChatSessionController.new,
    );

class ChatSessionController extends AsyncNotifier<ChatSessionState> {
  String? _sessionId;

  @override
  Future<ChatSessionState> build() async {
    final loaded = await ref.watch(learningRepositoryProvider).loadChatSession();
    _sessionId = loaded.sessionId;
    return loaded.state;
  }

  void updateDraft(String value) {
    final ChatSessionState? currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      currentState.copyWith(
        draft: value,
        helperFeedbackTitle: null,
        helperFeedbackBody: null,
      ),
    );
  }

  Future<void> submitDraft() async {
    final ChatSessionState? currentState = state.valueOrNull;
    final String? sessionId = _sessionId;
    if (currentState == null || sessionId == null) {
      return;
    }

    final nextState = await ref
        .read(learningRepositoryProvider)
        .submitChatAnswer(
          sessionId: sessionId,
          currentState: currentState,
          answer: currentState.draft,
        );
    state = AsyncData(nextState);
  }

  Future<void> requestHint() async {
    final ChatSessionState? currentState = state.valueOrNull;
    final String? sessionId = _sessionId;
    if (currentState == null || sessionId == null) {
      return;
    }

    state = AsyncData(
      await ref
          .read(learningRepositoryProvider)
          .requestHint(sessionId: sessionId, currentState: currentState),
    );
  }

  Future<void> requestAlternateExplanation() async {
    final ChatSessionState? currentState = state.valueOrNull;
    final String? sessionId = _sessionId;
    if (currentState == null || sessionId == null) {
      return;
    }

    state = AsyncData(
      await ref.read(learningRepositoryProvider).requestAlternateExplanation(
            sessionId: sessionId,
            currentState: currentState,
          ),
    );
  }

  void markStillConfused() {
    final ChatSessionState? currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      ref.read(learningRepositoryProvider).markStillConfused(currentState),
    );
  }

  Future<int> completeSession() async {
    final String? sessionId = _sessionId;
    if (sessionId == null) {
      return 0;
    }

    return ref
        .read(learningRepositoryProvider)
        .completeLearningSession(sessionId: sessionId);
  }
}
