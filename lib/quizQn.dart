import 'package:flutter/material.dart';
import 'config.dart';

Widget quizQn(quizDetails, updateQuizScore, quizScore) {
  return Card(
      child: ListTile(
          title: Text(quizDetails),
          contentPadding: EdgeInsets.all(20.0),
          subtitle: Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        config['scaleHeaders'].map<Widget>((Map scaleHeaders) {
                      final index = scaleHeaders.keys.first;
                      final header = scaleHeaders.values.first;
                      return Flexible(
                          child: Column(
                        children: <Widget>[
                          Text(header),
                          Radio(
                            value: index,
                            groupValue: quizScore,
                            onChanged: (value) {
                              updateQuizScore(
                                  question: quizDetails, value: value);
                            },
                          )
                        ],
                      ));
                    }).toList(),
                  )))));
}
