import '../../../core/network/api_client.dart';

abstract class LearningApi {
  Future<Map<String, dynamic>> createLearningGoal({
    required String topic,
    required String targetOutcome,
    required String currentLevel,
    required String studyPace,
    required bool evaluationPreference,
  });

  Future<Map<String, dynamic>> generateRoadmap({
    required String learningGoalId,
  });

  Future<Map<String, dynamic>> confirmRoadmap(String roadmapId);

  Future<Map<String, dynamic>> getCurrentRoadmap();

  Future<Map<String, dynamic>> getCurrentSession();

  Future<Map<String, dynamic>> answerSession(
    String sessionId, {
    required String answer,
  });

  Future<Map<String, dynamic>> getHint(String sessionId);

  Future<Map<String, dynamic>> explainAgain(String sessionId);

  Future<Map<String, dynamic>> completeSession(String sessionId);

  Future<Map<String, dynamic>> getTodayReviews();

  Future<void> completeReview(
    String reviewTaskId, {
    required String result,
  });
}

class HttpLearningApi implements LearningApi {
  HttpLearningApi({required this.client});

  final ApiClient client;

  @override
  Future<Map<String, dynamic>> answerSession(
    String sessionId, {
    required String answer,
  }) {
    return client.postJson(
      '/sessions/$sessionId/answer',
      body: <String, dynamic>{'answer': answer},
    );
  }

  @override
  Future<void> completeReview(
    String reviewTaskId, {
    required String result,
  }) async {
    await client.postJson(
      '/reviews/$reviewTaskId/complete',
      body: <String, dynamic>{'result': result},
    );
  }

  @override
  Future<Map<String, dynamic>> completeSession(String sessionId) {
    return client.postJson('/sessions/$sessionId/complete');
  }

  @override
  Future<Map<String, dynamic>> confirmRoadmap(String roadmapId) {
    return client.postJson('/roadmaps/$roadmapId/confirm');
  }

  @override
  Future<Map<String, dynamic>> createLearningGoal({
    required String topic,
    required String targetOutcome,
    required String currentLevel,
    required String studyPace,
    required bool evaluationPreference,
  }) {
    return client.postJson(
      '/learning-goals',
      body: <String, dynamic>{
        'topic': topic,
        'target_outcome': targetOutcome,
        'current_level': currentLevel,
        'study_pace': studyPace,
        'evaluation_preference': evaluationPreference,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> explainAgain(String sessionId) {
    return client.postJson('/sessions/$sessionId/explain-again');
  }

  @override
  Future<Map<String, dynamic>> generateRoadmap({
    required String learningGoalId,
  }) {
    return client.postJson(
      '/roadmaps/generate',
      body: <String, dynamic>{'learning_goal_id': learningGoalId},
    );
  }

  @override
  Future<Map<String, dynamic>> getCurrentRoadmap() {
    return client.getJson('/roadmaps/current');
  }

  @override
  Future<Map<String, dynamic>> getCurrentSession() {
    return client.getJson('/sessions/current');
  }

  @override
  Future<Map<String, dynamic>> getHint(String sessionId) {
    return client.postJson('/sessions/$sessionId/hint');
  }

  @override
  Future<Map<String, dynamic>> getTodayReviews() {
    return client.getJson('/reviews/today');
  }
}
