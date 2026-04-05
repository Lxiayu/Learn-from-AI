import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../learning/data/learning_providers.dart';
import '../../../shared/models/review_models.dart';

final AsyncNotifierProvider<ReviewQueueNotifier, ReviewQueueState>
reviewQueueProvider =
    AsyncNotifierProvider<ReviewQueueNotifier, ReviewQueueState>(
      ReviewQueueNotifier.new,
    );

class ReviewQueueNotifier extends AsyncNotifier<ReviewQueueState> {
  @override
  Future<ReviewQueueState> build() {
    return ref.watch(learningRepositoryProvider).loadReviewQueue();
  }

  Future<void> completeItem(String id) async {
    final ReviewQueueState? currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    final nextState = await ref
        .read(learningRepositoryProvider)
        .completeReview(currentState: currentState, reviewTaskId: id);
    state = AsyncData(nextState);
  }

  Future<void> reset() async {
    state = const AsyncLoading<ReviewQueueState>();
    state = AsyncData(
      await ref.read(learningRepositoryProvider).loadReviewQueue(),
    );
  }
}
