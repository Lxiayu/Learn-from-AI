class ReviewQueueItem {
  const ReviewQueueItem({
    required this.id,
    required this.title,
    required this.detail,
    required this.reason,
    required this.dueLabel,
    required this.route,
  });

  final String id;
  final String title;
  final String detail;
  final String reason;
  final String dueLabel;
  final String route;
}

class ReviewQueueState {
  const ReviewQueueState({
    required this.dueToday,
    required this.upNext,
    required this.completedToday,
  });

  final List<ReviewQueueItem> dueToday;
  final List<ReviewQueueItem> upNext;
  final List<ReviewQueueItem> completedToday;

  ReviewQueueState copyWith({
    List<ReviewQueueItem>? dueToday,
    List<ReviewQueueItem>? upNext,
    List<ReviewQueueItem>? completedToday,
  }) {
    return ReviewQueueState(
      dueToday: dueToday ?? this.dueToday,
      upNext: upNext ?? this.upNext,
      completedToday: completedToday ?? this.completedToday,
    );
  }
}
