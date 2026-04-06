import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/core/network/api_client.dart';
import 'package:flutter_app/src/features/learning/data/learning_api.dart';
import 'package:flutter_app/src/features/learning/data/learning_repository.dart';
import 'package:flutter_app/src/features/learning/domain/learning_goal_setup_models.dart';
import 'package:flutter_app/src/shared/models/chat_session_models.dart';

void main() {
  test('repository throws MissingLearningPlanException when no roadmap exists', () async {
    final api = _FakeLearningApi.missingCurrent();
    final repository = LearningRepository(api: api);

    expect(
      () => repository.loadHomeDashboard(),
      throwsA(isA<MissingLearningPlanException>()),
    );
    expect(api.createLearningGoalCalls, 0);
    expect(api.generateRoadmapCalls, 0);
    expect(api.confirmRoadmapCalls, 0);
  });

  test('repository creates a roadmap draft from learner input', () async {
    final api = _FakeLearningApi.missingCurrent();
    final repository = LearningRepository(api: api);

    final draft = await repository.createRoadmapDraft(
      const LearningGoalSetupInput(
        topic: 'Linear Algebra',
        targetOutcome: 'Use vectors and matrices to solve medium problems.',
        currentLevel: LearningCurrentLevel.beginner,
        studyPace: LearningStudyPace.steady,
        evaluationPreference: true,
      ),
    );

    expect(api.createLearningGoalCalls, 1);
    expect(api.generateRoadmapCalls, 1);
    expect(draft.roadmapId, 'roadmap-1');
    expect(draft.title, 'Quantum Physics Fundamentals');
    expect(draft.stages, hasLength(3));
  });

  test('repository maps roadmap stages into UI milestones', () async {
    final repository = LearningRepository(api: _FakeLearningApi.ready());

    final roadmap = await repository.loadRoadmapProgress();

    expect(roadmap.journeyTitle, 'Quantum Physics Fundamentals');
    expect(roadmap.milestones, hasLength(3));
    expect(roadmap.milestones.first.title, 'Foundation Systems');
    expect(roadmap.milestones.first.isActive, isTrue);
    expect(roadmap.milestones[1].isLocked, isFalse);
    expect(roadmap.milestones[2].isLocked, isTrue);
  });

  test('repository advances chat stage after a successful answer', () async {
    final repository = LearningRepository(api: _FakeLearningApi.ready());
    final loaded = await repository.loadChatSession();

    final nextState = await repository.submitChatAnswer(
      sessionId: loaded.sessionId,
      currentState: loaded.state,
      answer: 'Justice requires fairness, not only obedience.',
    );

    expect(nextState.currentStage, ChatPromptStage.example);
    expect(nextState.messages.last.role, ChatMessageRole.coach);
    expect(nextState.helperFeedbackTitle, 'Reflection captured');
  });

  test('repository returns generated review count after completing a session', () async {
    final repository = LearningRepository(api: _FakeLearningApi.ready());

    final generatedReviewCount = await repository.completeLearningSession(
      sessionId: 'session-1',
    );

    expect(generatedReviewCount, 1);
  });
}

class _FakeLearningApi implements LearningApi {
  _FakeLearningApi._({required this.startMissingCurrent});

  factory _FakeLearningApi.missingCurrent() {
    return _FakeLearningApi._(startMissingCurrent: true);
  }

  factory _FakeLearningApi.ready() {
    return _FakeLearningApi._(startMissingCurrent: false);
  }

  final bool startMissingCurrent;

  int createLearningGoalCalls = 0;
  int generateRoadmapCalls = 0;
  int confirmRoadmapCalls = 0;

