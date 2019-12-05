Map tabulateScores(Map rawResults) {
  Map tabulatedScores = {};
  for (Map qnAnswers in rawResults.values) {
    String answerType = qnAnswers['type'];
    int answerValue = qnAnswers['value'];
    if (!tabulatedScores.containsKey(answerType)) {
      tabulatedScores[answerType] = 0;
    }
    tabulatedScores[answerType] += answerValue;
  }
  return tabulatedScores;
}

String findOutcome(Map tabulatedScores) {
  int highestScore = 0;
  String outcome = '';
  for (String outcomeType in tabulatedScores.keys) {
    if (tabulatedScores[outcomeType] > highestScore) {
      outcome = outcomeType;
      highestScore = tabulatedScores[outcomeType];
    } else if (tabulatedScores[outcomeType] == highestScore) {
      outcome += ' / ' + outcomeType;
    }
  }
  return outcome;
}

Map calculateResults(Map rawResults) {
  Map results = {};
  Map tablulatedScores = tabulateScores(rawResults);
  results['outcome'] = findOutcome(tablulatedScores);
  results['scores'] = tablulatedScores;
  return results;
}
