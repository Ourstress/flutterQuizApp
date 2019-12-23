import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class Fs with ChangeNotifier {
  Firestore store = fb.firestore();
  Firestore get getStore => store;
  CollectionReference get getQuizzes => getStore.collection('testQuiz');
  Query getQuizQuestion(quizId) => getStore
      .collection('testQuestions')
      .where('quiz', 'array-contains', quizId);
  void quizInfoEdits(quizId, updatedQuizInfo) {
    getStore.collection('testQuiz').doc(quizId).set(updatedQuizInfo);
  }

  Future quizQnEdits(quizQnId, updatedQuizQnInfo) {
    return getStore
        .collection('testQuestions')
        .doc(quizQnId)
        .update(data: updatedQuizQnInfo);
  }
}

class Fa with ChangeNotifier {
  fb.Auth fbAuth = fb.auth();
  fb.User user;

  Fa() {
    fbAuth.onAuthStateChanged.listen((e) {
      user = e;
      notifyListeners();
    });
  }

  // bool get getUser => true;
  fb.User get getUser => user;
}
