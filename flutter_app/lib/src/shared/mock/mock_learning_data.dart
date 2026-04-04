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
    required this.roadmapEntry,
    required this.insightsEntry,
    required this.achievementEntry,
  });

  final String greeting;
  final String goalSummary;
  final HomeLearningTask learningTask;
  final HomeReviewTask reviewTask;
  final HomeQuickEntry roadmapEntry;
  final HomeQuickEntry insightsEntry;
  final HomeQuickEntry achievementEntry;
}

class HomeQuickEntry {
  const HomeQuickEntry({
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.ctaLabel,
  });

  final String title;
  final String description;
  final String badgeLabel;
  final String ctaLabel;
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
  roadmapEntry: HomeQuickEntry(
    title: 'Current Roadmap',
    description: 'Open the active stage and see which node unlocks next.',
    badgeLabel: '3 stages',
    ctaLabel: 'Open roadmap',
  ),
  insightsEntry: HomeQuickEntry(
    title: 'Learning Insights',
    description: 'Check streak, completion trend, and this week’s pace.',
    badgeLabel: '7 day streak',
    ctaLabel: 'View insights',
  ),
  achievementEntry: HomeQuickEntry(
    title: 'Achievements',
    description: 'Review recent milestones and the next badge within reach.',
    badgeLabel: '2 new',
    ctaLabel: 'View achievements',
  ),
);
