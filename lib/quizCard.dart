import 'package:flutter/material.dart';
import 'config.dart';
import 'quizPage.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'package:firebase/firestore.dart';

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
    return Card(
        child: Column(children: <Widget>[
      InkWell(
          onTap: () => openQuizPage(context, quizQuestionInfo),
          child: ListTile(title: Text(quizQuestionInfo['title']))),
      if (Provider.of<Fa>(context).getUser != null)
        ButtonBar(
          children: <Widget>[
            FlatButton(
              child: const Text('EDIT'),
              onPressed: () => openQuizPage(context, quizQuestionInfo, true),
            ),
          ],
        ),
    ]));
  }

  Widget gridViewWidget(querySnapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: querySnapshot.data.docs.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: config['cardMaxWidth'], childAspectRatio: 1.2),
        itemBuilder: (BuildContext context, int index) {
          Map quizInfo = querySnapshot.data.docs[index].data();
          quizInfo['id'] = querySnapshot.data.docs[index].id;
          return quizCard(context, quizInfo);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: StreamBuilder<QuerySnapshot>(
            stream: Provider.of<Fs>(context, listen: false)
                .getStore
                .collection('testQuiz')
                .onSnapshot,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> querySnapshot) {
              if (!querySnapshot.hasData) return LinearProgressIndicator();
              return gridViewWidget(querySnapshot);
            }));
  }
}
