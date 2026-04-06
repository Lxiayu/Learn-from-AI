import 'package:flutter_app/src/features/learning/data/learning_repository.dart';
import 'package:flutter_app/src/features/learning/domain/loaded_chat_session.dart';
import 'package:flutter_app/src/features/learning/domain/learning_goal_setup_models.dart';
import 'package:flutter_app/src/shared/mock/mock_learning_data.dart';
import 'package:flutter_app/src/shared/models/chat_session_models.dart';
import 'package:flutter_app/src/shared/models/home_dashboard_models.dart';
import 'package:flutter_app/src/shared/models/review_models.dart';
import 'package:flutter_app/src/shared/models/roadmap_models.dart';

import 'noop_learning_api.dart';

class FakeLearningRepository extends LearningRepository {
  FakeLearningRepository({
    this.homeDashboardState = mockHomeDashboardState,
    this.roadmapProgressState = mockRoadmapProgressState,
    ReviewQueueState reviewQueueState = mockReviewQueueState,
    this.roadmapDraft = const LearningRoadmapDraft(
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
    LoadedChatSession? loadedChatSession,
  }) : loadedChatSession = loadedChatSession ??
            const LoadedChatSession(
              sessionId: 'session-1',
              state: mockChatSessionState,
            ),
       _reviewQueueState = reviewQueueState,
       super(api: NoopLearningApi());

  final HomeDashboardState homeDashboardState;
  final RoadmapProgressState roadmapProgressState;
  ReviewQueueState _reviewQueueState;
  final LearningRoadmapDraft roadmapDraft;
  final LoadedChatSession loadedChatSession;
  String? confirmedRoadmapId;
  String? completedSessionId;

  @override
  Future<HomeDashboardState> loadHomeDashboard() async => homeDashboardState;

  @override
  Future<LearningRoadmapDraft> createRoadmapDraft(
    LearningGoalSetupInput input,
  ) async => roadmapDraft;

  @override
  Future<void> confirmRoadmapDraft(String roadmapId) async {
    confirmedRoadmapId = roadmapId;
  }

  @override
  Future<RoadmapProgressState> loadRoadmapProgress() async =>
      roadmapProgressState;

  @override
  Future<LoadedChatSession> loadChatSession() async => loadedChatSession;

  @override
  Future<ChatSessionState> submitChatAnswer({
    required String sessionId,
    required ChatSessionState currentState,
    required String answer,
  }) async {
    if (answer.trim().isEmpty) {
      return currentState.copyWith(
        helperFeedbackTitle: 'Draft is empty',
        helperFeedbackBody: 'Write a short response before you continue.',
      );
    }

    return currentState.copyWith(
      currentStage: ChatPromptStage.example,
      draft: '',
      questionIndex: 2,
      messages: <ChatMessage>[
        ...currentState.messages,
        ChatMessage(role: ChatMessageRole.learner, content: answer.trim()),
        const ChatMessage(
          role: ChatMessageRole.coach,
          content: 'Give me one concrete example next.',
        ),
      ],
      helperFeedbackTitle: 'Reflection captured',
      helperFeedbackBody: 'Strong answer. Let us deepen it with an example.',
    );
  }

  @override
  Future<ChatSessionState> requestHint({
    required String sessionId,
    required ChatSessionState currentState,
  }) async {
    return currentState.copyWith(
      helperFeedbackTitle: 'Hint unlocked',
      helperFeedbackBody: 'Start from the most important trait first.',
    );
  }

  @override
  Future<ChatSessionState> requestAlternateExplanation({
    required String sessionId,
    required ChatSessionState currentState,
  }) async {
    return currentState.copyWith(
      helperFeedbackTitle: 'Another angle',
      helperFeedbackBody: 'Try contrasting the idea with a nearby concept.',
    );
  }

  @override
  ChatSessionState markStillConfused(ChatSessionState currentState) {
    return currentState.copyWith(
      helperFeedbackTitle: 'We will slow down',
      helperFeedbackBody:
          'The next prompt should break the concept into a smaller, easier step.',
    );
  }

  @override
  Future<int> completeLearningSession({
    required String sessionId,
  }) async {
    completedSessionId = sessionId;
    _reviewQueueState = _reviewQueueState.copyWith(
      dueToday: <ReviewQueueItem>[
        const ReviewQueueItem(
          id: 'generated-review-1',
          title: 'Transfer the idea once more',
          detail: 'Use the just-finished concept in one fresh scenario.',
          reason: 'Generated from the session you just wrapped up.',
          dueLabel: 'Due now',
          route: '/review/quiz',
        ),
        const ReviewQueueItem(
          id: 'generated-review-2',
          title: 'Explain the concept from memory',
          detail: 'Restate the core idea and add one concrete example.',
          reason: 'Generated from the session you just wrapped up.',
          dueLabel: 'Today',
          route: '/review/mistakes',
        ),
        ..._reviewQueueState.dueToday,
      ],
    );
    return 2;
  }

  @override
  Future<ReviewQueueState> loadReviewQueue() async => _reviewQueueState;

  @override
  Future<ReviewQueueState> completeReview({
    required ReviewQueueState currentState,
    required String reviewTaskId,
  }) async {
    final ReviewQueueItem? item = currentState.dueToday.cast<ReviewQueueItem?>()
        .firstWhere(
          (ReviewQueueItem? reviewItem) => reviewItem?.id == reviewTaskId,
          orElse: () => null,
        );
    if (item == null) {
      return currentState;
    }

    return currentState.copyWith(
      dueToday: currentState.dueToday
          .where((ReviewQueueItem reviewItem) => reviewItem.id != reviewTaskId)
          .toList(),
      completedToday: <ReviewQueueItem>[item, ...currentState.completedToday],
    );
  }
}
