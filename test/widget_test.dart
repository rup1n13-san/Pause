import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app.locator.dart';
import 'package:mobile/main.dart';

void main() {
  setUpAll(() async {
    await setupLocator();
  });

  tearDown(() async {
    await locator.reset();
    await setupLocator();
  });

  testWidgets('MainApp boots without DI errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pump();

    // Basic sanity assertion: app renders a frame.
    expect(tester.takeException(), isNull);
  });
}
