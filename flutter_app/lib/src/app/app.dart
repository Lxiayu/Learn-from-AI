import 'package:flutter/material.dart';

import 'router/app_router.dart';

class LearnAiApp extends StatelessWidget {
  const LearnAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LearnAI',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF24389C)),
        useMaterial3: true,
      ),
    );
  }
}
