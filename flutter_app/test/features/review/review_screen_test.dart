import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/review/presentation/review_screen.dart';

void main() {
  testWidgets('Review behaves like an executable review queue', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const ReviewScreen(),
        ),
      ),
    );

    expect(find.text('Due today'), findsOneWidget);
    expect(find.text('Up next'), findsOneWidget);
    expect(find.text('Completed today'), findsOneWidget);
    expect(find.textContaining('Review now because'), findsWidgets);
    expect(find.text('Mastery Quiz'), findsOneWidget);
  });
}
