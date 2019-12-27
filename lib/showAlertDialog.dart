import 'package:flutter/material.dart';
import 'package:quiz/quizEdit.dart';
import 'firebaseModel.dart';
import 'package:provider/provider.dart';

class OkButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

showAlertDialog(BuildContext context, String type,
    {Map mapProps, String stringProps}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      if (type == 'alert') {
        return AlertDialog(
          title: Text("Your result"),
          content: Text(stringProps),
          actions: [
            OkButton(),
          ],
        );
      }
      if (type == 'editQuiz') {
        var linkFirestore = Provider.of<Fs>(context);
        return ChangeNotifierProvider.value(
            value: linkFirestore,
            child: AlertDialog(
              content:
                  QuizEditMode(key: UniqueKey(), quizQuestionInfo: mapProps),
              actions: [
                OkButton(),
              ],
            ));
      }
      return Container();
    },
  );
}
