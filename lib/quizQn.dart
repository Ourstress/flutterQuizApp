import 'package:flutter/material.dart';

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
  int qnNumber() => widget.quizDetails['index'];
  String scaleHeaders() => widget.quizDetails['scale'];

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

  List<Widget> _makeRadioButtons(String scaleHeaders) {
    return scaleHeaders.split(',').map<Widget>((String individualScale) {
      final RegExp pattern = RegExp(r"(?<scaleValue>\d+) - (?<scaleLabel>.*)");
      final RegExpMatch matches = pattern.firstMatch(individualScale);
      final index = int.parse(matches.namedGroup("scaleValue"));
      final header = matches.namedGroup("scaleLabel");
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
                children: _makeRadioButtons(scaleHeaders()))));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
        child: ListTile(
            title: Text((qnNumber() + 1).toString() + '.  ' + qnTitle()),
            contentPadding: EdgeInsets.all(20.0),
            subtitle: setOfRadioBtnWidget()));
  }

  @override
  bool get wantKeepAlive => true;
}
