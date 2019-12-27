import 'package:flutter/material.dart';
import 'appBar.dart';
import 'quizQn.dart';
import 'resultCalc.dart';
import 'package:provider/provider.dart';
import 'package:quiz/showAlertDialog.dart';
import 'firebaseModel.dart';
import 'package:firebase/firestore.dart';
import 'quizEdit.dart';
import 'dataInputForm.dart';

const String reqInfoToSubmit =
    'Please help to provide us with some further information';

class QuizAnswers with ChangeNotifier {
  Map _quizScore = {};
  int _totalQuizQuestions = 0;

  void _updateQuizScore({String question, String questionType, int value}) {
    if (!_quizScore.containsKey(question)) {
      _quizScore[question] = {};
      _quizScore[question]['type'] = questionType;
    }
    _quizScore[question]['value'] = value;
  }

  void updateQuizQuestions({int numberOfQns}) {
    _totalQuizQuestions = numberOfQns;
  }

  Map get getQuizScore => _quizScore;
  int get getTotalQuizQns => _totalQuizQuestions;
}

class QuizPage extends StatelessWidget {
  const QuizPage({Key key, this.quizInfo, this.editMode}) : super(key: key);
  final Map quizInfo;
  final bool editMode;

  String getQuizTitle() => quizInfo['title'];

  void onSubmit(BuildContext context, Map quizDetails) {
    var answers = Provider.of<QuizAnswers>(context).getQuizScore;
    var totalQuestions =
        Provider.of<QuizAnswers>(context, listen: false).getTotalQuizQns;

    if (answers.length != totalQuestions) {
      return showAlertDialog(context, 'alert',
          stringProps: 'Please answer ALL the questions before submitting');
    } else {
      var linkFirestore = Provider.of<Fs>(context);
      showDialog(
          context: context,
          child: ChangeNotifierProvider.value(
              value: linkFirestore,
              child: AlertDialog(
                  title: Text(reqInfoToSubmit),
                  content: EmailGenderForm(
                      quizId: quizDetails['quizId'],
                      quizResults: calculateResults(answers)),
                  actions: [
                    FlatButton(
                        child: const Text('Exit'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ])));
    }
  }

  Widget quizQuestion(context, index, querySnapshot, quizDetails) {
    Widget singlequizQn = QuizQn(
        key: UniqueKey(),
        quizDetails: quizDetails,
        updateQuizScore:
            Provider.of<QuizAnswers>(context, listen: false)._updateQuizScore);
    if (index == 0 && index == querySnapshot.data.docs.length - 1) {
      return Column(
        children: <Widget>[
          Text(quizDetails['quizDesc'],
              style: Theme.of(context).textTheme.title),
          singlequizQn,
          RaisedButton(
            onPressed: () => onSubmit(context, quizDetails),
            child: Text('Submit', style: TextStyle(fontSize: 20)),
          ),
        ],
      );
    }
    if (index == 0) {
      return Column(
        children: <Widget>[
          Text(quizDetails['quizDesc'],
              style: Theme.of(context).textTheme.title),
          singlequizQn
        ],
      );
    }
    if (index == querySnapshot.data.docs.length - 1) {
      return Column(
        children: <Widget>[
          singlequizQn,
          RaisedButton(
            onPressed: () => onSubmit(context, quizDetails),
            child: Text('Submit', style: TextStyle(fontSize: 20)),
          ),
        ],
      );
    } else {
      return singlequizQn;
    }
  }

  Widget quizPageContents(
      BuildContext context, int index, querySnapshot, quizInfo) {
    final emptyQuizDetails = {
      'title': '',
      'type': '',
      'scale':
          '1 - Strongly disagree, 2 - Disagree, 3 - Neutral, 4 - Agree, 5 - Strongly agree',
      'id': '',
      'quiz': [],
      'index': index + 1,
      'quizDesc': quizInfo['desc'],
      'quizId': quizInfo['id']
    };
    if (querySnapshot.data.empty) {
      if (editMode == true) {
        return QuizQnEditMode(
          key: UniqueKey(),
          quizDetails: emptyQuizDetails,
        );
      } else {
        return Text('No questions here yet');
      }
    }
    final quizDetails = {
      'title': querySnapshot.data.docs[index].data()['title'],
      'type': querySnapshot.data.docs[index].data()['type'],
      'scale': querySnapshot.data.docs[index].data()['scale'],
      'quiz': querySnapshot.data.docs[index].data()['quiz'],
      'id': querySnapshot.data.docs[index].id,
      'index': index,
      'quizDesc': quizInfo['desc'],
      'quizId': quizInfo['id']
    };

    if (index == querySnapshot.data.docs.length - 1 && editMode == true) {
      return Column(
        children: <Widget>[
          QuizQnEditMode(
            key: UniqueKey(),
            quizDetails: quizDetails,
          ),
          QuizQnEditMode(
            key: UniqueKey(),
            quizDetails: emptyQuizDetails,
          ),
        ],
      );
    }
    if (editMode == true) {
      return QuizQnEditMode(
        key: UniqueKey(),
        quizDetails: quizDetails,
      );
    }
    return quizQuestion(context, index, querySnapshot, quizDetails);
  }

  Widget quizQnContainer(context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Provider.of<Fs>(context, listen: false)
            .getQuizQuestion(quizInfo['id'])
            .onSnapshot,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
          if (!querySnapshot.hasData) return LinearProgressIndicator();
          if (querySnapshot.data.empty) {
            return quizPageContents(context, -1, querySnapshot, quizInfo);
          }
          Provider.of<QuizAnswers>(context, listen: false)
              .updateQuizQuestions(numberOfQns: querySnapshot.data.docs.length);
          return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.0),
              itemCount: querySnapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) =>
                  quizPageContents(context, index, querySnapshot, quizInfo));
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
