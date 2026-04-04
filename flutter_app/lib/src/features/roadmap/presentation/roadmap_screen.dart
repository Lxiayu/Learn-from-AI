import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/models/roadmap_models.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/status_message_card.dart';
import '../application/roadmap_progress_provider.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppCopy copy = context.copy;
    final RoadmapProgressState roadmap = ref.watch(roadmapProgressProvider);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppScaffoldShell(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[
                AppColors.surfaceBlue,
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
                ProgressBadge(label: copy.t(en: 'Your roadmap', zh: '你的路线图')),
                const SizedBox(height: 16),
                Text(
                  copy.t(en: roadmap.journeyTitle, zh: '量子物理基础'),
                  style: textTheme.displayLarge?.copyWith(fontSize: 36),
                ),
                const SizedBox(height: 10),
                Text(
                  copy.t(
                    en: 'This roadmap helps you keep the main path stable while still leaving room for deeper branches.',
                    zh: '这张路线图会帮你稳住主线，同时保留对延展分支的探索空间。',
                  ),
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryActionButton(
                    label: copy.t(en: 'Continue learning', zh: '继续学习'),
                    onPressed: () => context.go(roadmap.continueRoute),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        StatusMessageCard(
          title: copy.t(en: 'Current stage goal', zh: '当前阶段目标'),
          body: copy.t(
            en: roadmap.currentGoal,
            zh: '先把“观察到的现象”“解释方式”和“测量行为”之间的边界真正讲清楚。',
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Why this is next', zh: '为什么下一步是它'),
          subtitle: copy.t(
            en: 'The roadmap should explain sequencing, not just show it.',
            zh: '路线图不该只展示顺序，还要解释这个顺序为什么合理。',
          ),
          trailing: ProgressBadge(label: copy.t(en: 'Main path', zh: '主线')),
          child: Text(
            copy.t(
              en: roadmap.whyThisIsNext,
              zh: '因为你对“不确定性”的基础解释已经足够稳定，所以现在最值得做的是进入更深的比较阶段。',
            ),
            style: textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Journey milestones', zh: '阶段里程碑'),
          subtitle: copy.t(
            en: 'Each stage should reveal its state and unlock condition.',
            zh: '每个阶段都应该明确告诉你当前状态和解锁条件。',
          ),
          trailing: ProgressBadge(
            label: copy.t(
              en: '${roadmap.milestones.length} stages',
              zh: '${roadmap.milestones.length} 个阶段',
            ),
          ),
          child: Column(
            children: roadmap.milestones.asMap().entries.map((entry) {
              final int index = entry.key;
              final RoadmapMilestone milestone = entry.value;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == roadmap.milestones.length - 1 ? 0 : 14,
                ),
                child: _RoadmapMilestoneCard(
                  title: _localizedMilestoneTitle(copy, milestone.title),
                  detail: _localizedMilestoneDetail(copy, milestone.title),
                  statusLabel: _localizedStatus(copy, milestone.statusLabel),
                  unlockRequirement: _localizedUnlock(copy, milestone),
                  isActive: milestone.isActive,
                  isLocked: milestone.isLocked,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Saved branches', zh: '暂存分支'),
          subtitle: copy.t(
            en: 'Interesting side paths stay here until the main path is secure.',
            zh: '你感兴趣的延展方向会先收在这里，等主线稳住后再展开。',
          ),
          trailing: ProgressBadge(
            label: copy.t(
              en: '${roadmap.savedBranches.length} saved',
              zh: '${roadmap.savedBranches.length} 条已保存',
            ),
          ),
          child: Column(
            children: roadmap.savedBranches.map((SavedBranch branch) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SavedBranchTile(
                  title: _localizedBranchTitle(copy, branch.title),
                  reason: _localizedBranchReason(copy, branch.title),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Knowledge Graph View', zh: '知识图谱'),
          subtitle: copy.t(
            en: 'Open the network view when you want to inspect related concepts without leaving the roadmap context.',
            zh: '想看相关概念之间的网络关系时，可以从这里进入图谱，而不会丢掉当前路线语境。',
          ),
          trailing: ProgressBadge(label: copy.t(en: 'Interactive', zh: '可交互')),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/roadmap/graph'),
              child: Text(copy.t(en: 'Open Graph View', zh: '打开图谱')),
            ),
          ),
        ),
      ],
    );
  }

  String _localizedMilestoneTitle(AppCopy copy, String title) {
    switch (title) {
      case 'Foundation Systems':
        return copy.t(en: title, zh: '基础系统');
      case 'Patterns in Motion':
        return copy.t(en: title, zh: '模式演进');
      case 'Synthesis Studio':
        return copy.t(en: title, zh: '综合工作台');
      default:
        return title;
    }
  }

  String _localizedMilestoneDetail(AppCopy copy, String title) {
    switch (title) {
      case 'Foundation Systems':
        return copy.t(
          en: 'Clarify structure, intent, and constraints.',
          zh: '先把结构、目标和约束条件讲清楚。',
        );
      case 'Patterns in Motion':
        return copy.t(
          en: 'Compare multiple models against real trade-offs.',
          zh: '在真实权衡中比较不同模型与解释方式。',
        );
      case 'Synthesis Studio':
        return copy.t(
          en: 'Defend your own model with a clear rationale.',
          zh: '最后要能用清楚的理由捍卫你自己的理解框架。',
        );
      default:
        return title;
    }
  }

  String _localizedStatus(AppCopy copy, String status) {
    switch (status) {
      case 'In progress':
        return copy.t(en: status, zh: '进行中');
      case 'Up next':
        return copy.t(en: status, zh: '下一步');
      case 'Locked':
        return copy.t(en: status, zh: '未解锁');
      default:
        return status;
    }
  }

  String _localizedUnlock(AppCopy copy, RoadmapMilestone milestone) {
    final String english = milestone.unlockRequirement;
    if (milestone.title == 'Foundation Systems') {
      return copy.t(en: english, zh: '解锁条件：完成今天的比较阶段。');
    }
    if (milestone.title == 'Patterns in Motion') {
      return copy.t(en: english, zh: '解锁条件：完成两项复习并通过一次迁移提问。');
    }

    return copy.t(en: english, zh: '解锁条件：先完成前一个阶段。');
  }

  String _localizedBranchTitle(AppCopy copy, String title) {
    switch (title) {
      case 'Copenhagen interpretation':
        return copy.t(en: title, zh: '哥本哈根诠释');
      case 'Many-worlds view':
        return copy.t(en: title, zh: '多世界解释');
      default:
        return title;
    }
  }

  String _localizedBranchReason(AppCopy copy, String title) {
    switch (title) {
      case 'Copenhagen interpretation':
        return copy.t(
          en: 'Saved for later because it extends the current uncertainty discussion.',
          zh: '先保存起来，因为它正好能延展你当前关于“不确定性”的讨论。',
        );
      case 'Many-worlds view':
        return copy.t(
          en: 'Saved for later because it is useful after the measurement unit.',
          zh: '等你完成“测量”单元后，再看这条分支会更顺。',
        );
      default:
        return title;
    }
  }
}

class _RoadmapMilestoneCard extends StatelessWidget {
  const _RoadmapMilestoneCard({
    required this.title,
    required this.detail,
    required this.statusLabel,
    required this.unlockRequirement,
    required this.isActive,
    required this.isLocked,
  });

  final String title;
  final String detail;
  final String statusLabel;
  final String unlockRequirement;
  final bool isActive;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isLocked ? AppColors.surfaceMint : AppColors.surfaceBlue,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.outlineSoft,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text(title, style: textTheme.titleLarge)),
                ProgressBadge(label: statusLabel),
              ],
            ),
            const SizedBox(height: 10),
            Text(detail, style: textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              unlockRequirement,
              style: textTheme.labelLarge?.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedBranchTile extends StatelessWidget {
  const _SavedBranchTile({
    required this.title,
    required this.reason,
  });

  final String title;
  final String reason;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.outlineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(reason, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
