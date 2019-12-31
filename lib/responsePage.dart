import 'package:flutter/material.dart';
import 'appBar.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ResponsePage extends StatelessWidget {
  const ResponsePage({Key key, this.quizInfo}) : super(key: key);
  final Map quizInfo;

  ProcessQuiz processQuizInfo() => ProcessQuiz(quizInfo);

  @override
  Widget build(BuildContext context) {
    print(processQuizInfo().tabulateResponses);
    return Scaffold(
        appBar: myAppBar('Responses'),
        body: charts.PieChart(_createSampleData(),
            animate: false,
            defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: 60,
                arcRendererDecorators: [charts.ArcLabelDecorator()])));
  }

  List<charts.Series<TabulatedResponse, String>> _createSampleData() {
    final data = processQuizInfo().tabulateResponses;

    return [
      charts.Series<TabulatedResponse, String>(
        id: 'Sales',
        domainFn: (TabulatedResponse results, _) => results.type,
        measureFn: (TabulatedResponse results, _) => results.count,
        data: data,
        labelAccessorFn: (TabulatedResponse results, _) =>
            '${results.type}: ${results.count}',
      )
    ];
  }
}

class QuizResponse {
  final String gender;
  final Map results;
  final DateTime createdAt;

  QuizResponse(this.gender, this.results, this.createdAt);
}

class TabulatedResponse {
  final String type;
  final int count;

  TabulatedResponse(this.type, this.count);
}

class ProcessQuiz {
  final Map quizInfo;

  ProcessQuiz(this.quizInfo);

  List<QuizResponse> get quizResponses => quizInfo['responses']
      .values
      .map<QuizResponse>((elem) =>
          QuizResponse(elem['gender'], elem['results'], elem['createdAt']))
      .toList();

  List<TabulatedResponse> get tabulateResponses {
    Map tabulatedScores = {};
    for (QuizResponse response in quizResponses) {
      Map results = response.results;
      String answerType = results['outcome'];
      if (!tabulatedScores.containsKey(answerType)) {
        tabulatedScores[answerType] = 0;
      }
      tabulatedScores[answerType] += 1;
    }
    return tabulatedScores.keys
        .map((key) => TabulatedResponse(key, tabulatedScores[key]))
        .toList();
  }
}
