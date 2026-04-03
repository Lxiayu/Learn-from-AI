import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('boots into Home with five bottom tabs', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Roadmap'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Socratic Chat'), findsOneWidget);
    expect(find.text('Profile & Analytics'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
