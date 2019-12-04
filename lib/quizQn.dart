import 'package:flutter/material.dart';
import 'config.dart';

class QuizQn extends StatelessWidget {
  const QuizQn(
      {Key key, this.quizDetails, this.updateQuizScore, this.quizScore})
      : super(key: key);
  final Map quizDetails;
  final Function updateQuizScore;
  final int quizScore;

  Widget radioButtonWidget(int index, String header) {
    return Column(
      children: <Widget>[
        Container(
            constraints: BoxConstraints(minWidth: 70.0),
            child: Text(
              header,
              textAlign: TextAlign.center,
            )),
        Radio(
          value: index,
          groupValue: quizScore,
          onChanged: (value) {
            updateQuizScore(question: quizDetails['title'], value: value);
          },
        )
      ],
    );
  }

  List<Widget> _makeRadioButtons(List<Map> scaleHeaders) {
    return scaleHeaders.map<Widget>((Map scaleHeaders) {
      final index = scaleHeaders.keys.first;
      final header = scaleHeaders.values.first;
      return radioButtonWidget(index, header);
    }).toList();
  }

  Widget setOfRadioBtnWidget() {
    return Container(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                alignment: WrapAlignment.spaceEvenly,
                children: _makeRadioButtons(config['scaleHeaders']))));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text((quizDetails['index'] + 1).toString() +
                '.  ' +
                quizDetails['title']),
            contentPadding: EdgeInsets.all(20.0),
            subtitle: setOfRadioBtnWidget()));
  }
}
