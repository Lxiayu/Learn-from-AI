import '../../../core/network/api_client.dart';
import '../../../shared/models/chat_session_models.dart';
import '../../../shared/models/home_dashboard_models.dart';
import '../../../shared/models/review_models.dart';
import '../../../shared/models/roadmap_models.dart';
import '../domain/loaded_chat_session.dart';
import '../domain/learning_goal_setup_models.dart';
import 'learning_api.dart';

class MissingLearningPlanException implements Exception {
  const MissingLearningPlanException();

  @override
  String toString() => 'MissingLearningPlanException';
}

class LearningRepository {
  LearningRepository({required this.api});

  final LearningApi api;

  Future<HomeDashboardState> loadHomeDashboard() async {
    final roadmap = await _requireCurrentRoadmap();
    final session = await _requireCurrentSession();
    final reviews = await api.getTodayReviews();
    final milestones = _milestonesFromRoadmap(roadmap);
    final activeMilestone = milestones.firstWhere(
      (RoadmapMilestone milestone) => milestone.isActive,
      orElse: () => milestones.first,
    );
    final int reviewCount = _reviewItems(reviews).length;
    final String phase = session['phase'] as String? ?? 'explain';
    final String pausedCheckpoint =
        'You paused at: ${activeMilestone.title} -> ${_phaseLabel(phase)}';

    return HomeDashboardState(
      heroLabel: 'Today',
      greeting: 'Good Morning, Alex!',
      summary:
          'Return to your main inquiry, close one spaced review, and finish with a short reflection.',
      primaryActionLabel: 'Continue current learning',
      pausedCheckpoint: pausedCheckpoint,
      alternateReviewLabel: 'Switch to review first',
      learningTask: HomeTaskCard(
        title: _journeyTitle(roadmap['title'] as String? ?? 'Learning Roadmap'),
        description:
            _taskCard(session)['objective'] as String? ??
            'Continue the active inquiry and strengthen the next boundary.',
        badgeLabel: 'Stage ${roadmap['current_stage_index']} • ${_phaseLabel(phase)}',
        ctaLabel: 'Enter inquiry',
        route: '/chat',
      ),
      reviewTask: HomeTaskCard(
        title: 'Review due today',
        description: reviewCount == 0
            ? 'Nothing urgent is fading right now, so you can stay on the main path.'
            : 'Two concepts are ready for recall because they are starting to fade.',
        badgeLabel: '$reviewCount due today',
        ctaLabel: 'Open review',
        route: '/review',
      ),
      todayLoop: <HomeLoopStep>[
        HomeLoopStep(label: 'Main inquiry', isComplete: phase == 'transfer'),
        HomeLoopStep(label: 'Spaced review', isComplete: reviewCount == 0),
        const HomeLoopStep(label: 'Session wrap-up', isComplete: false),
      ],
      exploration: const HomeExplorationSuggestion(
        title: 'Copenhagen interpretation',
        description:
            'Explore a branch that deepens the uncertainty discussion without replacing the main path.',
        relatedReason:
            'Best opened after today’s main path because it depends on a clear distinction between measurement and interpretation.',
        ctaLabel: 'Save for after the main path',
      ),
      quickLinks: <HomeQuickLink>[
        HomeQuickLink(
          title: 'Current roadmap',
          description: 'Check the active stage and the next unlock condition.',
          badgeLabel: '${milestones.length} stages',
          route: '/roadmap',
        ),
        const HomeQuickLink(
          title: 'Learning insights',
          description: 'See your weekly rhythm, streak, and explanation quality.',
          badgeLabel: 'Local MVP',
          route: '/profile',
        ),
        const HomeQuickLink(
          title: 'Achievements',
          description: 'Review the milestones you unlocked and what is next.',
          badgeLabel: '1 new',
          route: '/profile',
        ),
      ],
    );
  }

