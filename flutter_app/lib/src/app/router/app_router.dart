import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/navigation/presentation/app_shell.dart';

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
            return const _TabPlaceholder(
              title: 'Home',
              body: 'Today',
            );
          },
        ),
        GoRoute(
          path: '/roadmap',
          builder: (BuildContext context, GoRouterState state) {
            return const _TabPlaceholder(
              title: 'Roadmap',
              body: 'Current roadmap overview',
            );
          },
        ),
        GoRoute(
          path: '/review',
          builder: (BuildContext context, GoRouterState state) {
            return const _TabPlaceholder(
              title: 'Review',
              body: 'Today review queue',
            );
          },
        ),
        GoRoute(
          path: '/chat',
          builder: (BuildContext context, GoRouterState state) {
            return const _TabPlaceholder(
              title: 'Socratic Chat',
              body: 'Current topic',
            );
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) {
            return const _TabPlaceholder(
              title: 'Profile & Analytics',
              body: 'Learning summary',
            );
          },
        ),
      ],
    ),
  ],
);

class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(body),
      ),
    );
  }
}
