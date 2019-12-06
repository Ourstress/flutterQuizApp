import 'package:flutter/material.dart';
import 'appBar.dart';
import 'quizQn.dart';
import 'resultCalc.dart';
import 'showAlertDialog.dart';
import 'package:provider/provider.dart';

class QuizAnswers with ChangeNotifier {
  Map _quizScore = {};

  void _updateQuizScore({String question, String questionType, int value}) {
    if (!_quizScore.containsKey(question)) {
      _quizScore[question] = {};
      _quizScore[question]['type'] = questionType;
    }
    _quizScore[question]['value'] = value;
  }

  Map get getQuizScore => _quizScore;
}

class QuizPage extends StatelessWidget {
  const QuizPage({Key key, this.quizInfo}) : super(key: key);
  final Map quizInfo;

  List<Map<dynamic, dynamic>> getQuizQuestions() => quizInfo['questions'];

  String getTypeFromQn(question) {
    String interimValue = '';
    for (Map quizQn in getQuizQuestions()) {
      if (quizQn['title'] == question) {
        interimValue = quizQn['type'];
      }
    }
    return interimValue;
  }

  String getQuizTitle() => quizInfo['quizTitle'];

  Widget quizQnContainer(context) {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        itemCount: getQuizQuestions().length,
        itemBuilder: (BuildContext context, int index) {
          final quizDetails = {
            'title': getQuizQuestions()[index]['title'],
            'type': getQuizQuestions()[index]['type'],
            'index': index
          };
          Widget quizQuestion = QuizQn(
              key: UniqueKey(),
              quizDetails: quizDetails,
              updateQuizScore: Provider.of<QuizAnswers>(context, listen: false)
                  ._updateQuizScore);

          if (index == getQuizQuestions().length - 1) {
            return Column(
              children: <Widget>[
                quizQuestion,
                Consumer<QuizAnswers>(
                  builder: (context, quizAnswers, child) => RaisedButton(
                    onPressed: () {
                      String results = 'Your result is ' +
                          calculateResults(
                              quizAnswers.getQuizScore)['outcome'] +
                          ' and your scores are ' +
                          calculateResults(quizAnswers.getQuizScore)['scores']
                              .toString();
                      showAlertDialog(context, results);
                    },
                    child: Text('Submit', style: TextStyle(fontSize: 20)),
                  ),
                )
              ],
            );
          } else {
            return quizQuestion;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(getQuizTitle()),
        body: ChangeNotifierProvider(
          child: quizQnContainer(context),
          create: (BuildContext context) => QuizAnswers(),
        ));
  }
}