  Future<RoadmapProgressState> loadRoadmapProgress() async {
    final roadmap = await _requireCurrentRoadmap();

    final milestones = _milestonesFromRoadmap(roadmap);
    final activeMilestone = milestones.firstWhere(
      (RoadmapMilestone milestone) => milestone.isActive,
      orElse: () => milestones.first,
    );

    return RoadmapProgressState(
      journeyTitle: _journeyTitle(roadmap['title'] as String? ?? 'Learning Roadmap'),
      currentGoal: activeMilestone.detail,
      whyThisIsNext: roadmap['summary'] as String? ??
          'This sequence keeps the main path stable before branching further.',
      continueRoute: '/chat',
      milestones: milestones,
      savedBranches: const <SavedBranch>[
        SavedBranch(
          title: 'Copenhagen interpretation',
          reason:
              'Saved for later because it extends the current uncertainty discussion.',
        ),
        SavedBranch(
          title: 'Many-worlds view',
          reason:
              'Saved for later because it is useful after the measurement unit.',
        ),
      ],
    );
  }

  Future<LoadedChatSession> loadChatSession() async {
    final session = await _requireCurrentSession();
    final taskCard = _taskCard(session);
    final ChatPromptStage stage = _stageFromWire(session['phase'] as String?);
    final currentPrompt =
        taskCard['question_focus'] as String? ??
        'Explain the concept in your own words before you add an example.';

    return LoadedChatSession(
      sessionId: session['id'] as String,
      state: ChatSessionState(
        sessionId: session['id'] as String,
        task: ChatTaskSummary(
          topic: taskCard['topic'] as String? ?? 'Foundation Systems',
          currentPrompt: currentPrompt,
          successSignal: taskCard['success_criteria'] as String? ??
              'Explain the idea clearly with one example.',
        ),
        messages: <ChatMessage>[
          ChatMessage(
            role: ChatMessageRole.coach,
            content: _coachReplyFor(stage, currentPrompt: currentPrompt),
          ),
        ],
        currentStage: stage,
        draft: '',
        questionIndex: ChatPromptStage.values.indexOf(stage) + 1,
        totalQuestions: ChatPromptStage.values.length,
        isThinking: false,
      ),
    );
  }

