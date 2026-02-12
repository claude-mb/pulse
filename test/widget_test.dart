// Basic smoke test for Pulse game app.

import 'package:flutter_test/flutter_test.dart';

import 'package:pulse_game/main.dart';

void main() {
  testWidgets('PulseApp renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const PulseApp());
    // App should render without throwing.
    expect(find.byType(PulseApp), findsOneWidget);
  });
}
