class RoadmapMilestone {
  const RoadmapMilestone({
    required this.title,
    required this.detail,
    required this.statusLabel,
    required this.unlockRequirement,
    required this.isActive,
    required this.isLocked,
  });

  final String title;
  final String detail;
  final String statusLabel;
  final String unlockRequirement;
  final bool isActive;
  final bool isLocked;
}

class SavedBranch {
  const SavedBranch({
    required this.title,
    required this.reason,
  });

  final String title;
  final String reason;
}

class RoadmapProgressState {
  const RoadmapProgressState({
    required this.journeyTitle,
    required this.currentGoal,
    required this.whyThisIsNext,
    required this.continueRoute,
    required this.milestones,
    required this.savedBranches,
  });

  final String journeyTitle;
  final String currentGoal;
  final String whyThisIsNext;
  final String continueRoute;
  final List<RoadmapMilestone> milestones;
  final List<SavedBranch> savedBranches;
}
