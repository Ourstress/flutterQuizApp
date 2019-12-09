import 'package:flutter/material.dart';
import 'config.dart';
import 'quizPage.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'package:firebase/firestore.dart';

class QuizCardContainer extends StatelessWidget {
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
              return GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: querySnapshot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: config['cardMaxWidth'],
                      childAspectRatio: 1.5),
                  itemBuilder: (BuildContext context, int index) {
                    Map quizInfo = querySnapshot.data.docs[index].data();
                    quizInfo['id'] = querySnapshot.data.docs[index].id;
                    return Card(
                        child: InkWell(
                            onTap: () {
                              var linkFirestore = Provider.of<Fs>(context);
                              Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) {
                                return ChangeNotifierProvider.value(
                                    value: linkFirestore,
                                    child: QuizPage(quizInfo: quizInfo));
                              }));
                            },
                            child: ListTile(title: Text(quizInfo['title']))));
                  });
            }));
  }
}
