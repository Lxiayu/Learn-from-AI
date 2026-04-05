import 'package:flutter_app/src/features/learning/data/learning_api.dart';

class NoopLearningApi implements LearningApi {
  @override
  Future<Map<String, dynamic>> answerSession(
    String sessionId, {
    required String answer,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> completeReview(
    String reviewTaskId, {
    required String result,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> completeSession(String sessionId) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> confirmRoadmap(String roadmapId) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> createLearningGoal({
    required String topic,
    required String targetOutcome,
    required String currentLevel,
    required String studyPace,
    required bool evaluationPreference,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> explainAgain(String sessionId) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> generateRoadmap({
    required String learningGoalId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getCurrentRoadmap() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getCurrentSession() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getHint(String sessionId) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getTodayReviews() {
    throw UnimplementedError();
  }
}
