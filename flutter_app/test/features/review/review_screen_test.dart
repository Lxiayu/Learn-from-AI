import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/review/presentation/review_screen.dart';

void main() {
  testWidgets('Review matches the stitched review schedule layout', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const ReviewScreen(),
      ),
    );

    expect(find.text('Today\'s Focus'), findsOneWidget);
    expect(find.text('Ready to master'), findsOneWidget);
    expect(find.text('Review Roadmap'), findsOneWidget);
    expect(find.text('Active Topics'), findsOneWidget);
  });
}
