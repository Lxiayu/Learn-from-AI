import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/models/home_dashboard_models.dart';
import '../../../shared/widgets/empty_state_card.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/status_message_card.dart';
import '../../learning/data/learning_repository.dart';
import '../../learning/presentation/missing_learning_plan_state.dart';
import '../application/home_dashboard_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppCopy copy = context.copy;
    final AsyncValue<HomeDashboardState> dashboardAsync = ref.watch(
      homeDashboardProvider,
    );

    return dashboardAsync.when(
      data: (HomeDashboardState dashboard) {
        final TextTheme textTheme = Theme.of(context).textTheme;

        return AppScaffoldShell(
          children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[
                AppColors.surfaceBlueStrong,
                AppColors.surfaceElevated,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: AppColors.outlineSoft),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProgressBadge(label: copy.t(en: dashboard.heroLabel, zh: '今日任务台')),
                const SizedBox(height: 18),
                Text(
                  copy.t(en: dashboard.greeting, zh: '早上好，Alex！'),
                  style: textTheme.displayLarge?.copyWith(fontSize: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  copy.t(
                    en: dashboard.summary,
                    zh: '回到当前主学习，完成一次复习，再用一段简短反思把今天的学习闭环收住。',
                  ),
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  copy.t(
                    en: dashboard.pausedCheckpoint,
                    zh: '你上次停在：波粒二象性 -> 比较阶段',
                  ),
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryActionButton(
                    label: copy.t(
                      en: dashboard.primaryActionLabel,
                      zh: '继续当前学习',
                    ),
                    onPressed: () => context.go(dashboard.learningTask.route),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.go(dashboard.reviewTask.route),
                  child: Text(
                    copy.t(
                      en: dashboard.alternateReviewLabel,
                      zh: '改为先做复习',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        StatusMessageCard(
          title: copy.t(
            en: 'Today loop is still open',
            zh: '今天的学习闭环还没完成',
          ),
          body: copy.t(
            en: 'One inquiry, one review, and one wrap-up will close today with a clear finish.',
            zh: '你已经进入比较阶段。再完成一次主学习和一次复习，今天就能顺利收束。',
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool useColumns = constraints.maxWidth >= 780;
            final Widget todayLoopCard = SectionCard(
              title: copy.t(en: 'Today loop', zh: '今日闭环'),
              subtitle: copy.t(
                en: 'One main inquiry, one review, one wrap-up.',
                zh: '一次主学习，一次复习，一次收束总结。',
              ),
              trailing: ProgressBadge(
                label: copy.t(en: '3 checkpoints', zh: '3 个节点'),
              ),
              child: Column(
                children: dashboard.todayLoop
                    .map(
                      (HomeLoopStep step) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _LoopStatusTile(
                          label: _localizedLoopLabel(copy, step.label),
                          statusLabel: step.isComplete
                              ? copy.t(en: 'Done', zh: '完成')
                              : copy.t(en: 'Open', zh: '进行中'),
                          isComplete: step.isComplete,
                        ),
                      ),
                    )
                    .toList(),
              ),
            );

            final Widget currentTaskCard = SectionCard(
              title: copy.t(en: 'Current task', zh: '当前任务'),
              subtitle: copy.t(
                en: dashboard.learningTask.title,
                zh: '量子物理基础',
              ),
              trailing: ProgressBadge(label: dashboard.learningTask.badgeLabel),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    copy.t(
                      en: dashboard.learningTask.description,
                      zh: '回到当前引导式对话，把“不确定性”和“解释”之间的边界讲得更清楚。',
                    ),
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryActionButton(
                      label: copy.t(
                        en: dashboard.learningTask.ctaLabel,
                        zh: '进入主学习',
                      ),
                      onPressed: () => context.go(dashboard.learningTask.route),
                    ),
                  ),
                ],
              ),
            );

            if (!useColumns) {
              return Column(
                children: <Widget>[
                  todayLoopCard,
                  const SizedBox(height: 16),
                  currentTaskCard,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: todayLoopCard),
                const SizedBox(width: 16),
                Expanded(child: currentTaskCard),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Review before it fades', zh: '趁还没淡忘先复习'),
          subtitle: copy.t(
            en: dashboard.reviewTask.title,
            zh: '今天有两个概念进入最佳复习窗口。',
          ),
          trailing: ProgressBadge(label: dashboard.reviewTask.badgeLabel),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                copy.t(
                  en: dashboard.reviewTask.description,
                  zh: '现在做一轮短复习，会让下一段对话里的概念边界更稳，也更容易迁移。',
                ),
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go(dashboard.reviewTask.route),
                  child: Text(
                    copy.t(en: dashboard.reviewTask.ctaLabel, zh: '打开复习'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Explore after the main path', zh: '主线后再探索'),
          subtitle: copy.t(en: dashboard.exploration.title, zh: '哥本哈根诠释'),
          trailing: ProgressBadge(label: copy.t(en: 'Saved branch', zh: '已加入分支')),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                copy.t(
                  en: dashboard.exploration.description,
                  zh: '这是和当前主题最相关的一条延展线索，但不会打断你今天的主学习。',
                ),
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                copy.t(
                  en: dashboard.exploration.relatedReason,
                  zh: '等你先把测量和解释的边界讲清楚，再看这条分支，收获会更大。',
                ),
                style: textTheme.labelLarge?.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/roadmap'),
                  child: Text(
                    copy.t(
                      en: dashboard.exploration.ctaLabel,
                      zh: '先存到主线后探索',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          copy.t(en: 'Quick links', zh: '快捷入口'),
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        if (dashboard.quickLinks.isEmpty)
          EmptyStateCard(
            icon: Icons.dashboard_customize_outlined,
            title: copy.t(en: 'No quick links yet', zh: '暂时还没有快捷入口'),
            body: copy.t(
              en: 'As you build a learning rhythm, your shortcuts will appear here.',
              zh: '当你的学习节奏逐渐稳定后，这里会出现更贴近你的快捷入口。',
            ),
          )
        else
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool useColumns = constraints.maxWidth >= 980;
              final List<Widget> cards = dashboard.quickLinks
                  .map(
                    (HomeQuickLink link) => _QuickLinkCard(
                      title: _localizedQuickLinkTitle(copy, link.title),
                      description:
                          _localizedQuickLinkDescription(copy, link.description),
                      badgeLabel: link.badgeLabel,
                      actionLabel: copy.t(en: 'Open', zh: '打开'),
                      onTap: () => context.go(link.route),
                    ),
                  )
                  .toList();

              if (!useColumns) {
                return Column(
                  children: cards
                      .expand<Widget>((Widget card) => <Widget>[
                            card,
                            const SizedBox(height: 12),
                          ])
                      .toList()
                    ..removeLast(),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cards
                    .expand<Widget>((Widget card) => <Widget>[
                          Expanded(child: card),
                          const SizedBox(width: 12),
                        ])
                    .toList()
                  ..removeLast(),
              );
            },
        ),
          ],
        );
      },
      loading: () => AppScaffoldShell(
        children: <Widget>[
          SectionCard(
            title: copy.t(en: 'Loading today', zh: '正在准备今天的学习'),
            subtitle: copy.t(
              en: 'We are syncing the current roadmap, inquiry, and review queue.',
              zh: '正在同步当前路线、主学习和复习队列。',
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      error: (Object error, StackTrace stackTrace) => AppScaffoldShell(
        children: <Widget>[
          if (error is MissingLearningPlanException) ...<Widget>[
            const MissingLearningPlanState(),
          ] else ...<Widget>[
          StatusMessageCard(
            title: copy.t(
              en: 'The task console could not load',
              zh: '任务台暂时加载失败',
            ),
            body: copy.t(
              en: 'Check whether the local backend is running, then refresh this page.',
              zh: '请先确认本地后端已经启动，然后重新进入这个页面。',
            ),
            tone: StatusMessageTone.warning,
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: copy.t(en: 'Error details', zh: '错误详情'),
            subtitle: copy.t(
              en: 'This helps during local MVP debugging.',
              zh: '这有助于本地 MVP 联调时定位问题。',
            ),
            child: SelectableText(error.toString()),
          ),
          ],
        ],
      ),
    );
  }

  String _localizedLoopLabel(AppCopy copy, String label) {
    switch (label) {
      case 'Main inquiry':
        return copy.t(en: label, zh: '主学习');
      case 'Spaced review':
        return copy.t(en: label, zh: '间隔复习');
      case 'Session wrap-up':
        return copy.t(en: label, zh: '学习收束');
      default:
        return label;
    }
  }

  String _localizedQuickLinkTitle(AppCopy copy, String title) {
    switch (title) {
      case 'Current roadmap':
        return copy.t(en: title, zh: '当前路线');
      case 'Learning insights':
        return copy.t(en: title, zh: '学习洞察');
      case 'Achievements':
        return copy.t(en: title, zh: '成就');
      default:
        return title;
    }
  }

  String _localizedQuickLinkDescription(AppCopy copy, String description) {
    switch (description) {
      case 'Check the active stage and the next unlock condition.':
        return copy.t(en: description, zh: '查看当前阶段、下一步解锁条件和主线推进理由。');
      case 'See your weekly rhythm, streak, and explanation quality.':
        return copy.t(en: description, zh: '查看最近一周的学习节奏、连续性和表达质量。');
      case 'Review the milestones you unlocked and what is next.':
        return copy.t(en: description, zh: '回顾已经解锁的里程碑，并看看下一项成就还差什么。');
      default:
        return description;
    }
  }
}

class _LoopStatusTile extends StatelessWidget {
  const _LoopStatusTile({
    required this.label,
    required this.statusLabel,
    required this.isComplete,
  });

  final String label;
  final String statusLabel;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isComplete ? AppColors.surfaceMint : AppColors.surfaceBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(
              isComplete
                  ? Icons.check_circle_outline_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: textTheme.titleMedium)),
            Text(
              statusLabel,
              style: textTheme.labelLarge?.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String description;
  final String badgeLabel;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      subtitle: description,
      trailing: ProgressBadge(label: badgeLabel),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onTap,
          child: Text(actionLabel),
        ),
      ),
    );
  }
}
