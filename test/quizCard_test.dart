import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz/quizCard.dart';

void main() {
  testWidgets('Quiz card looks as expected', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: Column(children: <Widget>[QuizCardContainer()]))));

    // Verify that title of quiz is on screen.
    expect(find.text('maths 101'), findsOneWidget);

    // Tap the card and trigger a frame.
    await tester.tap(find.text('maths 101'));
    await tester.pump();
  });
}
