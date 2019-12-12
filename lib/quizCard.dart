import 'package:flutter/material.dart';
import 'config.dart';
import 'quizPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase/firestore.dart';
import 'firebaseModel.dart';

class QuizCardContainer extends StatelessWidget {
  void openQuizPage(context, quizQuestionInfo, [editMode = false]) {
    var linkFirestore = Provider.of<Fs>(context);
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return ChangeNotifierProvider.value(
          value: linkFirestore,
          child: QuizPage(quizInfo: quizQuestionInfo, editMode: editMode));
    }));
  }

  Widget quizCard(context, quizQuestionInfo) {
    return SizedBox(
        width: config['cardMaxWidth'],
        child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          InkWell(
              onTap: () => openQuizPage(context, quizQuestionInfo),
              child: ListTile(title: Text(quizQuestionInfo['title']))),
          if (Provider.of<Fa>(context).getUser != null)
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('EDIT'),
                  onPressed: () =>
                      openQuizPage(context, quizQuestionInfo, true),
                ),
              ],
            ),
        ])));
  }

  Widget wrapViewWidget(context, querySnapshot) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: querySnapshot.data.docs.map((snapshot) {
        Map quizInfo = snapshot.data();
        quizInfo['id'] = snapshot.id;
        return quizCard(context, quizInfo);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: StreamBuilder<QuerySnapshot>(
            stream:
                Provider.of<Fs>(context, listen: false).getQuizzes.onSnapshot,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> querySnapshot) {
              if (!querySnapshot.hasData) return LinearProgressIndicator();
              return wrapViewWidget(context, querySnapshot);
            }));
  }
}
