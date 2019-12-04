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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              QuizQnContainer(
                  quizInfo: widget.quizInfo,
                  updateQuizScore: _updateQuizScore,
                  quizScore: _quizScore),
              RaisedButton(
                onPressed: () {
                  showAlertDialog(context, _quizScore.toString());
                },
                child: Text('Submit', style: TextStyle(fontSize: 20)),
              )
            ])));
  }
}

class QuizQnContainer extends StatelessWidget {
  const QuizQnContainer(
      {Key key, this.quizInfo, this.updateQuizScore, this.quizScore})
      : super(key: key);
  final Map quizInfo;
  final Map quizScore;
  final Function updateQuizScore;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: quizInfo['questions'].length,
            itemBuilder: (BuildContext context, int index) {
              final quizDetails = quizInfo['questions'][index];
              return quizQn(
                  quizDetails, updateQuizScore, quizScore[quizDetails]);
            }));
  }
}
