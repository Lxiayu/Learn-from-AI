import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/chat_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/navigation/presentation/app_shell.dart';
import '../../features/profile/presentation/profile_analytics_screen.dart';
import '../../features/review/presentation/review_screen.dart';
import '../../features/roadmap/presentation/roadmap_screen.dart';

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
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: '/roadmap',
          builder: (BuildContext context, GoRouterState state) {
            return const RoadmapScreen();
          },
        ),
        GoRoute(
          path: '/review',
          builder: (BuildContext context, GoRouterState state) {
            return const ReviewScreen();
          },
        ),
        GoRoute(
          path: '/chat',
          builder: (BuildContext context, GoRouterState state) {
            return const ChatScreen();
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileAnalyticsScreen();
          },
        ),
      ],
    ),
  ],
);
