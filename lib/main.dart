import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/quizCard.dart';
import 'package:quiz/quizEdit.dart';
import 'appBar.dart';
import 'package:firebase/firebase.dart' as fb;
import 'secrets.dart';
import 'firebaseModel.dart';
import 'package:quiz/showAlertDialog.dart';

void main() {
  if (fb.apps.length == 0) {
    fb.initializeApp(
        apiKey: secrets['apiKey'],
        authDomain: secrets['authDomain'],
        databaseURL: secrets['databaseURL'],
        projectId: secrets['projectId'],
        storageBucket: secrets['storageBucket'],
        messagingSenderId: secrets['messagingSenderId'],
        appId: secrets['appId'],
        measurementId: secrets['measurementId']);
  }
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => Fs()),
        ChangeNotifierProvider(create: (context) => Fa()),
      ], child: MyHomePage(title: 'Quiz app')),
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
    var linkFirestore = Provider.of<Fs>(context);
    return Scaffold(
        appBar: myAppBar(),
        body: siteLandingView(context),
        floatingActionButton: Provider.of<Fa>(context).getUser != null
            ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return ChangeNotifierProvider.value(
                            value: linkFirestore,
                            child: AlertDialog(
                              content: QuizEditMode(
                                  key: UniqueKey(), quizQuestionInfo: {}),
                              actions: [
                                OkButton(),
                              ],
                            ));
                      });
                },
                tooltip: 'Add new quiz',
                child: Icon(Icons.add),
              )
            : null);
  }
}
