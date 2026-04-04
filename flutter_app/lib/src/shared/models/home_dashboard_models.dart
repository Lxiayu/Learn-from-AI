class HomeDashboardState {
  const HomeDashboardState({
    required this.heroLabel,
    required this.greeting,
    required this.summary,
    required this.primaryActionLabel,
    required this.pausedCheckpoint,
    required this.alternateReviewLabel,
    required this.learningTask,
    required this.reviewTask,
    required this.todayLoop,
    required this.exploration,
    required this.quickLinks,
  });

  final String heroLabel;
  final String greeting;
  final String summary;
  final String primaryActionLabel;
  final String pausedCheckpoint;
  final String alternateReviewLabel;
  final HomeTaskCard learningTask;
  final HomeTaskCard reviewTask;
  final List<HomeLoopStep> todayLoop;
  final HomeExplorationSuggestion exploration;
  final List<HomeQuickLink> quickLinks;
}

class HomeTaskCard {
  const HomeTaskCard({
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.ctaLabel,
    required this.route,
  });

  final String title;
  final String description;
  final String badgeLabel;
  final String ctaLabel;
  final String route;
}

class HomeLoopStep {
  const HomeLoopStep({
    required this.label,
    required this.isComplete,
  });

  final String label;
  final bool isComplete;
}

class HomeExplorationSuggestion {
  const HomeExplorationSuggestion({
    required this.title,
    required this.description,
    required this.relatedReason,
    required this.ctaLabel,
  });

  final String title;
  final String description;
  final String relatedReason;
  final String ctaLabel;
}

class HomeQuickLink {
  const HomeQuickLink({
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.route,
  });

  final String title;
  final String description;
  final String badgeLabel;
  final String route;
}
