import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../learning/data/learning_providers.dart';
import '../../../shared/models/roadmap_models.dart';

final FutureProvider<RoadmapProgressState> roadmapProgressProvider =
    FutureProvider<RoadmapProgressState>(
      (Ref ref) => ref.watch(learningRepositoryProvider).loadRoadmapProgress(),
    );
