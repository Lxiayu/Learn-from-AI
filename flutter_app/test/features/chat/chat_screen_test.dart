import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/chat/presentation/chat_screen.dart';

void main() {
  testWidgets('Chat shows current topic, ai prompt, and input area', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const ChatScreen(),
      ),
    );

    expect(find.text('Current Topic'), findsOneWidget);
    expect(find.text('AI Prompt'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