  Map<String, dynamic> get _roadmap => <String, dynamic>{
    'id': 'roadmap-1',
    'learning_goal_id': 'goal-1',
    'title': 'Quantum Physics Fundamentals 学习路线',
    'summary':
        'This stage comes next because the core explanation is stable enough for deeper comparisons.',
    'current_stage_index': 1,
    'total_stage_count': 3,
    'estimated_duration_minutes': 420,
    'version': 1,
    'status': 'active',
    'source': 'local_api',
    'sync_status': 'local_only',
    'created_at': '2026-04-05T10:00:00Z',
    'updated_at': '2026-04-05T10:00:00Z',
    'stages': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'stage-1',
        'roadmap_id': 'roadmap-1',
        'order_index': 1,
        'title': '建立核心概念图景',
        'objective': 'Clarify the core idea before giving examples.',
        'completion_criteria': 'Explain the concept clearly with one example.',
        'status': 'active',
        'created_at': '2026-04-05T10:00:00Z',
        'updated_at': '2026-04-05T10:00:00Z',
      },
      <String, dynamic>{
        'id': 'stage-2',
        'roadmap_id': 'roadmap-1',
        'order_index': 2,
        'title': '掌握典型问题模式',
        'objective': 'Compare nearby concepts and trade-offs.',
        'completion_criteria': 'Compare two related concepts with confidence.',
        'status': 'available',
        'created_at': '2026-04-05T10:00:00Z',
        'updated_at': '2026-04-05T10:00:00Z',
      },
      <String, dynamic>{
        'id': 'stage-3',
        'roadmap_id': 'roadmap-1',
        'order_index': 3,
        'title': '迁移到真实问题',
        'objective': 'Transfer the idea into a new problem.',
        'completion_criteria': 'Use the concept in a fresh scenario.',
        'status': 'locked',
        'created_at': '2026-04-05T10:00:00Z',
        'updated_at': '2026-04-05T10:00:00Z',
      },
    ],
  };

  Map<String, dynamic> get _draftRoadmap => <String, dynamic>{
    ..._roadmap,
    'status': 'draft',
    'current_stage_index': 0,
  };

  Map<String, dynamic> get _session => <String, dynamic>{
    'id': 'session-1',
    'roadmap_id': 'roadmap-1',
    'current_stage_id': 'stage-1',
    'phase': 'explain',
    'version': 1,
    'status': 'in_progress',
    'source': 'local_api',
    'sync_status': 'local_only',
    'created_at': '2026-04-05T10:01:00Z',
    'updated_at': '2026-04-05T10:01:00Z',
    'task_card': <String, dynamic>{
      'topic': 'Foundation Systems',
      'objective': 'Clarify the core idea before giving examples.',
      'question_focus':
          'Explain the concept in your own words, then add a simple example.',
      'success_criteria': 'Explain the concept clearly with one example.',
      'estimated_minutes': 20,
    },
  };

  @override
  Future<Map<String, dynamic>> answerSession(
    String sessionId, {
    required String answer,
  }) async {
    return <String, dynamic>{
      'feedback': <String, String>{
        'type': 'encourage',
        'message': 'Strong answer. Let us deepen it with an example.',
      },
      'next_step': 'example',
    };
  }

  @override
  Future<void> completeReview(
    String reviewTaskId, {
    required String result,
  }) async {}

  @override
  Future<Map<String, dynamic>> completeSession(String sessionId) async {
    return <String, dynamic>{
      'generated_review_tasks': <Map<String, String>>[
        <String, String>{'id': 'review-1', 'prompt': 'Review the concept again.'},
      ],
    };
  }

  @override
  Future<Map<String, dynamic>> confirmRoadmap(String roadmapId) async {
    confirmRoadmapCalls += 1;
    return _roadmap;
  }

  @override
  Future<Map<String, dynamic>> createLearningGoal({
    required String topic,
    required String targetOutcome,
    required String currentLevel,
    required String studyPace,
    required bool evaluationPreference,
  }) async {
    createLearningGoalCalls += 1;
    return <String, dynamic>{'id': 'goal-1'};
  }

  @override
  Future<Map<String, dynamic>> explainAgain(String sessionId) async {
    return <String, dynamic>{
      'explanation': 'Try contrasting the idea with a nearby concept.',
    };
  }

  @override
  Future<Map<String, dynamic>> generateRoadmap({
    required String learningGoalId,
  }) async {
    generateRoadmapCalls += 1;
    return _draftRoadmap;
  }

  @override
  Future<Map<String, dynamic>> getCurrentRoadmap() async {
    if (startMissingCurrent) {
      throw const ApiException(statusCode: 404, message: 'active_roadmap_not_found');
    }
    return _roadmap;
  }

  @override
  Future<Map<String, dynamic>> getCurrentSession() async {
    if (startMissingCurrent) {
      throw const ApiException(statusCode: 404, message: 'active_roadmap_not_found');
    }
    return _session;
  }

  @override
  Future<Map<String, dynamic>> getHint(String sessionId) async {
    return <String, dynamic>{
      'hint': 'Start from the most important trait first.',
    };
  }

  @override
  Future<Map<String, dynamic>> getTodayReviews() async {
    return <String, dynamic>{
      'items': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'review-1',
          'prompt': 'Review the concept behind wave-particle duality.',
          'due_at': '2026-04-05T10:30:00Z',
          'status': 'pending',
        },
        <String, dynamic>{
          'id': 'review-2',
          'prompt': 'Review the distinction between observer and measurement.',
          'due_at': '2026-04-05T18:00:00Z',
          'status': 'pending',
        },
      ],
    };
  }
}
