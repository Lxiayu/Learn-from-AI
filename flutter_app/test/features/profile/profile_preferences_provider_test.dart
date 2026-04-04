import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/locale/app_language.dart';
import 'package:flutter_app/src/features/profile/application/profile_preferences_provider.dart';

void main() {
  test('profile preferences can switch app language and reminder cadence', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(profilePreferencesProvider.notifier);
    notifier.setLanguage(AppLanguage.chinese);
    notifier.setReminderHour(20);

    final state = container.read(profilePreferencesProvider);
    expect(state.language, AppLanguage.chinese);
    expect(state.reminderHour, 20);
  });
}
