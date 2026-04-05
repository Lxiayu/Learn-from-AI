import 'package:flutter/material.dart';

enum AppLanguage {
  english(Locale('en')),
  chinese(Locale('zh', 'CN'));

  const AppLanguage(this.locale);

  final Locale locale;

  bool get isChinese => this == AppLanguage.chinese;
}

