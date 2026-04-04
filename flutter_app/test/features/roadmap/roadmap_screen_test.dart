import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/roadmap/presentation/roadmap_screen.dart';

void main() {
  testWidgets('Roadmap explains progress and saved branches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const RoadmapScreen(),
        ),
      ),
    );

    expect(find.text('Current stage goal'), findsOneWidget);
    expect(find.text('Why this is next'), findsOneWidget);
    expect(find.textContaining('Unlock by'), findsWidgets);
    expect(find.text('Saved branches'), findsOneWidget);
  });
}
