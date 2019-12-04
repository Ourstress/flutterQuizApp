import 'package:flutter/material.dart';
import 'appBar.dart';
import 'quizQn.dart';
import 'showAlertDialog.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key key, this.quizInfo}) : super(key: key);
  final Map quizInfo;

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  Map _quizScore = {};

  void _updateQuizScore({String question, int value}) {
    setState(() {
      _quizScore[question] = value;
    });
  }

  Widget quizQnContainer() {
    return Flexible(
        child: ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: widget.quizInfo['questions'].length,
            itemBuilder: (BuildContext context, int index) {
              final quizDetails = {
                'title': widget.quizInfo['questions'][index],
                'index': index
              };
              return QuizQn(
                  quizDetails: quizDetails,
                  updateQuizScore: _updateQuizScore,
                  quizScore: _quizScore[quizDetails['title']]);
            }));
  }

  Widget submitButton() {
    return RaisedButton(
      onPressed: () {
        showAlertDialog(context, _quizScore.toString());
      },
      child: Text('Submit', style: TextStyle(fontSize: 20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[quizQnContainer(), submitButton()])));
  }
}
