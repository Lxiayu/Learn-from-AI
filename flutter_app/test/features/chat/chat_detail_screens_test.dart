import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/chat/presentation/ai_thinking_state_screen.dart';
import 'package:flutter_app/src/features/chat/presentation/focus_mode_screen.dart';
import 'package:flutter_app/src/features/chat/presentation/multimodal_input_detail_screen.dart';

void main() {
  testWidgets('Focus mode matches the stitched prompt scene', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const FocusModeScreen(),
      ),
    );

    expect(find.text('Exit Focus'), findsOneWidget);
    expect(find.textContaining('Wavefunction'), findsOneWidget);
    expect(find.text('The Born Rule'), findsOneWidget);
  });

  testWidgets('AI thinking state shows synthesis feedback', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const AiThinkingStateScreen(),
      ),
    );

    expect(find.text('Socratic Dialogue'), findsOneWidget);
    expect(find.text('Synthesizing your previous answers...'), findsOneWidget);
    expect(find.textContaining('Stage 2 of 3'), findsOneWidget);
  });

  testWidgets('multimodal input detail exposes OCR and AI actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const MultimodalInputDetailScreen(),
      ),
    );

    expect(find.text('Cognitive Input'), findsOneWidget);
    expect(find.text('Extracted Text'), findsOneWidget);
    expect(find.text('Analyze with AI'), findsOneWidget);
  });
}
