enum LearningCurrentLevel {
  beginner,
  intermediate,
  advanced;

  String get wireValue {
    switch (this) {
      case LearningCurrentLevel.beginner:
        return 'beginner';
      case LearningCurrentLevel.intermediate:
        return 'intermediate';
      case LearningCurrentLevel.advanced:
        return 'advanced';
    }
  }
}

enum LearningStudyPace {
  light,
  steady,
  immersive;

  String get wireValue {
    switch (this) {
      case LearningStudyPace.light:
        return 'light';
      case LearningStudyPace.steady:
        return 'steady';
      case LearningStudyPace.immersive:
        return 'immersive';
    }
  }
}

class LearningGoalSetupInput {
  const LearningGoalSetupInput({
    required this.topic,
    required this.targetOutcome,
    required this.currentLevel,
    required this.studyPace,
    required this.evaluationPreference,
  });

  final String topic;
  final String targetOutcome;
  final LearningCurrentLevel currentLevel;
  final LearningStudyPace studyPace;
  final bool evaluationPreference;
}

class LearningRoadmapDraftStage {
  const LearningRoadmapDraftStage({
    required this.orderIndex,
    required this.title,
    required this.objective,
    required this.completionCriteria,
    required this.status,
  });

  final int orderIndex;
  final String title;
  final String objective;
  final String completionCriteria;
  final String status;
}

class LearningRoadmapDraft {
  const LearningRoadmapDraft({
    required this.roadmapId,
    required this.title,
    required this.summary,
    required this.estimatedDurationMinutes,
    required this.stages,
  });

  final String roadmapId;
  final String title;
  final String summary;
  final int estimatedDurationMinutes;
  final List<LearningRoadmapDraftStage> stages;
}
