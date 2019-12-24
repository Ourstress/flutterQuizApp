import 'package:flutter/material.dart';
import 'showAlertDialog.dart';
import 'firebaseModel.dart';
import 'package:provider/provider.dart';

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
  String _qnTitle() => widget.quizDetails['title'];
  String _qnType() => widget.quizDetails['type'];
  String _qnScale() => widget.quizDetails['scale'];
  String _qnId() => widget.quizDetails['id'];
  int _qnNumber() => widget.quizDetails['index'];
  List _qnQuiz() => widget.quizDetails['quiz'];
  String _quizId() => widget.quizDetails['quizId'];
  Map _edits = {'title': '', 'classification': '', 'scale': ''};

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Card(
            child: ListTile(
          title: Column(
              children: [
            {'title': _qnTitle()},
            {'classification': _qnType()},
            {'scale': _qnScale()}
          ].map<Widget>((field) {
            return TextFormField(
              onSaved: (String value) => _edits[field.keys.first] = value,
              decoration: InputDecoration(
                labelText: 'Question ${_qnNumber() + 1} ${field.keys.first}',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              initialValue: field.values.first,
              minLines: 1,
              maxLines: 3,
            );
          }).toList()),
          trailing: RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                if (_edits['title'] == _qnTitle() &&
                    _edits['classification'] == _qnType() &&
                    _edits['scale'] == _qnScale()) {
                  showAlertDialog(context, 'alert',
                      stringProps: 'No changes detected');
                } else {
                  Map<String, dynamic> updatedQuizQnInfo = {
                    'title': _edits['title'],
                    'type': _edits['classification'],
                    'scale': _edits['scale'],
                    'quiz':
                        _qnQuiz().contains(_quizId) ? _qnQuiz() : [_quizId()]
                  };
                  _qnId() == ''
                      ? Provider.of<Fs>(context, listen: false)
                          .quizQnAdd(updatedQuizQnInfo)
                      : Provider.of<Fs>(context, listen: false)
                          .quizQnEdits(_qnId(), updatedQuizQnInfo);
                  showAlertDialog(context, 'alert',
                      stringProps: 'Changes saved');
                }
              }
            },
            child: Text('Save'),
          ),
          leading: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => showDialog(
                  context: context,
                  child: AlertDialog(
                      title: Text("Confirm delete?"),
                      content: Text("Deletion is irreversible!"),
                      actions: [
                        FlatButton(
                            child: const Text('DELETE'),
                            onPressed: () {
                              Provider.of<Fs>(context, listen: false)
                                  .quizQnDelete(_qnId());
                              Navigator.of(context).pop();
                            }),
                      ]))),
        )));
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
  String _quizTitle() => widget.quizQuestionInfo['title'];
  String _quizDesc() => widget.quizQuestionInfo['desc'];
  String _quizId() => widget.quizQuestionInfo['id'];
  String _titleEdits;
  String _descEdits;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            constraints: BoxConstraints(minWidth: 300),
            child: Card(
                child: ListTile(
                    title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            onSaved: (String value) => _titleEdits = value,
                            initialValue: _quizTitle(),
                            decoration: InputDecoration(
                              labelText: 'Edit quiz title',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            minLines: 1,
                            maxLines: 2,
                          ),
                          TextFormField(
                            onSaved: (String value) => _descEdits = value,
                            initialValue: _quizDesc(),
                            decoration: InputDecoration(
                              labelText: 'Edit quiz description',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
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
                          _formKey.currentState.save();
                          if (_titleEdits == _quizTitle() &&
                              _descEdits == _quizDesc()) {
                            showAlertDialog(context, 'alert',
                                stringProps: 'No changes detected');
                          } else {
                            Provider.of<Fs>(context, listen: false)
                                .quizInfoEdits(_quizId(),
                                    {'title': _titleEdits, 'desc': _descEdits});
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Save'),
                    )))));
  }
}
