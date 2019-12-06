import 'package:flutter/material.dart';
import 'config.dart';

class QuizQn extends StatefulWidget {
  QuizQn({Key key, this.quizDetails, this.updateQuizScore}) : super(key: key);
  final Map quizDetails;
  final Function updateQuizScore;

  @override
  QuizQnState createState() => QuizQnState();
}

class QuizQnState extends State<QuizQn> with AutomaticKeepAliveClientMixin {
  int radioGroupScore = -1;
  Map qnDetails() => widget.quizDetails;
  String qnTitle() => widget.quizDetails['title'];
  String qnType() => widget.quizDetails['type'];

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
          groupValue: radioGroupScore,
          onChanged: (value) {
            setState(() {
              radioGroupScore = value;
            });
            widget.updateQuizScore(
                question: qnTitle(), questionType: qnType(), value: value);
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
            title:
                Text((qnDetails()['index'] + 1).toString() + '.  ' + qnTitle()),
            contentPadding: EdgeInsets.all(20.0),
            subtitle: setOfRadioBtnWidget()));
  }

  @override
  bool get wantKeepAlive => true;
}
