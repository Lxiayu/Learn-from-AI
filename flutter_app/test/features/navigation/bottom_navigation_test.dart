import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('bottom navigation switches across all primary tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Good Morning, Alex!'), findsOneWidget);

    await tester.tap(find.text('Roadmap'));
    await tester.pumpAndSettle();
    expect(find.text('Current stage goal'), findsOneWidget);

    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
    expect(find.text('Due today'), findsOneWidget);

    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    expect(find.text('Current task'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Reminder time'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Today loop'), findsOneWidget);
  });
}
