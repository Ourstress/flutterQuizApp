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

  Widget siteLandingView(BuildContext context) {
    return Flexible(
        child: Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.network('https://source.unsplash.com/random',
              fit: BoxFit.fill),
        ),
        Align(
            alignment: Alignment.center,
            child: Text(
              'Welcome to the quiz app!',
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .merge(TextStyle(backgroundColor: Colors.white70)),
              textAlign: TextAlign.center,
            ))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[siteLandingView(context), QuizCardContainer()],
      ),
    );
  }
}
