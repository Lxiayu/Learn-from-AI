import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/mock/mock_learning_data.dart';
import '../../../shared/models/review_models.dart';

final StateNotifierProvider<ReviewQueueNotifier, ReviewQueueState>
reviewQueueProvider =
    StateNotifierProvider<ReviewQueueNotifier, ReviewQueueState>(
      (Ref ref) => ReviewQueueNotifier(),
    );

class ReviewQueueNotifier extends StateNotifier<ReviewQueueState> {
  ReviewQueueNotifier() : super(mockReviewQueueState);

  void completeItem(String id) {
    final ReviewQueueItem? dueItem = _findById(state.dueToday, id);
    final ReviewQueueItem? upNextItem = _findById(state.upNext, id);
    final ReviewQueueItem? item = dueItem ?? upNextItem;

    if (item == null) {
      return;
    }

    state = state.copyWith(
      dueToday: state.dueToday.where((ReviewQueueItem entry) => entry.id != id).toList(),
      upNext: state.upNext.where((ReviewQueueItem entry) => entry.id != id).toList(),
      completedToday: <ReviewQueueItem>[item, ...state.completedToday],
    );
  }

  void reset() {
    state = mockReviewQueueState;
  }

  ReviewQueueItem? _findById(List<ReviewQueueItem> items, String id) {
    for (final ReviewQueueItem item in items) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }
}
