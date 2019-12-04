import 'package:flutter/material.dart';
import 'package:quiz/quizCard.dart';
import 'appBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Quiz app'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome to the quizzes app!',
                      style: Theme.of(context).textTheme.display1,
                    ))),
            QuizCardContainer()
          ],
        ),
      ),
    );
  }
}
