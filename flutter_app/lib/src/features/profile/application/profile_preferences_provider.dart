import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/locale/app_language.dart';
import '../../../shared/mock/mock_learning_data.dart';
import '../../../shared/models/profile_models.dart';

final StateNotifierProvider<ProfilePreferencesNotifier, ProfilePreferencesState>
profilePreferencesProvider =
    StateNotifierProvider<ProfilePreferencesNotifier, ProfilePreferencesState>(
      (Ref ref) => ProfilePreferencesNotifier(),
    );

class ProfilePreferencesNotifier extends StateNotifier<ProfilePreferencesState> {
  ProfilePreferencesNotifier() : super(mockProfilePreferencesState);

  void setLanguage(AppLanguage language) {
    state = state.copyWith(language: language);
  }

  void setReminderHour(int hour) {
    state = state.copyWith(reminderHour: hour);
  }

  void setDigestDay(String day) {
    state = state.copyWith(digestDay: day);
  }

  void setDailyTargetMinutes(int minutes) {
    state = state.copyWith(dailyTargetMinutes: minutes);
  }

  void toggleOfflineReady() {
    state = state.copyWith(offlineReady: !state.offlineReady);
  }

  void setSyncStatus(String status) {
    state = state.copyWith(syncStatus: status);
  }
}
