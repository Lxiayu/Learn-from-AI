import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/layout/app_scaffold_shell.dart';
import '../../../shared/models/chat_session_models.dart';
import '../../../shared/widgets/context_action_chips.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/progress_badge.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/status_message_card.dart';
import '../../../shared/widgets/task_stage_stepper.dart';
import '../application/chat_session_controller.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = context.copy;
    final ChatSessionState session = ref.watch(chatSessionControllerProvider);
    final ChatSessionController notifier =
        ref.read(chatSessionControllerProvider.notifier);
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
                ProgressBadge(label: copy.t(en: 'Current inquiry', zh: '当前主学习')),
                const SizedBox(height: 16),
                Text(
                  copy.t(en: session.task.topic, zh: '正义的本质'),
                  style: textTheme.displayLarge?.copyWith(fontSize: 34),
                ),
                const SizedBox(height: 10),
                Text(
                  copy.t(
                    en: session.task.currentPrompt,
                    zh: '先解释“正义”和“服从”之间的差异，再逐步把这个定义变得更扎实。',
                  ),
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: session.questionIndex / session.totalQuestions,
                          minHeight: 9,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      copy.t(
                        en: 'Question ${session.questionIndex} / ${session.totalQuestions}',
                        zh: '第 ${session.questionIndex} / ${session.totalQuestions} 问',
                      ),
                      style: textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Current task', zh: '当前任务'),
          subtitle: copy.t(
            en: 'This turn should end with one clear idea and one concrete example.',
            zh: '这一轮的目标是把一个核心概念讲清楚，再补上一个具体例子。',
          ),
          trailing: ProgressBadge(
            label: copy.t(
              en: 'Stage: ${_stageLabel(copy, session.currentStage)}',
              zh: '阶段：${_stageLabel(copy, session.currentStage)}',
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                copy.t(
                  en: session.task.successSignal,
                  zh: '你需要先用自己的话定义这个概念，再给出一个别人也能理解的例子。',
                ),
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TaskStageStepper(
                steps: ChatPromptStage.values.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final ChatPromptStage stage = entry.value;
                  final int currentIndex = ChatPromptStage.values.indexOf(
                    session.currentStage,
                  );
                  return TaskStageStep(
                    label: _stageLabel(copy, stage),
                    isActive: stage == session.currentStage,
                    isComplete: index < currentIndex,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Dialogue canvas', zh: '对话画布'),
          subtitle: copy.t(
            en: 'Keep the thread moving from explanation to transfer.',
            zh: '让这一轮对话从“解释”逐步推进到“迁移”。',
          ),
          trailing: ProgressBadge(label: copy.t(en: 'Socratic mode', zh: '苏格拉底模式')),
          child: Column(
            children: session.messages.map((ChatMessage message) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChatBubble(
                  speaker: _speakerLabel(copy, message.role),
                  message: message.content,
                  accent: _messageAccent(message.role),
                  alignEnd: message.role == ChatMessageRole.learner,
                ),
              );
            }).toList(),
          ),
        ),
        if (session.helperFeedbackTitle != null &&
            session.helperFeedbackBody != null) ...<Widget>[
          const SizedBox(height: 16),
          StatusMessageCard(
            title: session.helperFeedbackTitle!,
            body: session.helperFeedbackBody!,
            tone: session.currentStage == ChatPromptStage.transfer
                ? StatusMessageTone.success
                : StatusMessageTone.info,
          ),
        ],
        const SizedBox(height: 16),
        SectionCard(
          title: copy.t(en: 'Shape your answer', zh: '组织你的回答'),
          subtitle: copy.t(
            en: 'Respond in your own words, then let the next prompt deepen it.',
            zh: '先用自己的话回答，再让下一轮问题把它进一步推深。',
          ),
          trailing: ProgressBadge(label: copy.t(en: 'Active response', zh: '主动表达')),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _controller,
                minLines: 5,
                maxLines: 7,
                onChanged: notifier.updateDraft,
                decoration: InputDecoration(
                  hintText: copy.t(
                    en: 'Describe the concept in your own words, then support it with one example...',
                    zh: '先用你自己的话解释这个概念，再补上一个能支持它的例子……',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: PrimaryActionButton(
                  label: copy.t(en: 'Send Reflection', zh: '提交思考'),
                  onPressed: () {
                    notifier.updateDraft(_controller.text);
                    notifier.submitDraft();
                    _controller.clear();
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ContextActionChips(
          items: <ContextActionChipItem>[
            ContextActionChipItem(
              label: copy.t(en: 'Give me a hint', zh: '提示一下'),
              icon: Icons.lightbulb_outline_rounded,
              onTap: notifier.requestHint,
            ),
            ContextActionChipItem(
              label: copy.t(en: 'Teach it another way', zh: '换个方式讲'),
              icon: Icons.swap_horiz_rounded,
              onTap: notifier.requestAlternateExplanation,
            ),
            ContextActionChipItem(
              label: copy.t(en: 'I still do not get it', zh: '我还是没懂'),
              icon: Icons.support_agent_rounded,
              onTap: notifier.markStillConfused,
            ),
            ContextActionChipItem(
              label: copy.t(en: 'Focus Mode', zh: '专注模式'),
              icon: Icons.center_focus_strong_rounded,
              onTap: () => context.push('/chat/focus'),
            ),
            ContextActionChipItem(
              label: copy.t(en: 'AI Thinking State', zh: 'AI 思考状态'),
              icon: Icons.psychology_alt_outlined,
              onTap: () => context.push('/chat/thinking'),
            ),
            ContextActionChipItem(
              label: copy.t(en: 'Multimodal Input', zh: '多模态输入'),
              icon: Icons.document_scanner_outlined,
              onTap: () => context.push('/chat/multimodal'),
            ),
          ],
        ),
      ],
    );
  }

  String _stageLabel(AppCopy copy, ChatPromptStage stage) {
    switch (stage) {
      case ChatPromptStage.explain:
        return copy.t(en: 'Explain', zh: '解释');
      case ChatPromptStage.example:
        return copy.t(en: 'Example', zh: '举例');
      case ChatPromptStage.compare:
        return copy.t(en: 'Compare', zh: '比较');
      case ChatPromptStage.transfer:
        return copy.t(en: 'Transfer', zh: '迁移');
    }
  }

  String _speakerLabel(AppCopy copy, ChatMessageRole role) {
    switch (role) {
      case ChatMessageRole.coach:
        return copy.t(en: 'AI Coach', zh: 'AI 导师');
      case ChatMessageRole.learner:
        return copy.t(en: 'You', zh: '你');
      case ChatMessageRole.system:
        return copy.t(en: 'System', zh: '系统');
    }
  }

  Color _messageAccent(ChatMessageRole role) {
    switch (role) {
      case ChatMessageRole.coach:
        return AppColors.surfaceWarm;
      case ChatMessageRole.learner:
        return AppColors.surfaceBlue;
      case ChatMessageRole.system:
        return AppColors.surfaceMint;
    }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.speaker,
    required this.message,
    required this.accent,
    required this.alignEnd,
  });

  final String speaker;
  final String message;
  final Color accent;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.outlineSoft),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  speaker,
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(message, style: textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
