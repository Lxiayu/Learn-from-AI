import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('app boots into Home', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Today'), findsOneWidget);
  });
}
