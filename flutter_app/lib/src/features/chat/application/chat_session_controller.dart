import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/mock/mock_learning_data.dart';
import '../../../shared/models/chat_session_models.dart';

final StateNotifierProvider<ChatSessionController, ChatSessionState>
chatSessionControllerProvider =
    StateNotifierProvider<ChatSessionController, ChatSessionState>(
      (Ref ref) => ChatSessionController(),
    );

class ChatSessionController extends StateNotifier<ChatSessionState> {
  ChatSessionController() : super(mockChatSessionState);

  void updateDraft(String value) {
    state = state.copyWith(
      draft: value,
      helperFeedbackTitle: null,
      helperFeedbackBody: null,
    );
  }

  void submitDraft() {
    final String trimmed = state.draft.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(
        helperFeedbackTitle: 'Draft is empty',
        helperFeedbackBody: 'Write a short response before you continue.',
      );
      return;
    }

    final List<ChatMessage> nextMessages = <ChatMessage>[
      ...state.messages,
      ChatMessage(role: ChatMessageRole.learner, content: trimmed),
      _coachReplyFor(state.currentStage.next),
    ];

    state = state.copyWith(
      draft: '',
      currentStage: state.currentStage.next,
      questionIndex: state.questionIndex >= state.totalQuestions
          ? state.totalQuestions
          : state.questionIndex + 1,
      isThinking: false,
      messages: nextMessages,
      helperFeedbackTitle: 'Reflection captured',
      helperFeedbackBody: _feedbackFor(state.currentStage.next),
    );
  }

  void requestHint() {
    state = state.copyWith(
      helperFeedbackTitle: 'Hint unlocked',
      helperFeedbackBody:
          'Try defining the idea in one sentence before you add an example.',
    );
  }

  void requestAlternateExplanation() {
    state = state.copyWith(
      helperFeedbackTitle: 'Another angle',
      helperFeedbackBody:
          'Approach the concept by contrasting it with a nearby but different idea.',
    );
  }

  void markStillConfused() {
    state = state.copyWith(
      helperFeedbackTitle: 'We will slow down',
      helperFeedbackBody:
          'The next prompt should break the concept into a smaller, easier step.',
    );
  }

  ChatMessage _coachReplyFor(ChatPromptStage stage) {
    switch (stage) {
      case ChatPromptStage.explain:
        return const ChatMessage(
          role: ChatMessageRole.coach,
          content: 'Start by describing the core idea in your own words.',
        );
      case ChatPromptStage.example:
        return const ChatMessage(
          role: ChatMessageRole.coach,
          content:
              'Good start. Now ground your idea with a concrete example that someone else could recognize.',
        );
      case ChatPromptStage.compare:
        return const ChatMessage(
          role: ChatMessageRole.coach,
          content:
              'Nice. Compare it with a nearby concept so the boundary becomes clearer.',
        );
      case ChatPromptStage.transfer:
        return const ChatMessage(
          role: ChatMessageRole.coach,
          content:
              'Now transfer the idea into a harder case and test whether your definition still holds.',
        );
    }
  }

  String _feedbackFor(ChatPromptStage stage) {
    switch (stage) {
      case ChatPromptStage.explain:
        return 'Start from first principles and keep your answer short.';
      case ChatPromptStage.example:
        return 'You are ready to support your explanation with an example.';
      case ChatPromptStage.compare:
        return 'The next move is to sharpen the boundary by comparison.';
      case ChatPromptStage.transfer:
        return 'Now stretch the idea into a new context and see whether it still works.';
    }
  }
}
