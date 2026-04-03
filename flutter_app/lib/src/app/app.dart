import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class LearnAiApp extends StatelessWidget {
  const LearnAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LearnAI',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: buildAppTheme(),
    );
  }
}