  Future<ChatSessionState> submitChatAnswer({
    required String sessionId,
    required ChatSessionState currentState,
    required String answer,
  }) async {
    final String trimmed = answer.trim();
    if (trimmed.isEmpty) {
      return currentState.copyWith(
        helperFeedbackTitle: 'Draft is empty',
        helperFeedbackBody: 'Write a short response before you continue.',
      );
    }

    final response = await api.answerSession(sessionId, answer: trimmed);
    final feedback = response['feedback'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final ChatPromptStage nextStage = _stageFromWire(
      response['next_step'] as String?,
    );
    final bool didAdvance = nextStage != currentState.currentStage;
    final int nextQuestionIndex = didAdvance
        ? ChatPromptStage.values.indexOf(nextStage) + 1
        : currentState.questionIndex;

    return currentState.copyWith(
      draft: '',
      currentStage: nextStage,
      questionIndex: nextQuestionIndex,
      isThinking: false,
      messages: <ChatMessage>[
        ...currentState.messages,
        ChatMessage(role: ChatMessageRole.learner, content: trimmed),
        ChatMessage(
          role: ChatMessageRole.coach,
          content: _coachReplyFor(
            nextStage,
            currentPrompt: currentState.task.currentPrompt,
          ),
        ),
      ],
      helperFeedbackTitle: 'Reflection captured',
      helperFeedbackBody: feedback['message'] as String? ??
          'The coach reviewed your answer and prepared the next step.',
    );
  }

  Future<ChatSessionState> requestHint({
    required String sessionId,
    required ChatSessionState currentState,
  }) async {
    final response = await api.getHint(sessionId);
    return currentState.copyWith(
      helperFeedbackTitle: 'Hint unlocked',
      helperFeedbackBody:
          response['hint'] as String? ??
          'Start from the most important trait before the details.',
    );
  }

  Future<ChatSessionState> requestAlternateExplanation({
    required String sessionId,
    required ChatSessionState currentState,
  }) async {
    final response = await api.explainAgain(sessionId);
    return currentState.copyWith(
      helperFeedbackTitle: 'Another angle',
      helperFeedbackBody:
          response['explanation'] as String? ??
          'Try contrasting the idea with a nearby concept.',
    );
  }

  ChatSessionState markStillConfused(ChatSessionState currentState) {
    return currentState.copyWith(
      helperFeedbackTitle: 'We will slow down',
      helperFeedbackBody:
          'The next prompt should break the concept into a smaller, easier step.',
    );
  }

  Future<ReviewQueueState> loadReviewQueue() async {
    await _requireCurrentRoadmap();
    final response = await api.getTodayReviews();
    final items = _reviewItems(response);
    return ReviewQueueState(
      dueToday: items.asMap().entries.map((entry) {
        final int index = entry.key;
        final Map<String, dynamic> item = entry.value;
        return ReviewQueueItem(
          id: item['id'] as String,
          title: _reviewTitle(item['prompt'] as String, index),
          detail: item['prompt'] as String,
          reason: 'Review now because this idea is entering its ideal recall window.',
          dueLabel: _dueLabel(item['due_at'] as String?),
          route: index.isEven ? '/review/mistakes' : '/review/quiz',
        );
      }).toList(),
      upNext: const <ReviewQueueItem>[],
      completedToday: const <ReviewQueueItem>[],
    );
  }

  Future<LearningRoadmapDraft> createRoadmapDraft(
    LearningGoalSetupInput input,
  ) async {
    final goal = await api.createLearningGoal(
      topic: input.topic,
      targetOutcome: input.targetOutcome,
      currentLevel: input.currentLevel.wireValue,
      studyPace: input.studyPace.wireValue,
      evaluationPreference: input.evaluationPreference,
    );
    final roadmap = await api.generateRoadmap(
      learningGoalId: goal['id'] as String,
    );
    return _roadmapDraftFromWire(roadmap);
  }

  Future<void> confirmRoadmapDraft(String roadmapId) async {
    await api.confirmRoadmap(roadmapId);
  }

  Future<ReviewQueueState> completeReview({
    required ReviewQueueState currentState,
    required String reviewTaskId,
  }) async {
    await api.completeReview(reviewTaskId, result: 'completed');

    ReviewQueueItem? completedItem;
    for (final item in currentState.dueToday) {
      if (item.id == reviewTaskId) {
        completedItem = item;
        break;
      }
    }
    completedItem ??= currentState.upNext.cast<ReviewQueueItem?>().firstWhere(
      (ReviewQueueItem? item) => item?.id == reviewTaskId,
      orElse: () => null,
    );

    if (completedItem == null) {
      return currentState;
    }

    return currentState.copyWith(
      dueToday: currentState.dueToday
          .where((ReviewQueueItem item) => item.id != reviewTaskId)
          .toList(),
      upNext: currentState.upNext
          .where((ReviewQueueItem item) => item.id != reviewTaskId)
          .toList(),
      completedToday: <ReviewQueueItem>[
        completedItem.copyWith(dueLabel: 'Done'),
        ...currentState.completedToday,
      ],
    );
  }

  Future<Map<String, dynamic>> _requireCurrentRoadmap() async {
    try {
      return await api.getCurrentRoadmap();
    } on ApiException catch (error) {
      if (error.statusCode != 404) {
        rethrow;
      }
      throw const MissingLearningPlanException();
    }
  }

  Future<Map<String, dynamic>> _requireCurrentSession() async {
    try {
      return await api.getCurrentSession();
    } on ApiException catch (error) {
      if (error.statusCode != 404) {
        rethrow;
      }
      throw const MissingLearningPlanException();
    }
  }

  List<RoadmapMilestone> _milestonesFromRoadmap(Map<String, dynamic> roadmap) {
    final List<dynamic> rawStages =
        roadmap['stages'] as List<dynamic>? ?? <dynamic>[];

    return rawStages.asMap().entries.map((entry) {
      final int index = entry.key;
      final Map<String, dynamic> stage =
          entry.value as Map<String, dynamic>;
      final String status = stage['status'] as String? ?? 'locked';
      return RoadmapMilestone(
        title: _milestoneTitle(index + 1),
        detail: stage['objective'] as String? ?? 'Clarify the goal of this stage.',
        statusLabel: _roadmapStatusLabel(status),
        unlockRequirement:
            'Unlock by ${stage['completion_criteria'] as String? ?? 'finishing the previous step.'}',
        isActive: status == 'active',
        isLocked: status == 'locked',
      );
    }).toList();
  }

  String _journeyTitle(String title) {
    const suffix = ' 学习路线';
    if (title.endsWith(suffix)) {
      return title.substring(0, title.length - suffix.length);
    }
    return title;
  }

  LearningRoadmapDraft _roadmapDraftFromWire(Map<String, dynamic> roadmap) {
    final List<dynamic> rawStages =
        roadmap['stages'] as List<dynamic>? ?? <dynamic>[];
    return LearningRoadmapDraft(
      roadmapId: roadmap['id'] as String,
      title: _journeyTitle(roadmap['title'] as String? ?? 'Learning Roadmap'),
      summary: roadmap['summary'] as String? ??
          'A structured path tailored to your target outcome.',
      estimatedDurationMinutes:
          roadmap['estimated_duration_minutes'] as int? ?? 0,
      stages: rawStages.map((dynamic rawStage) {
        final stage = rawStage as Map<String, dynamic>;
        return LearningRoadmapDraftStage(
          orderIndex: stage['order_index'] as int? ?? 0,
          title: stage['title'] as String? ?? 'Stage',
          objective: stage['objective'] as String? ?? '',
          completionCriteria: stage['completion_criteria'] as String? ?? '',
          status: stage['status'] as String? ?? 'locked',
        );
      }).toList(),
    );
  }

  String _milestoneTitle(int orderIndex) {
    switch (orderIndex) {
      case 1:
        return 'Foundation Systems';
      case 2:
        return 'Patterns in Motion';
      case 3:
        return 'Synthesis Studio';
      default:
        return 'Stage $orderIndex';
    }
  }

  String _roadmapStatusLabel(String status) {
    switch (status) {
      case 'active':
        return 'In progress';
      case 'available':
        return 'Up next';
      case 'locked':
      default:
        return 'Locked';
    }
  }

  Map<String, dynamic> _taskCard(Map<String, dynamic> session) {
    return session['task_card'] as Map<String, dynamic>? ?? <String, dynamic>{};
  }

  List<Map<String, dynamic>> _reviewItems(Map<String, dynamic> response) {
    return (response['items'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
  }

  String _phaseLabel(String phase) {
    switch (phase) {
      case 'example':
        return 'Example';
      case 'compare':
        return 'Compare';
      case 'transfer':
        return 'Transfer';
      case 'explain':
      default:
        return 'Explain';
    }
  }

  ChatPromptStage _stageFromWire(String? phase) {
    switch (phase) {
      case 'example':
        return ChatPromptStage.example;
      case 'compare':
        return ChatPromptStage.compare;
      case 'transfer':
        return ChatPromptStage.transfer;
      case 'explain':
      default:
        return ChatPromptStage.explain;
    }
  }

  String _coachReplyFor(
    ChatPromptStage stage, {
    required String currentPrompt,
  }) {
    switch (stage) {
      case ChatPromptStage.explain:
        return currentPrompt;
      case ChatPromptStage.example:
        return 'Good start. Now ground your idea with one concrete example.';
      case ChatPromptStage.compare:
        return 'Now compare it with a nearby concept so the boundary becomes clearer.';
      case ChatPromptStage.transfer:
        return 'Transfer the idea into a harder case and see whether it still holds.';
    }
  }

  String _reviewTitle(String prompt, int index) {
    switch (index) {
      case 0:
        return 'Wave-particle duality';
      case 1:
        return 'Observer effect';
      default:
        return prompt;
    }
  }

  String _dueLabel(String? dueAt) {
    if (dueAt == null || dueAt.isEmpty) {
      return 'Due now';
    }
    return 'Today';
  }
}

extension on ReviewQueueItem {
  ReviewQueueItem copyWith({
    String? dueLabel,
  }) {
    return ReviewQueueItem(
      id: id,
      title: title,
      detail: detail,
      reason: reason,
      dueLabel: dueLabel ?? this.dueLabel,
      route: route,
    );
  }
}
