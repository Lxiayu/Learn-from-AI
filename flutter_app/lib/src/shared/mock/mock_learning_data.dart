class HomeLearningTask {
  const HomeLearningTask({
    required this.title,
    required this.description,
    required this.progressLabel,
    required this.ctaLabel,
  });

  final String title;
  final String description;
  final String progressLabel;
  final String ctaLabel;
}

class HomeReviewTask {
  const HomeReviewTask({
    required this.title,
    required this.description,
    required this.dueLabel,
    required this.ctaLabel,
  });

  final String title;
  final String description;
  final String dueLabel;
  final String ctaLabel;
}

class HomeDashboardMockData {
  const HomeDashboardMockData({
    required this.greeting,
    required this.goalSummary,
    required this.learningTask,
    required this.reviewTask,
  });

  final String greeting;
  final String goalSummary;
  final HomeLearningTask learningTask;
  final HomeReviewTask reviewTask;
}

const HomeDashboardMockData mockHomeDashboardData = HomeDashboardMockData(
  greeting: 'Today',
  goalSummary: 'Build momentum through guided questions and spaced review.',
  learningTask: HomeLearningTask(
    title: 'Binary Search Foundations',
    description: 'Pick up from the current node and answer the next AI prompt.',
    progressLabel: 'Stage 1 • 42%',
    ctaLabel: 'Resume',
  ),
  reviewTask: HomeReviewTask(
    title: 'Sorting Concepts Review',
    description: 'Rehearse the key distinction between stable and unstable sorts.',
    dueLabel: 'Due today',
    ctaLabel: 'Start review',
  ),
);
