import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/locale/app_language.dart';
import '../../../app/locale/app_language_provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/models/profile_models.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/status_message_card.dart';
import '../application/profile_preferences_provider.dart';

class ProfileAnalyticsScreen extends ConsumerWidget {
  const ProfileAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppCopy copy = context.copy;
    final AppLanguage language = ref.watch(appLanguageProvider);
    final ProfilePreferencesState preferences =
        ref.watch(profilePreferencesProvider);
    final ProfilePreferencesNotifier notifier =
        ref.read(profilePreferencesProvider.notifier);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppScaffoldShell(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: AppColors.outlineSoft),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 22,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProgressBadge(label: copy.t(en: 'Personal Dashboard', zh: '个人看板')),
                const SizedBox(height: 18),
                Row(
                  children: <Widget>[
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Alex Harrison', style: textTheme.headlineSmall),
                          const SizedBox(height: 4),
                          Text(
                            copy.t(
                              en: 'Guided learning track · Spring cohort',
                              zh: '引导式学习路径 · 春季学习组',
                            ),
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    _MiniMetric(
                      value: copy.t(en: '24 Days', zh: '24 天'),
                      label: copy.t(en: 'streak', zh: '连续'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        StatusMessageCard(
          title: copy.t(en: 'Achievement momentum', zh: '成就势能'),
          body: copy.t(
            en: 'Your streak, explanation clarity, and review consistency are all trending upward together.',
            zh: '你的连续学习、解释清晰度和复习稳定性正在一起向上增长，这意味着成就系统不是孤立数据，而是真实学习结果的映射。',
          ),
          tone: StatusMessageTone.success,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool useColumns = constraints.maxWidth >= 720;

            final Widget insightCard = SectionCard(
              title: copy.t(en: 'Learning signals', zh: '学习信号'),
              subtitle: copy.t(
                en: 'Momentum, focus, and consistency across the last week.',
                zh: '查看最近一周的学习势能、专注度与稳定性。',
              ),
              trailing: ProgressBadge(label: copy.t(en: 'On track', zh: '状态良好')),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const <Widget>[
                      _MetricCard(label: 'Deep sessions', value: '12'),
                      _MetricCard(label: 'Recall accuracy', value: '84%'),
                      _MetricCard(label: 'Reflection quality', value: 'A-'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/profile/report'),
                      child: Text(
                        copy.t(
                          en: 'Weekly Cognitive Report',
                          zh: '每周认知报告',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );

            final Widget achievementsCard = SectionCard(
              title: copy.t(en: 'Achievements', zh: '成就'),
              subtitle: copy.t(
                en: 'Visible proof that the learning loop is compounding.',
                zh: '用看得见的成果证明你的学习闭环正在累积效果。',
              ),
              trailing: ProgressBadge(label: copy.t(en: '3 new', zh: '新增 3 项')),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _BadgeTile(label: copy.t(en: 'Clear Explainer', zh: '清晰表达者')),
                      _BadgeTile(label: copy.t(en: 'Recall Keeper', zh: '回忆守护者')),
                      _BadgeTile(label: copy.t(en: 'Steady Rhythm', zh: '稳定节奏')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/profile/achievements'),
                      child: Text(
                        copy.t(
                          en: 'Achievements Gallery',
                          zh: '成就展厅',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (!useColumns) {
              return Column(
                children: <Widget>[
                  insightCard,
                  const SizedBox(height: 16),
                  achievementsCard,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: insightCard),
                const SizedBox(width: 16),
                Expanded(child: achievementsCard),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Daily study target', zh: '每日学习目标'),
          subtitle: copy.t(
            en: 'Tune the effort you want this app to protect every day.',
            zh: '设置你希望这个应用每天帮你守住的学习节奏。',
          ),
          trailing: ProgressBadge(
            label: copy.t(
              en: '${preferences.dailyTargetMinutes} min',
              zh: '${preferences.dailyTargetMinutes} 分钟',
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  copy.t(
                    en: 'A daily target keeps Home, Review, and reminders aligned around one realistic commitment.',
                    zh: '每日学习目标会把首页、复习和提醒统一到同一个现实可执行的节奏上。',
                  ),
                  style: textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<int>(
                value: preferences.dailyTargetMinutes,
                items: const <int>[15, 25, 40]
                    .map(
                      (int minutes) => DropdownMenuItem<int>(
                        value: minutes,
                        child: Text('$minutes min'),
                      ),
                    )
                    .toList(),
                onChanged: (int? value) {
                  if (value != null) {
                    notifier.setDailyTargetMinutes(value);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Account settings', zh: '设置'),
          subtitle: copy.t(
            en: 'Study cadence, reminders, sync, and interface preferences.',
            zh: '管理学习节奏、提醒、同步和界面偏好。',
          ),
          trailing: ProgressBadge(
            label: copy.t(
              en: preferences.syncStatus,
              zh: '已同步',
            ),
          ),
          child: Column(
            children: <Widget>[
              _SettingRow(
                label: copy.t(en: 'Interface language', zh: '界面语言'),
                trailing: SizedBox(
                  width: 168,
                  child: SegmentedButton<AppLanguage>(
                    showSelectedIcon: false,
                    segments: <ButtonSegment<AppLanguage>>[
                      ButtonSegment<AppLanguage>(
                        value: AppLanguage.english,
                        label: Text(copy.t(en: 'EN', zh: '英文')),
                      ),
                      ButtonSegment<AppLanguage>(
                        value: AppLanguage.chinese,
                        label: Text(copy.t(en: '中文', zh: '中文')),
                      ),
                    ],
                    selected: <AppLanguage>{language},
                    onSelectionChanged: (Set<AppLanguage> values) {
                      final AppLanguage next = values.first;
                      ref.read(appLanguageProvider.notifier).state = next;
                      notifier.setLanguage(next);
                    },
                  ),
                ),
              ),
              const Divider(height: 24),
              _SettingRow(
                label: copy.t(en: 'Reminder time', zh: '提醒时间'),
                trailing: DropdownButton<int>(
                  value: preferences.reminderHour,
                  items: const <int>[18, 19, 20, 21]
                      .map(
                        (int hour) => DropdownMenuItem<int>(
                          value: hour,
                          child: Text(_formatHour(hour)),
                        ),
                      )
                      .toList(),
                  onChanged: (int? value) {
                    if (value != null) {
                      notifier.setReminderHour(value);
                    }
                  },
                ),
              ),
              const Divider(height: 24),
              _SettingRow(
                label: copy.t(en: 'Sync status', zh: '同步状态'),
                value: copy.t(en: preferences.syncStatus, zh: '8 分钟前已同步'),
              ),
              const Divider(height: 24),
              _SettingRow(
                label: copy.t(en: 'Offline lesson cache', zh: '离线学习缓存'),
                trailing: Switch.adaptive(
                  value: preferences.offlineReady,
                  onChanged: (_) => notifier.toggleOfflineReady(),
                ),
              ),
              const Divider(height: 24),
              _SettingRow(
                label: copy.t(en: 'Weekly insight digest', zh: '每周洞察推送'),
                trailing: DropdownButton<String>(
                  value: preferences.digestDay,
                  items: const <String>['Friday', 'Saturday', 'Sunday']
                      .map(
                        (String day) => DropdownMenuItem<String>(
                          value: day,
                          child: Text(day),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      notifier.setDigestDay(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Milestone spotlight', zh: '里程碑聚焦'),
          subtitle: copy.t(
            en: 'Celebrate newly earned milestones with one focused card.',
            zh: '用一张聚焦卡片查看你刚刚获得的新里程碑。',
          ),
          trailing: ProgressBadge(label: copy.t(en: 'New', zh: '新成就')),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/profile/achievement-unlocked'),
              child: Text(
                copy.t(en: 'Achievement Unlocked', zh: '查看新成就'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _formatHour(int hour) {
    final String prefix = hour < 10 ? '0$hour' : '$hour';
    return '$prefix:00';
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(value, style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(label, style: textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: textTheme.labelMedium),
            const SizedBox(height: 10),
            Text(value, style: textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(label),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    this.value,
    this.trailing,
  });

  final String label;
  final String? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: textTheme.titleMedium),
              if (value != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(value!, style: textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: 16),
          trailing!,
        ],
      ],
    );
  }
}
