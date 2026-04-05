import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../learning/data/learning_providers.dart';
import '../../../shared/models/home_dashboard_models.dart';

final FutureProvider<HomeDashboardState> homeDashboardProvider =
    FutureProvider<HomeDashboardState>(
      (Ref ref) => ref.watch(learningRepositoryProvider).loadHomeDashboard(),
    );
