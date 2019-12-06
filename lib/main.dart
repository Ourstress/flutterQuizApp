import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/quizCard.dart';
import 'appBar.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

void main() {
  if (fb.apps.length == 0) {
    fb.initializeApp(
        // fill in your own firebase config
        );
  }
  return runApp(MyApp());
}

class Fs with ChangeNotifier {
  Firestore store = fb.firestore();
  Firestore get getStore => store;
}

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
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.network('https://source.unsplash.com/random',
              fit: BoxFit.fill),
        ),
        Column(
          children: <Widget>[
            Flexible(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome to the quiz app!',
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .merge(TextStyle(backgroundColor: Colors.white70)),
                      textAlign: TextAlign.center,
                    ))),
            QuizCardContainer()
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(),
        body: ChangeNotifierProvider(
          create: (BuildContext context) => Fs(),
          child: siteLandingView(context),
        ));
  }
}
