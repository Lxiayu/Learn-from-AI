import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/app/theme/app_theme.dart';
import 'package:flutter_app/src/features/roadmap/presentation/knowledge_graph_screen.dart';

void main() {
  testWidgets('knowledge graph view renders the selected node summary', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const KnowledgeGraphScreen(),
      ),
    );

    expect(find.text('Knowledge Graph View'), findsOneWidget);
    expect(find.text('Quantum Physics'), findsWidgets);
    expect(find.text('Currently Selected'), findsOneWidget);
  });
}
