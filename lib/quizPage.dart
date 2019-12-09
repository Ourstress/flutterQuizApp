import 'package:flutter/material.dart';
import 'appBar.dart';
import 'quizQn.dart';
import 'resultCalc.dart';
import 'showAlertDialog.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'package:firebase/firestore.dart';

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

  String getQuizTitle() => quizInfo['title'];

  Widget quizQnContainer(context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Provider.of<Fs>(context, listen: false)
            .getStore
            .collection('testQuestions')
            .where('quiz', 'array-contains', quizInfo['id'])
            .onSnapshot,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
          if (!querySnapshot.hasData) return LinearProgressIndicator();

          return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.0),
              itemCount: querySnapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final quizDetails = {
                  'title': querySnapshot.data.docs[index].data()['title'],
                  'type': querySnapshot.data.docs[index].data()['type'],
                  'index': index
                };
                Widget quizQuestion = QuizQn(
                    key: UniqueKey(),
                    quizDetails: quizDetails,
                    updateQuizScore:
                        Provider.of<QuizAnswers>(context, listen: false)
                            ._updateQuizScore);

                if (index == querySnapshot.data.docs.length - 1) {
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
                                calculateResults(
                                        quizAnswers.getQuizScore)['scores']
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
