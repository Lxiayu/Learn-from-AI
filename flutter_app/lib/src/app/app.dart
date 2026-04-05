import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale/app_language.dart';
import 'locale/app_language_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class LearnAiApp extends ConsumerWidget {
  const LearnAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLanguage language = ref.watch(appLanguageProvider);

    return MaterialApp.router(
      title: language.isChinese ? '学研 AI' : 'LearnAI',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      locale: language.locale,
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('zh', 'CN'),
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: buildAppTheme(language),
    );
  }
}
