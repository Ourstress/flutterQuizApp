import 'package:flutter/material.dart';
import 'config.dart';
import 'quizPage.dart';

class QuizCardContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: GridView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: config['mockQuiz'].length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: config['cardMaxWidth'],
                childAspectRatio: 1.5),
            itemBuilder: (BuildContext context, int index) {
              final quizInfo = config['mockQuiz'][index];
              return _buildQuizCards(quizInfo, context);
            }));
  }

  Widget _buildQuizCards(quizInfo, context) {
    void _openQuiz(quizInfo) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return QuizPage(quizInfo: quizInfo);
      }));
    }

    return Card(
        child: InkWell(
            onTap: () {
              _openQuiz(quizInfo);
            },
            child: ListTile(title: Text(quizInfo['title']))));
  }
}
