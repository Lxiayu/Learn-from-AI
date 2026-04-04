import '../../app/locale/app_language.dart';

class ProfilePreferencesState {
  const ProfilePreferencesState({
    required this.language,
    required this.reminderHour,
    required this.digestDay,
    required this.offlineReady,
    required this.syncStatus,
    required this.dailyTargetMinutes,
  });

  final AppLanguage language;
  final int reminderHour;
  final String digestDay;
  final bool offlineReady;
  final String syncStatus;
  final int dailyTargetMinutes;

  ProfilePreferencesState copyWith({
    AppLanguage? language,
    int? reminderHour,
    String? digestDay,
    bool? offlineReady,
    String? syncStatus,
    int? dailyTargetMinutes,
  }) {
    return ProfilePreferencesState(
      language: language ?? this.language,
      reminderHour: reminderHour ?? this.reminderHour,
      digestDay: digestDay ?? this.digestDay,
      offlineReady: offlineReady ?? this.offlineReady,
      syncStatus: syncStatus ?? this.syncStatus,
      dailyTargetMinutes: dailyTargetMinutes ?? this.dailyTargetMinutes,
    );
  }
}
