import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/features/learning/data/learning_providers.dart';
import 'package:flutter_app/src/features/roadmap/application/roadmap_progress_provider.dart';

import '../../test_helpers/fake_learning_repository.dart';

void main() {
  test('roadmap provider resolves the current roadmap from repository', () async {
    final container = ProviderContainer(
      overrides: <Override>[
        learningRepositoryProvider.overrideWithValue(FakeLearningRepository()),
      ],
    );
    addTearDown(container.dispose);

    final state = await container.read(roadmapProgressProvider.future);

    expect(state.milestones, hasLength(3));
    expect(state.continueRoute, '/chat');
  });
}
