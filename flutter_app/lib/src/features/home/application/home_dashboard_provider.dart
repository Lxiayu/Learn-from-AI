import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/mock/mock_learning_data.dart';
import '../../../shared/models/home_dashboard_models.dart';

final Provider<HomeDashboardState> homeDashboardProvider =
    Provider<HomeDashboardState>((Ref ref) => mockHomeDashboardState);
