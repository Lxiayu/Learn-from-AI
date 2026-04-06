import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/ai_thinking_state_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/chat/presentation/focus_mode_screen.dart';
import '../../features/chat/presentation/multimodal_input_detail_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/learning/domain/learning_goal_setup_models.dart';
import '../../features/learning/presentation/learning_goal_setup_screen.dart';
import '../../features/learning/presentation/roadmap_draft_preview_screen.dart';
import '../../features/navigation/presentation/app_shell.dart';
import '../../features/profile/presentation/achievements_gallery_screen.dart';
import '../../features/profile/presentation/learning_insights_report_screen.dart';
import '../../features/profile/presentation/new_achievement_notification_screen.dart';
import '../../features/profile/presentation/profile_analytics_screen.dart';
import '../../features/review/presentation/mastery_quiz_screen.dart';
import '../../features/review/presentation/mistakes_mastered_celebration_screen.dart';
import '../../features/review/presentation/quiz_results_summary_screen.dart';
import '../../features/review/presentation/review_mistakes_detail_screen.dart';
import '../../features/review/presentation/review_screen.dart';
import '../../features/roadmap/presentation/knowledge_graph_screen.dart';
import '../../features/roadmap/presentation/roadmap_screen.dart';
import 'app_route_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AppShell(
          location: state.uri.toString(),
          child: child,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return buildAppPage<void>(
              key: state.pageKey,
              child: const HomeScreen(),
            );
          },
        ),
        GoRoute(
          path: '/roadmap',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return buildAppPage<void>(
              key: state.pageKey,
              child: const RoadmapScreen(),
            );
          },
        ),
        GoRoute(
          path: '/review',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return buildAppPage<void>(
              key: state.pageKey,
              child: const ReviewScreen(),
            );
          },
        ),
        GoRoute(
          path: '/chat',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return buildAppPage<void>(
              key: state.pageKey,
              child: const ChatScreen(),
            );
          },
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return buildAppPage<void>(
              key: state.pageKey,
              child: const ProfileAnalyticsScreen(),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/learning-goal/setup',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const LearningGoalSetupScreen(),
        );
      },
    ),
    GoRoute(
      path: '/learning-goal/preview',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final draft = state.extra as LearningRoadmapDraft;
        return buildAppPage<void>(
          key: state.pageKey,
          child: RoadmapDraftPreviewScreen(draft: draft),
        );
      },
    ),
    GoRoute(
      path: '/chat/focus',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const FocusModeScreen(),
        );
      },
    ),
    GoRoute(
      path: '/chat/thinking',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const AiThinkingStateScreen(),
        );
      },
    ),
    GoRoute(
      path: '/chat/multimodal',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const MultimodalInputDetailScreen(),
        );
      },
    ),
    GoRoute(
      path: '/review/quiz',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const MasteryQuizScreen(),
        );
      },
    ),
    GoRoute(
      path: '/review/results',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const QuizResultsSummaryScreen(),
        );
      },
    ),
    GoRoute(
      path: '/review/mistakes',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const ReviewMistakesDetailScreen(),
        );
      },
    ),
    GoRoute(
      path: '/review/celebration',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const MistakesMasteredCelebrationScreen(),
        );
      },
    ),
    GoRoute(
      path: '/roadmap/graph',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const KnowledgeGraphScreen(),
        );
      },
    ),
    GoRoute(
      path: '/profile/report',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const LearningInsightsReportScreen(),
        );
      },
    ),
    GoRoute(
      path: '/profile/achievements',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const AchievementsGalleryScreen(),
        );
      },
    ),
    GoRoute(
      path: '/profile/achievement-unlocked',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildAppPage<void>(
          key: state.pageKey,
          child: const NewAchievementNotificationScreen(),
        );
      },
    ),
  ],
);
