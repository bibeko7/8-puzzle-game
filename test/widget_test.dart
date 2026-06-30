// Basic smoke test for the 8-puzzle app.
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle8/main.dart';

void main() {
  testWidgets('App launches and shows game screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PuzzleApp());
    await tester.pumpAndSettle();

    // Verify the app bar title renders.
    expect(find.text('8 Puzzle'), findsOneWidget);

    // Verify the level selector button is present.
    expect(find.textContaining('Level:'), findsOneWidget);
  });
}