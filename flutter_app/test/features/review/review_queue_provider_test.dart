import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/features/review/application/review_queue_provider.dart';

void main() {
  test('review queue groups items by urgency', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final queue = container.read(reviewQueueProvider);

    expect(queue.dueToday, isNotEmpty);
    expect(queue.upNext, isNotEmpty);
  });
}
