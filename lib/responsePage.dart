import 'package:flutter/material.dart';
import 'appBar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

class SelectedCategory with ChangeNotifier {
  String selectedCategory = 'all';
  String get getSelectedCategory => selectedCategory;
  void setSelectedCategory(int value) {
    if (value == 1) {
      selectedCategory = 'all';
    } else if (value == 2) {
      selectedCategory = 'gender';
    }
    notifyListeners();
  }
}

class ResponsePage extends StatelessWidget {
  const ResponsePage({Key key, this.quizInfo}) : super(key: key);
  final Map quizInfo;

  ProcessQuiz processQuizInfo() => ProcessQuiz(quizInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar('Responses'),
        body: ChangeNotifierProvider(
            create: (BuildContext context) => SelectedCategory(),
            child: ChartWidget(quizInfo: processQuizInfo())));
  }
}

class ChartWidget extends StatelessWidget {
  final ProcessQuiz quizInfo;
  const ChartWidget({Key key, this.quizInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
              alignment: Alignment.center,
              child: Text('Quiz responses',
                  style: Theme.of(context).textTheme.display1)),
        ),
        Flexible(
            flex: 4,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListTile(
                    leading: SizedBox(width: 100.0, child: DropdownSelect()),
                    title: Text('Toggle fields'),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: _createBarChart(quizInfo.tabulateResponses(
                      Provider.of<SelectedCategory>(context)
                          .getSelectedCategory)),
                )
              ],
            ))
      ],
    );
  }
}

class DropdownSelect extends StatefulWidget {
  DropdownSelectState createState() => DropdownSelectState();
}

class DropdownSelectState extends State<DropdownSelect> {
  int selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      onChanged: (value) => setState(() {
        selectedValue = value;
        Provider.of<SelectedCategory>(context, listen: false)
            .setSelectedCategory(value);
      }),
      decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
      value: selectedValue,
      items: <DropdownMenuItem<int>>[
        DropdownMenuItem<int>(
          value: 1,
          child: Text("All"),
        ),
        DropdownMenuItem<int>(
          value: 2,
          child: Text("By gender"),
        ),
      ],
    );
  }
}

charts.BarChart _createBarChart(data) => charts.BarChart(
      _createChartData(data),
      animate: false,
      barGroupingType: charts.BarGroupingType.grouped,
      primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
      secondaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
    );

// charts.PieChart _createPieChart(data) => charts.PieChart(_createChartData(data),
//     animate: false,
//     defaultRenderer: new charts.ArcRendererConfig(
//         arcWidth: 60, arcRendererDecorators: [charts.ArcLabelDecorator()]));

List<charts.Series<TabulatedResponse, String>> _createChartData(data) {
  List<charts.Series<TabulatedResponse, String>> chartData = [];
  data.forEach((String chartName, List<TabulatedResponse> chartInfo) =>
      chartData.add(charts.Series<TabulatedResponse, String>(
        id: chartName,
        domainFn: (TabulatedResponse results, _) => results.type,
        measureFn: (TabulatedResponse results, _) => results.count,
        data: chartInfo,
        labelAccessorFn: (TabulatedResponse results, _) =>
            '${results.type}: ${results.count}',
      )));
  return chartData;
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

  Map<String, List<TabulatedResponse>> tabulateResponses(selectedOption) {
    Map<String, List<TabulatedResponse>> returnedMap = {};
    if (selectedOption == 'all') {
      returnedMap = {selectedOption: tabulateList(quizResponses)};
    } else if (selectedOption == 'gender') {
      List quizResponsesMale =
          quizResponses.where((item) => item.gender == 'Male').toList();
      List quizResponsesFemale =
          quizResponses.where((item) => item.gender == 'Female').toList();
      returnedMap = {
        'male': tabulateList(quizResponsesMale),
        'female': tabulateList(quizResponsesFemale)
      };
    }
    return returnedMap;
  }

  List<TabulatedResponse> tabulateList(listQuizResponses) {
    Map tabulatedScores = {};
    for (QuizResponse response in listQuizResponses) {
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
