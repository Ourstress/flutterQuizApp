import 'package:flutter_test/flutter_test.dart';
import 'package:quiz/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that welcome message is on screen.
    expect(find.text('Welcome to the quizzes app!'), findsOneWidget);
  });
}
