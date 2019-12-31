import 'package:flutter/material.dart';
import 'firebaseModel.dart';
import 'package:provider/provider.dart';
import 'package:quiz/showAlertDialog.dart';

class EmailGenderForm extends StatefulWidget {
  const EmailGenderForm({Key key, this.quizId, this.quizResults})
      : super(key: key);
  final String quizId;
  final Map quizResults;

  @override
  EmailGenderFormState createState() {
    return EmailGenderFormState();
  }
}

class EmailGenderFormState extends State<EmailGenderForm> {
  final _formKey = GlobalKey<FormState>();
  String _gender = 'Female';
  String _email = '';
  String _results;

  void initState() {
    _results = 'Your result is ' +
        widget.quizResults['outcome'] +
        ' and your scores are ' +
        widget.quizResults['scores'].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Flexible(
              child: TextFormField(
            onSaved: (String value) => _email = value,
            decoration: InputDecoration(
              labelText:
                  'Please enter an NUS email. The results will also be emailed to you.',
            ),
            validator: (value) {
              RegExp pattern = RegExp(r"\S+@(\S+)?nus.edu.sg$");
              if (value.isEmpty || !pattern.hasMatch(value)) {
                return 'Please enter a valid NUS email address';
              }
              return null;
            },
          )),
          Flexible(
              child: DropdownButtonFormField<String>(
            value: _gender,
            decoration: InputDecoration(
              labelText: 'Please enter your gender',
            ),
            isExpanded: true,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String newValue) {
              setState(() {
                _gender = newValue;
              });
            },
            items: <String>['Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )),
          Flexible(
              child: RaisedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      Map quizResponse = {
                        'quizId': widget.quizId,
                        'results': widget.quizResults,
                        'email': _email,
                        'gender': _gender
                      };
                      Provider.of<Fs>(context, listen: false)
                          .updateQuizResponse(quizResponse);
                      Navigator.of(context).pop();
                      showAlertDialog(context, 'alert',
                          stringProps:
                              '$_results\n\nYour response has been submitted and your results will be emailed to you shortly');
                    }
                  }))
        ]));
  }
}
