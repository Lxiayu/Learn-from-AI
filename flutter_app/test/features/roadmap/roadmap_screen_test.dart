import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/roadmap/presentation/roadmap_screen.dart';

void main() {
  testWidgets('Roadmap matches the stitched journey layout', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const RoadmapScreen(),
      ),
    );

    expect(find.text('Your Journey'), findsOneWidget);
    expect(find.text('Mastering Digital Architecture'), findsOneWidget);
    expect(find.text('CONTINUE LEARNING'), findsOneWidget);
  });
}
