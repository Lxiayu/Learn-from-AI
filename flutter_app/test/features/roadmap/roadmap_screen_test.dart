import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/roadmap/presentation/roadmap_screen.dart';

void main() {
  testWidgets('Roadmap shows stages and start-learning action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const RoadmapScreen(),
      ),
    );

    expect(find.text('Current Roadmap'), findsOneWidget);
    expect(find.text('Start This Node'), findsOneWidget);
  });
}
