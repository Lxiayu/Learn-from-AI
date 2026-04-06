import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../shared/widgets/empty_state_card.dart';

class MissingLearningPlanState extends StatelessWidget {
  const MissingLearningPlanState({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;

    return EmptyStateCard(
      icon: Icons.route_rounded,
      title: copy.t(en: 'Create your learning plan', zh: '创建你的学习方案'),
      body: copy.t(
        en:
            'Start with a goal, let LearnAI draft a roadmap, then confirm it before your first session begins.',
        zh: '先设定学习目标，让 LearnAI 生成路线草案，再确认后进入第一轮学习。',
      ),
      actionLabel: copy.t(en: 'Start with a goal', zh: '从目标开始'),
      onAction: () => context.go('/learning-goal/setup'),
    );
  }
}
