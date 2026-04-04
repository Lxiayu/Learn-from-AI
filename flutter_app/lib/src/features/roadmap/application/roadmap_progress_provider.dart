import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/mock/mock_learning_data.dart';
import '../../../shared/models/roadmap_models.dart';

final Provider<RoadmapProgressState> roadmapProgressProvider =
    Provider<RoadmapProgressState>((Ref ref) => mockRoadmapProgressState);
