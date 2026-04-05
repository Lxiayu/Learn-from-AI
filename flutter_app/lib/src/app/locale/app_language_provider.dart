import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_language.dart';

final StateProvider<AppLanguage> appLanguageProvider =
    StateProvider<AppLanguage>((Ref ref) => AppLanguage.english);

