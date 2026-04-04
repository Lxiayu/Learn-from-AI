import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('bottom navigation switches across all primary tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);

    await tester.tap(find.text('Roadmap'));
    await tester.pumpAndSettle();
    expect(find.text('Current Roadmap'), findsOneWidget);

    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
    expect(find.text('Review Schedule'), findsOneWidget);

    await tester.tap(find.text('Socratic Chat'));
    await tester.pumpAndSettle();
    expect(find.text('Current Topic'), findsOneWidget);

    await tester.tap(find.text('Profile & Analytics'));
    await tester.pumpAndSettle();
    expect(find.text('Learning Insights'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Achievements'), findsOneWidget);
  });
}
