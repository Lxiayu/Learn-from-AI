import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/locale/app_copy.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/section_card.dart';
import '../../chat/application/chat_session_controller.dart';
import '../../home/application/home_dashboard_provider.dart';
import '../../review/application/review_queue_provider.dart';
import '../../roadmap/application/roadmap_progress_provider.dart';
import '../data/learning_providers.dart';
import '../domain/learning_goal_setup_models.dart';

class RoadmapDraftPreviewScreen extends ConsumerStatefulWidget {
  const RoadmapDraftPreviewScreen({
    super.key,
    required this.draft,
  });

  final LearningRoadmapDraft draft;

  @override
  ConsumerState<RoadmapDraftPreviewScreen> createState() =>
      _RoadmapDraftPreviewScreenState();
}

class _RoadmapDraftPreviewScreenState
    extends ConsumerState<RoadmapDraftPreviewScreen> {
  bool _isConfirming = false;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(copy.t(en: 'Roadmap preview', zh: '路线预览')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.draft.title, style: textTheme.displaySmall),
                  const SizedBox(height: 12),
                  Text(
                    widget.draft.summary,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    copy.t(
                      en:
                          '${widget.draft.estimatedDurationMinutes} minutes suggested',
                      zh: '建议总时长 ${widget.draft.estimatedDurationMinutes} 分钟',
                    ),
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...widget.draft.stages.map((stage) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SectionCard(
                        title: stage.title,
                        subtitle: copy.t(
                          en: 'Stage ${stage.orderIndex}',
                          zh: '阶段 ${stage.orderIndex}',
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(stage.objective, style: textTheme.bodyMedium),
                            const SizedBox(height: 12),
                            Text(
                              stage.completionCriteria,
                              style: textTheme.labelLarge?.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  if (_errorText != null) ...<Widget>[
                    const SizedBox(height: 12),
                    Text(
                      _errorText!,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryActionButton(
                      label: _isConfirming
                          ? copy.t(en: 'Starting learning...', zh: '正在开始学习...')
                          : copy.t(
                              en: 'Confirm and start learning',
                              zh: '确认并开始学习',
                            ),
                      onPressed: _isConfirming ? null : _handleConfirm,
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

  Future<void> _handleConfirm() async {
    setState(() {
      _isConfirming = true;
      _errorText = null;
    });

    try {
      await ref
          .read(learningRepositoryProvider)
          .confirmRoadmapDraft(widget.draft.roadmapId);
      ref.invalidate(homeDashboardProvider);
      ref.invalidate(roadmapProgressProvider);
      ref.invalidate(reviewQueueProvider);
      ref.invalidate(chatSessionControllerProvider);
      if (!mounted) return;
      context.go('/chat');
    } catch (error) {
      setState(() {
        _errorText = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isConfirming = false;
        });
      }
    }
  }
}
