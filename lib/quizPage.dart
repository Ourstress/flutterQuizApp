import 'package:flutter/material.dart';
import 'appBar.dart';
import 'quizQn.dart';
import 'resultCalc.dart';
import 'showAlertDialog.dart';
import 'package:provider/provider.dart';
import 'firebaseModel.dart';
import 'package:firebase/firestore.dart';
import 'quizEdit.dart';

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
  const QuizPage({Key key, this.quizInfo, this.editMode}) : super(key: key);
  final Map quizInfo;
  final bool editMode;

  String getQuizTitle() => quizInfo['title'];

  void onSubmit(context) {
    var answers = Provider.of<QuizAnswers>(context).getQuizScore;
    String results = 'Your result is ' +
        calculateResults(answers)['outcome'] +
        ' and your scores are ' +
        calculateResults(answers)['scores'].toString();
    showAlertDialog(context, 'alert', stringProps: results);
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
            onPressed: () => onSubmit(context),
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
            onPressed: () => onSubmit(context),
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
    final quizDetails = {
      'title': querySnapshot.data.docs[index].data()['title'],
      'type': querySnapshot.data.docs[index].data()['type'],
      'scaleHeaders': querySnapshot.data.docs[index].data()['scale'],
      'index': index,
      'quizDesc': quizInfo['desc']
    };
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
