import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/chat/presentation/chat_screen.dart';

void main() {
  testWidgets('Chat matches the stitched inquiry layout', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const ChatScreen(),
      ),
    );

    expect(find.text('Current Inquiry'), findsOneWidget);
    expect(find.text('The Essence of Justice'), findsOneWidget);
    expect(find.textContaining('Socrates'), findsWidgets);
    expect(find.byType(TextField), findsOneWidget);
  });
}
