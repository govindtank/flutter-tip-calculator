import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tip_calculator/main.dart';

void main() {
  testWidgets('Tip calculator app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await pumpApp(tester);

    // Verify the app title is shown
    expect(find.text('Tip Calculator'), findsOneWidget);
  });

  WidgetTester pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      const TipCalculatorApp(),
    );
    await tester.pumpAndSettle();
  }
}
