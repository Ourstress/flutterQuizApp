import 'package:flutter/material.dart';
import 'appBar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

class SelectedCategory with ChangeNotifier {
  String selectedGender = 'All';
  String selectedSemester = 'All';

  String get getSelectedGender => selectedGender;
  String get getselectedSemester => selectedSemester;

  void setSelectedGender(String value) {
    selectedGender = value;
    notifyListeners();
  }

  void setSelectedSemester(String value) {
    selectedSemester = value;
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
              child: Text('Quiz responses for ${quizInfo.quizTitle}',
                  style: Theme.of(context).textTheme.display1)),
        ),
        Flexible(
            flex: 4,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListTile(
                    leading: Text('Settings:',
                        style: Theme.of(context).textTheme.title),
                    title: Wrap(
                      spacing: 20.0,
                      children: <Widget>[
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                          Text('Gender:'),
                          SizedBox(width: 15.0),
                          SizedBox(width: 100.0, child: DropdownSelectGender()),
                        ]),
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                          Text('Semester'),
                          SizedBox(width: 15.0),
                          SizedBox(
                              width: 170.0,
                              child: DropdownSelectSemester(
                                  quizResponses: quizInfo.quizResponses))
                        ])
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: _createBarChart(quizInfo.tabulateResponses(
                      Provider.of<SelectedCategory>(context).getSelectedGender,
                      Provider.of<SelectedCategory>(context)
                          .getselectedSemester)),
                )
              ],
            ))
      ],
    );
  }
}

charts.BarChart _createBarChart(data) => charts.BarChart(
      _createChartData(data),
      animate: false,
      vertical: false,
      behaviors: [charts.SeriesLegend()],
      barGroupingType: charts.BarGroupingType.grouped,
      barRendererDecorator: charts.BarLabelDecorator(
        labelPosition: charts.BarLabelPosition.auto,
        insideLabelStyleSpec: charts.TextStyleSpec(fontSize: 20),
        outsideLabelStyleSpec: charts.TextStyleSpec(fontSize: 20),
      ),
      domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
              labelStyle: charts.TextStyleSpec(fontSize: 20))),
    );

List<charts.Series<TabulatedResponse, String>> _createChartData(data) {
  List<charts.Series<TabulatedResponse, String>> chartData = [];
  data.forEach((String chartName, List<TabulatedResponse> chartInfo) =>
      chartData.add(charts.Series<TabulatedResponse, String>(
        id: chartName,
        domainFn: (TabulatedResponse results, _) => results.type,
        measureFn: (TabulatedResponse results, _) => results.count,
        data: chartInfo,
        labelAccessorFn: (TabulatedResponse results, _) => '${results.count}',
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

  String get quizTitle => quizInfo['title'];
  List<QuizResponse> get quizResponses => quizInfo['responses']
      .values
      .map<QuizResponse>((elem) =>
          QuizResponse(elem['gender'], elem['results'], elem['createdAt']))
      .toList();

  // take out nan if we just want to compare between male/female
  Map<String, List<TabulatedResponse>> tabulateResponses(
      selectedGender, selectedSem) {
    ProcessQuizResponses responseProcessor =
        ProcessQuizResponses(quizResponses);
    Map _semestersData = responseProcessor.semestersData();

    Map<String, List<TabulatedResponse>> returnedMap = {};
    List _selectedSemData = _semestersData[selectedSem];
    if (selectedGender == 'All') {
      returnedMap = {selectedGender: tabulateList(_selectedSemData)};
    } else if (selectedGender == 'Gender') {
      List quizResponsesMale =
          _selectedSemData.where((item) => item.gender == 'male').toList();
      List quizResponsesFemale =
          _selectedSemData.where((item) => item.gender == 'female').toList();
      List quizResponsesNan =
          _selectedSemData.where((item) => item.gender == 'nan').toList();
      returnedMap = {
        'male': tabulateList(quizResponsesMale),
        'female': tabulateList(quizResponsesFemale),
        'unspecified': tabulateList(quizResponsesNan)
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

class DropdownSelectGender extends StatefulWidget {
  DropdownSelectGenderState createState() => DropdownSelectGenderState();
}

class DropdownSelectGenderState extends State<DropdownSelectGender> {
  String selectedValue = 'All';
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      onChanged: (value) => setState(() {
        selectedValue = value;
        Provider.of<SelectedCategory>(context, listen: false)
            .setSelectedGender(value);
      }),
      decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
      value: selectedValue,
      items: <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          value: 'All',
          child: Text("All"),
        ),
        DropdownMenuItem<String>(
          value: 'Gender',
          child: Text("By gender"),
        ),
      ],
    );
  }
}

class DropdownSelectSemester extends StatefulWidget {
  final List<QuizResponse> quizResponses;
  const DropdownSelectSemester({Key key, this.quizResponses}) : super(key: key);

  DropdownSelectSemesterState createState() => DropdownSelectSemesterState();
}

class DropdownSelectSemesterState extends State<DropdownSelectSemester> {
  String selectedValue = 'All';
  Map semestersData = {};

  void initState() {
    ProcessQuizResponses responseProcessor =
        ProcessQuizResponses(widget.quizResponses);
    semestersData = responseProcessor.semestersData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      onChanged: (value) => setState(() {
        selectedValue = value;
        Provider.of<SelectedCategory>(context, listen: false)
            .setSelectedSemester(value);
      }),
      decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
      value: selectedValue,
      items: [
        for (int i = 0; i < semestersData.keys.length; i++)
          DropdownMenuItem<String>(
            value: semestersData.keys.elementAt(i),
            child: Text(semestersData.keys.elementAt(i)),
          )
      ],
    );
  }
}

class ProcessQuizResponses {
  ProcessQuizResponses(this.listQuizResponses);
  final List<QuizResponse> listQuizResponses;

  Map _sortIntoAcadSem() {
    Map responsesBySem = {};
    responsesBySem['All'] = listQuizResponses;
    for (QuizResponse response in listQuizResponses) {
      int responseYear = response.createdAt.year;
      int responseMonth = response.createdAt.month;
      String acadSem;
      responseMonth > 6
          ? acadSem = 'AY$responseYear-${responseYear + 1} sem1'
          : acadSem = 'AY${responseYear - 1}-$responseYear sem2';
      if (!responsesBySem.containsKey(acadSem)) {
        responsesBySem[acadSem] = [];
      }
      responsesBySem[acadSem].add(response);
    }
    return responsesBySem;
  }

  Map semestersData() {
    return _sortIntoAcadSem();
  }
}
