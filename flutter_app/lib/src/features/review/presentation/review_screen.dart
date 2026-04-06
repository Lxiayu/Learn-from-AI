import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/models/review_models.dart';
import '../../../shared/widgets/empty_state_card.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/status_message_card.dart';
import '../../learning/data/learning_repository.dart';
import '../../learning/presentation/missing_learning_plan_state.dart';
import '../application/review_queue_provider.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({
    super.key,
    this.showSessionWrapUpBanner = false,
    this.generatedReviewCount,
  });

  final bool showSessionWrapUpBanner;
  final int? generatedReviewCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppCopy copy = context.copy;
    final AsyncValue<ReviewQueueState> queueAsync = ref.watch(reviewQueueProvider);
    final ReviewQueueNotifier notifier = ref.read(reviewQueueProvider.notifier);
    
    return queueAsync.when(
      data: (ReviewQueueState queue) {
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
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProgressBadge(label: copy.t(en: 'Today review', zh: '今日复习')),
                const SizedBox(height: 16),
                Text(
                  copy.t(en: 'Review what is fading', zh: '复习正在淡忘的内容'),
                  style: textTheme.displayLarge?.copyWith(fontSize: 34),
                ),
                const SizedBox(height: 10),
                Text(
                  copy.t(
                    en: 'Today is about recall quality, not volume. Clear the urgent items first, then use a quiz or mistake review to reinforce the weak edges.',
                    zh: '今天追求的是回忆质量，而不是数量。先清掉最紧急的复习项，再用测验或错题复盘把薄弱边界补强。',
                  ),
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        StatusMessageCard(
          title: copy.t(en: 'Why these reviews matter now', zh: '为什么现在该复习这些'),
          body: copy.t(
            en: 'The queue is ordered by forgetting risk and conceptual instability, so finishing the first items will raise the quality of your next inquiry.',
            zh: '这个队列按遗忘风险和概念不稳程度排序。优先完成前面的项目，会明显提升你下一轮主学习的质量。',
          ),
        ),
        if (showSessionWrapUpBanner) ...<Widget>[
          const SizedBox(height: 16),
          StatusMessageCard(
            title: copy.t(en: 'Session wrapped up', zh: '本轮学习已收束'),
            body: copy.t(
              en:
                  'You closed the main inquiry and generated ${generatedReviewCount ?? queue.dueToday.length} review tasks to stabilize what you just learned.',
              zh:
                  '你已经完成了这一轮主学习，并生成了 ${generatedReviewCount ?? queue.dueToday.length} 个复习任务，用来稳住刚学到的内容。',
            ),
            tone: StatusMessageTone.success,
          ),
        ],
        const SizedBox(height: 16),
        _QueueSection(
          title: copy.t(en: 'Due today', zh: '今天必须复习'),
          subtitle: copy.t(
            en: 'These are in the ideal recall window right now.',
            zh: '这些内容正处在最合适的回忆窗口。',
          ),
          trailing: ProgressBadge(
            label: copy.t(
              en: '${queue.dueToday.length} urgent',
              zh: '${queue.dueToday.length} 个紧急项',
            ),
          ),
          child: queue.dueToday.isEmpty
              ? EmptyStateCard(
                  icon: Icons.done_all_rounded,
                  title: copy.t(en: 'Nothing urgent left', zh: '紧急复习已经清空'),
                  body: copy.t(
                    en: 'You can move to the quiz or glance at what is coming next.',
                    zh: '你可以继续做测验，或者提前看一下后续要进入的复习项。',
                  ),
                )
              : Column(
                  children: queue.dueToday
                      .map(
                        (ReviewQueueItem item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ReviewQueueItemCard(
                            title: _localizedTitle(copy, item),
                            detail: _localizedDetail(copy, item),
                            reason: _localizedReason(copy, item),
                            dueLabel: _localizedDueLabel(copy, item.dueLabel),
                            buttonLabel:
                                copy.t(en: 'Mark reviewed', zh: '标记已复习'),
                            onPressed: () => notifier.completeItem(item.id),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
        const SizedBox(height: 16),
        _QueueSection(
          title: copy.t(en: 'Up next', zh: '接下来'),
          subtitle: copy.t(
            en: 'These will be useful soon, but they do not outrank today’s urgent items.',
            zh: '这些内容很快就会进入复习窗口，但目前不优先于今天的紧急项。',
          ),
          trailing: ProgressBadge(
            label: copy.t(
              en: '${queue.upNext.length} queued',
              zh: '${queue.upNext.length} 个待进入',
            ),
          ),
          child: queue.upNext.isEmpty
              ? EmptyStateCard(
                  icon: Icons.schedule_rounded,
                  title: copy.t(en: 'Nothing queued next', zh: '后续队列暂时为空'),
                  body: copy.t(
                    en: 'As you continue learning, new review tasks will appear here.',
                    zh: '随着你继续学习，新的复习任务会出现在这里。',
                  ),
                )
              : Column(
                  children: queue.upNext
                      .map(
                        (ReviewQueueItem item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ReviewQueueItemCard(
                            title: _localizedTitle(copy, item),
                            detail: _localizedDetail(copy, item),
                            reason: _localizedReason(copy, item),
                            dueLabel: _localizedDueLabel(copy, item.dueLabel),
                            buttonLabel:
                                copy.t(en: 'Open quiz', zh: '去做测验'),
                            onPressed: () => context.push('/review/quiz'),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
        const SizedBox(height: 16),
        _QueueSection(
          title: copy.t(en: 'Completed today', zh: '今日已完成'),
          subtitle: copy.t(
            en: 'A visible record of what you already stabilized today.',
            zh: '用一份看得见的记录，提醒你今天已经稳住了哪些内容。',
          ),
          trailing: ProgressBadge(
            label: copy.t(
              en: '${queue.completedToday.length} closed',
              zh: '${queue.completedToday.length} 个已完成',
            ),
          ),
          child: queue.completedToday.isEmpty
              ? EmptyStateCard(
                  icon: Icons.auto_graph_rounded,
                  title: copy.t(en: 'Nothing completed yet', zh: '还没有完成的复习项'),
                  body: copy.t(
                    en: 'Finish your first due item and it will appear here.',
                    zh: '先完成第一个到期项，完成记录就会出现在这里。',
                  ),
                )
              : Column(
                  children: queue.completedToday
                      .map(
                        (ReviewQueueItem item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CompletedReviewCard(
                            title: _localizedTitle(copy, item),
                            detail: _localizedDetail(copy, item),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool useColumns = constraints.maxWidth >= 860;
            final Widget quizCard = SectionCard(
              title: copy.t(en: 'Mastery Quiz', zh: '掌握度测验'),
              subtitle: copy.t(
                en: 'Use a harder prompt set to verify whether the ideas are holding.',
                zh: '用一组更难的问题检查这些概念是不是真的稳住了。',
              ),
              trailing: ProgressBadge(label: copy.t(en: 'Ready', zh: '可开始')),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/review/quiz'),
                  child: Text(copy.t(en: 'Open Quiz', zh: '开始测验')),
                ),
              ),
            );

            final Widget mistakeCard = SectionCard(
              title: copy.t(en: 'Review Mistakes', zh: '错题复盘'),
              subtitle: copy.t(
                en: 'Turn weak answers into more precise explanations.',
                zh: '把薄弱回答变成更清晰、更准确的解释。',
              ),
              trailing:
                  ProgressBadge(label: copy.t(en: 'Coach ready', zh: '可进入')),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/review/mistakes'),
                      child: Text(copy.t(en: 'Open Mistakes', zh: '查看错题')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/review/results'),
                      child: Text(copy.t(en: 'View Results', zh: '查看结果')),
                    ),
                  ),
                ],
              ),
            );

            if (!useColumns) {
              return Column(
                children: <Widget>[
                  quizCard,
                  const SizedBox(height: 16),
                  mistakeCard,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: quizCard),
                const SizedBox(width: 16),
                Expanded(child: mistakeCard),
              ],
            );
          },
        ),
          ],
        );
      },
      loading: () => AppScaffoldShell(
        children: <Widget>[
          SectionCard(
            title: copy.t(en: 'Loading review queue', zh: '正在加载复习队列'),
            subtitle: copy.t(
              en: 'We are checking what is fading first and what can wait.',
              zh: '正在判断哪些内容最先需要复习，哪些内容还可以稍后处理。',
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
              en: 'The review queue could not load',
              zh: '复习队列暂时加载失败',
            ),
            body: copy.t(
              en: 'Check whether the local backend is running before you retry.',
              zh: '请先确认本地后端已经启动，再重新尝试。',
            ),
            tone: StatusMessageTone.warning,
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: copy.t(en: 'Error details', zh: '错误详情'),
            subtitle: copy.t(
              en: 'Shown here to simplify local debugging.',
              zh: '这里展示错误详情，方便本地联调。',
            ),
            child: SelectableText(error.toString()),
          ),
          ],
        ],
      ),
    );
  }

  String _localizedTitle(AppCopy copy, ReviewQueueItem item) {
    switch (item.id) {
      case 'wave-particle-duality':
        return copy.t(en: item.title, zh: '波粒二象性');
      case 'observer-effect':
        return copy.t(en: item.title, zh: '观察者效应');
      case 'uncertainty-principle':
        return copy.t(en: item.title, zh: '不确定性原理');
      case 'photoelectric-effect':
        return copy.t(en: item.title, zh: '光电效应');
      default:
        return item.title;
    }
  }

  String _localizedDetail(AppCopy copy, ReviewQueueItem item) {
    switch (item.id) {
      case 'wave-particle-duality':
        return copy.t(en: item.detail, zh: '你还需要一个更清晰的类比来解释它。');
      case 'observer-effect':
        return copy.t(en: item.detail, zh: '需要把它与“测量”本身更清楚地区分开。');
      case 'uncertainty-principle':
        return copy.t(en: item.detail, zh: '明天再回忆一次，这个概念边界会更稳。');
      case 'photoelectric-effect':
        return copy.t(en: item.detail, zh: '你已经能把它和能量量子联系起来了。');
      default:
        return item.detail;
    }
  }

  String _localizedReason(AppCopy copy, ReviewQueueItem item) {
    switch (item.id) {
      case 'wave-particle-duality':
        return copy.t(
          en: item.reason,
          zh: '现在复习，因为你上一次的解释还比较模糊。',
        );
      case 'observer-effect':
        return copy.t(
          en: item.reason,
          zh: '现在复习，因为你昨天晚上已经开始混淆它和“测量”。',
        );
      case 'uncertainty-principle':
        return copy.t(
          en: item.reason,
          zh: '接下来轮到它，因为它快进入最佳复习窗口了。',
        );
      case 'photoelectric-effect':
        return copy.t(
          en: item.reason,
          zh: '今天已经完成，而且回忆质量不错。',
        );
      default:
        return item.reason;
    }
  }

  String _localizedDueLabel(AppCopy copy, String dueLabel) {
    switch (dueLabel) {
      case 'Due now':
        return copy.t(en: dueLabel, zh: '现在');
      case 'Today':
        return copy.t(en: dueLabel, zh: '今天');
      case 'Tomorrow':
        return copy.t(en: dueLabel, zh: '明天');
      case 'Done':
        return copy.t(en: dueLabel, zh: '已完成');
      default:
        return dueLabel;
    }
  }
}

class _QueueSection extends StatelessWidget {
  const _QueueSection({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      child: child,
    );
  }
}

class _ReviewQueueItemCard extends StatelessWidget {
  const _ReviewQueueItemCard({
    required this.title,
    required this.detail,
    required this.reason,
    required this.dueLabel,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String detail;
  final String reason;
  final String dueLabel;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceBlue,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text(title, style: textTheme.titleMedium)),
                ProgressBadge(label: dueLabel),
              ],
            ),
            const SizedBox(height: 8),
            Text(detail, style: textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              reason,
              style: textTheme.labelLarge?.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onPressed,
                child: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedReviewCard extends StatelessWidget {
  const _CompletedReviewCard({
    required this.title,
    required this.detail,
  });

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMint,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(Icons.check_circle_outline_rounded, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(detail, style: textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
