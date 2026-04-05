import 'package:flutter/widgets.dart';

class AppCopy {
  const AppCopy._(this.locale);

  final Locale locale;

  bool get isChinese => locale.languageCode == 'zh';

  static AppCopy of(BuildContext context) {
    return AppCopy._(Localizations.localeOf(context));
  }

  String t({
    required String en,
    required String zh,
  }) {
    return isChinese ? zh : en;
  }
}

extension AppCopyContextX on BuildContext {
  AppCopy get copy => AppCopy.of(this);
}
