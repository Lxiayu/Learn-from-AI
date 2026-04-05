import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/features/home/application/home_dashboard_provider.dart';
import 'package:flutter_app/src/features/learning/data/learning_providers.dart';

import '../../test_helpers/fake_learning_repository.dart';

void main() {
  test('home dashboard provider loads task-first state from repository', () async {
    final container = ProviderContainer(
      overrides: <Override>[
        learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
      ],
    );
    addTearDown(container.dispose);

    final state = await container.read(homeDashboardProvider.future);

    expect(state.learningTask.route, '/chat');
    expect(state.reviewTask.route, '/review');
  });
}
