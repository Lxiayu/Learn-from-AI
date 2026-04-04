const Object _chatStateUnset = Object();

enum ChatPromptStage {
  explain,
  example,
  compare,
  transfer;

  ChatPromptStage get next {
    switch (this) {
      case ChatPromptStage.explain:
        return ChatPromptStage.example;
      case ChatPromptStage.example:
        return ChatPromptStage.compare;
      case ChatPromptStage.compare:
        return ChatPromptStage.transfer;
      case ChatPromptStage.transfer:
        return ChatPromptStage.transfer;
    }
  }
}

enum ChatMessageRole {
  coach,
  learner,
  system,
}

class ChatTaskSummary {
  const ChatTaskSummary({
    required this.topic,
    required this.currentPrompt,
    required this.successSignal,
  });

  final String topic;
  final String currentPrompt;
  final String successSignal;
}

class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.content,
  });

  final ChatMessageRole role;
  final String content;
}

class ChatSessionState {
  const ChatSessionState({
    required this.task,
    required this.messages,
    required this.currentStage,
    required this.draft,
    required this.questionIndex,
    required this.totalQuestions,
    required this.isThinking,
    this.helperFeedbackTitle,
    this.helperFeedbackBody,
  });

  final ChatTaskSummary task;
  final List<ChatMessage> messages;
  final ChatPromptStage currentStage;
  final String draft;
  final int questionIndex;
  final int totalQuestions;
  final bool isThinking;
  final String? helperFeedbackTitle;
  final String? helperFeedbackBody;

  ChatSessionState copyWith({
    ChatTaskSummary? task,
    List<ChatMessage>? messages,
    ChatPromptStage? currentStage,
    String? draft,
    int? questionIndex,
    int? totalQuestions,
    bool? isThinking,
    Object? helperFeedbackTitle = _chatStateUnset,
    Object? helperFeedbackBody = _chatStateUnset,
  }) {
    return ChatSessionState(
      task: task ?? this.task,
      messages: messages ?? this.messages,
      currentStage: currentStage ?? this.currentStage,
      draft: draft ?? this.draft,
      questionIndex: questionIndex ?? this.questionIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isThinking: isThinking ?? this.isThinking,
      helperFeedbackTitle: identical(helperFeedbackTitle, _chatStateUnset)
          ? this.helperFeedbackTitle
          : helperFeedbackTitle as String?,
      helperFeedbackBody: identical(helperFeedbackBody, _chatStateUnset)
          ? this.helperFeedbackBody
          : helperFeedbackBody as String?,
    );
  }
}
