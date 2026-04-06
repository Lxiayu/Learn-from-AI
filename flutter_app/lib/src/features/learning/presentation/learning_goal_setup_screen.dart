import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/section_card.dart';
import '../data/learning_providers.dart';
import '../domain/learning_goal_setup_models.dart';

class LearningGoalSetupScreen extends ConsumerStatefulWidget {
  const LearningGoalSetupScreen({super.key});

  @override
  ConsumerState<LearningGoalSetupScreen> createState() =>
      _LearningGoalSetupScreenState();
}

class _LearningGoalSetupScreenState
    extends ConsumerState<LearningGoalSetupScreen> {
  late final TextEditingController _topicController;
  late final TextEditingController _targetOutcomeController;

  LearningCurrentLevel _currentLevel = LearningCurrentLevel.beginner;
  LearningStudyPace _studyPace = LearningStudyPace.steady;
  bool _evaluationPreference = false;
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _topicController = TextEditingController();
    _targetOutcomeController = TextEditingController();
  }

  @override
  void dispose() {
    _topicController.dispose();
    _targetOutcomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(copy.t(en: 'Learning setup', zh: '学习设置')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    copy.t(en: 'Start a guided learning path', zh: '开启引导式学习路径'),
                    style: textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    copy.t(
                      en:
                          'Set a learning direction, describe the outcome you want, and let LearnAI prepare a roadmap for confirmation.',
                      zh: '设定学习方向，说明你希望达到的结果，然后让 LearnAI 先为你准备一份待确认的学习路线。',
                    ),
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SectionCard(
                    title: copy.t(
                      en: 'What do you want to learn?',
                      zh: '你想学习什么？',
                    ),
                    subtitle: copy.t(
                      en:
                          'Choose a topic broad enough for a roadmap but narrow enough to stay actionable.',
                      zh: '主题要足够清晰，既能拆成路线，又不会过于宽泛而难以下手。',
                    ),
                    child: TextField(
                      controller: _topicController,
                      decoration: InputDecoration(
                        hintText: copy.t(
                          en: 'Example: Linear Algebra',
                          zh: '例如：线性代数',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionCard(
                    title: copy.t(en: 'Target outcome', zh: '目标结果'),
                    subtitle: copy.t(
                      en:
                          'Describe what you want to be able to explain, solve, or apply after learning.',
                      zh: '描述你学完后希望能够解释、解决或应用的结果。',
                    ),
                    child: TextField(
                      controller: _targetOutcomeController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: copy.t(
                          en:
                              'Example: Use vectors and matrices to solve medium problems.',
                          zh: '例如：能用向量和矩阵解决中等难度问题。',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final useColumns = constraints.maxWidth >= 720;
                      final levelCard = SectionCard(
                        title: copy.t(en: 'Current level', zh: '当前水平'),
                        subtitle: copy.t(
                          en: 'This helps LearnAI decide where to start.',
                          zh: '这能帮助 LearnAI 判断你的起点。',
                        ),
                        child: DropdownButtonFormField<LearningCurrentLevel>(
                          initialValue: _currentLevel,
                          items: LearningCurrentLevel.values
                              .map(
                                (level) => DropdownMenuItem(
                                  value: level,
                                  child: Text(_levelLabel(level)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _currentLevel = value);
                          },
                        ),
                      );
                      final paceCard = SectionCard(
                        title: copy.t(en: 'Study pace', zh: '学习节奏'),
                        subtitle: copy.t(
                          en:
                              'Choose the pace that should shape the roadmap rhythm.',
                          zh: '选择希望这条路线采用的推进节奏。',
                        ),
                        child: DropdownButtonFormField<LearningStudyPace>(
                          initialValue: _studyPace,
                          items: LearningStudyPace.values
                              .map(
                                (pace) => DropdownMenuItem(
                                  value: pace,
                                  child: Text(_paceLabel(pace)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _studyPace = value);
                          },
                        ),
                      );

                      if (!useColumns) {
                        return Column(
                          children: <Widget>[
                            levelCard,
                            const SizedBox(height: 16),
                            paceCard,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: levelCard),
                          const SizedBox(width: 16),
                          Expanded(child: paceCard),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SectionCard(
                    title: copy.t(en: 'Optional evaluation', zh: '可选评价'),
                    subtitle: copy.t(
                      en:
                          'Turn this on if you want LearnAI to summarize your mastery after each learning block.',
                      zh: '如果你希望每轮学习后由 LearnAI 生成掌握度总结，可以打开这个选项。',
                    ),
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _evaluationPreference,
                      title: Text(
                        copy.t(
                          en: 'Generate optional mastery summaries',
                          zh: '生成可选的掌握度总结',
                        ),
                      ),
                      subtitle: Text(
                        copy.t(
                          en:
                              'You can keep the learning flow lightweight and still enable evaluation later.',
                          zh: '你也可以先保持学习流程轻量，之后再开启评价功能。',
                        ),
                      ),
                      onChanged: (bool value) {
                        setState(() => _evaluationPreference = value);
                      },
                    ),
                  ),
                  if (_errorText != null) ...<Widget>[
                    const SizedBox(height: 16),
                    Text(
                      _errorText!,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryActionButton(
                      label: _isSubmitting
                          ? copy.t(en: 'Generating roadmap...', zh: '正在生成路线...')
                          : copy.t(en: 'Generate roadmap', zh: '生成学习路线'),
                      onPressed: _isSubmitting ? null : _handleSubmit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final topic = _topicController.text.trim();
    final targetOutcome = _targetOutcomeController.text.trim();
    if (topic.isEmpty || targetOutcome.isEmpty) {
      setState(() {
        _errorText = context.copy.t(
          en: 'Please complete both the topic and target outcome.',
          zh: '请同时填写学习主题和目标结果。',
        );
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      final draft = await ref.read(learningRepositoryProvider).createRoadmapDraft(
            LearningGoalSetupInput(
              topic: topic,
              targetOutcome: targetOutcome,
              currentLevel: _currentLevel,
              studyPace: _studyPace,
              evaluationPreference: _evaluationPreference,
            ),
          );
      if (!mounted) return;
      context.push('/learning-goal/preview', extra: draft);
    } catch (error) {
      setState(() {
        _errorText = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _levelLabel(LearningCurrentLevel level) {
    switch (level) {
      case LearningCurrentLevel.beginner:
        return context.copy.t(en: 'Beginner', zh: '初学者');
      case LearningCurrentLevel.intermediate:
        return context.copy.t(en: 'Intermediate', zh: '中级');
      case LearningCurrentLevel.advanced:
        return context.copy.t(en: 'Advanced', zh: '高级');
    }
  }

  String _paceLabel(LearningStudyPace pace) {
    switch (pace) {
      case LearningStudyPace.light:
        return context.copy.t(en: 'Light', zh: '轻量');
      case LearningStudyPace.steady:
        return context.copy.t(en: 'Steady', zh: '稳定');
      case LearningStudyPace.immersive:
        return context.copy.t(en: 'Immersive', zh: '沉浸');
    }
  }
}
