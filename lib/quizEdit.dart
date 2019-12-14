import 'package:flutter/material.dart';

class QuizQnEditMode extends StatefulWidget {
  QuizQnEditMode({Key key, this.quizDetails}) : super(key: key);
  final Map quizDetails;

  @override
  QuizQnEditModeState createState() {
    return QuizQnEditModeState();
  }
}

class QuizQnEditModeState extends State<QuizQnEditMode> {
  final _formKey = GlobalKey<FormState>();
  Map qnDetails() => widget.quizDetails;
  String qnTitle() => widget.quizDetails['title'];
  String qnType() => widget.quizDetails['type'];
  int qnNumber() => widget.quizDetails['index'];

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Card(
            child: ListTile(
                title: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Question ${qnNumber() + 1}',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value == qnTitle()) {
                      return 'No changes detected';
                    }
                    return null;
                  },
                  initialValue: qnTitle(),
                  minLines: 1,
                  maxLines: 3,
                ),
                trailing: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: Text('Save'),
                ))));
  }
}

class QuizEditMode extends StatefulWidget {
  QuizEditMode({Key key, this.quizQuestionInfo}) : super(key: key);
  final Map quizQuestionInfo;

  @override
  QuizEditModeState createState() {
    return QuizEditModeState();
  }
}

class QuizEditModeState extends State<QuizEditMode> {
  final _formKey = GlobalKey<FormState>();
  Map quizQuestionInfo() => widget.quizQuestionInfo;
  String quizTitle() => widget.quizQuestionInfo['title'];
  String quizDesc() => widget.quizQuestionInfo['desc'];

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Card(
            child: ListTile(
                title:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  TextFormField(
                    initialValue: quizTitle(),
                    decoration: InputDecoration(
                      labelText: 'Edit quiz title',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value == quizTitle()) {
                        return 'No changes detected';
                      }
                      return null;
                    },
                    minLines: 1,
                    maxLines: 2,
                  ),
                  TextFormField(
                    initialValue: quizDesc(),
                    decoration: InputDecoration(
                      labelText: 'Edit quiz description',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value == quizDesc()) {
                        return 'No changes detected';
                      }
                      return null;
                    },
                    minLines: 1,
                    maxLines: 3,
                  )
                ]),
                trailing: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: Text('Save'),
                ))));
  }
}
