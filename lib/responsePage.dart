import 'package:flutter/material.dart';
import 'appBar.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ResponsePage extends StatelessWidget {
  const ResponsePage({Key key, this.quizInfo}) : super(key: key);
  final Map quizInfo;

  ProcessQuiz processQuizInfo() => ProcessQuiz(quizInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar('Responses'),
        body: charts.PieChart(_createSampleData(), animate: false));
  }

  List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      LinearSales(0, 100),
      LinearSales(1, 75),
      LinearSales(2, 25),
      LinearSales(3, 5),
    ];

    return [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class ProcessQuiz {
  final Map quizInfo;

  ProcessQuiz(this.quizInfo);

  Map get quizResponses => quizInfo['responses'];
}
