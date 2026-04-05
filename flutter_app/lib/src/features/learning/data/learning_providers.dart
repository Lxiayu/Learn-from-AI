import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_env.dart';
import '../../../core/network/api_client.dart';
import 'learning_api.dart';
import 'learning_repository.dart';

final Provider<ApiClient> apiClientProvider = Provider<ApiClient>(
  (Ref ref) => ApiClient(baseUrl: AppEnv.apiBaseUrl),
);

final Provider<LearningApi> learningApiProvider = Provider<LearningApi>(
  (Ref ref) => HttpLearningApi(client: ref.watch(apiClientProvider)),
);

final Provider<LearningRepository> learningRepositoryProvider =
    Provider<LearningRepository>(
      (Ref ref) => LearningRepository(api: ref.watch(learningApiProvider)),
    );
