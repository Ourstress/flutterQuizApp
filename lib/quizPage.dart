import 'package:flutter/material.dart';
import 'appBar.dart';
import 'quizQn.dart';
import 'resultCalc.dart';
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
      if (!_quizScore.containsKey(question)) {
        _quizScore[question] = {};
        _quizScore[question]['type'] = getTypeFromQn(question);
      }
      _quizScore[question]['value'] = value;
    });
  }

  List<Map<dynamic, dynamic>> getQuizQuestions() =>
      widget.quizInfo['questions'];

  String getTypeFromQn(question) {
    String interimValue = '';
    for (Map quizQn in getQuizQuestions()) {
      if (quizQn['title'] == question) {
        interimValue = quizQn['type'];
      }
    }
    return interimValue;
  }

  Widget quizQnContainer() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: getQuizQuestions().length,
        itemBuilder: (BuildContext context, int index) {
          final quizDetails = {
            'title': getQuizQuestions()[index]['title'],
            'index': index
          };
          Widget quizQuestion = QuizQn(
              quizDetails: quizDetails,
              updateQuizScore: _updateQuizScore,
              quizScore: _quizScore.containsKey(quizDetails['title'])
                  ? _quizScore[quizDetails['title']]['value']
                  : 0);
          if (index == getQuizQuestions().length - 1) {
            return Column(
              children: <Widget>[quizQuestion, submitButton()],
            );
          } else {
            return quizQuestion;
          }
        });
  }

  Widget submitButton() {
    return RaisedButton(
      onPressed: () {
        String results = 'Your result is ' +
            calculateResults(_quizScore)['outcome'] +
            ' and your scores are ' +
            calculateResults(_quizScore)['scores'].toString();
        showAlertDialog(context, results);
      },
      child: Text('Submit', style: TextStyle(fontSize: 20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: myAppBar(), body: quizQnContainer());
  }
}
