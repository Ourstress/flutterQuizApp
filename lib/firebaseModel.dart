import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class Fs with ChangeNotifier {
  Firestore store = fb.firestore();
  Firestore get getStore => store;

  String quizCollection = 'testQuiz';
  String quizQnCollection = 'testQuestions';

  CollectionReference get getQuizzes => getStore.collection(quizCollection);
  Query getQuizQuestion(quizId) => getStore
      .collection(quizQnCollection)
      .where('quiz', 'array-contains', quizId);
  void quizInfoEdits(quizId, updatedQuizInfo) {
    getStore.collection(quizCollection).doc(quizId).set(updatedQuizInfo);
  }

  Future quizQnEdits(quizQnId, updatedQuizQnInfo) {
    return getStore
        .collection(quizQnCollection)
        .doc(quizQnId)
        .update(data: updatedQuizQnInfo);
  }

  Future quizQnAdd(updatedQuizQnInfo) {
    return getStore.collection(quizQnCollection).add(updatedQuizQnInfo);
  }

  Future quizDelete(quizId) {
    return getStore.collection(quizCollection).doc(quizId).delete();
  }

  Future quizQnDelete(quizQnId) {
    return getStore.collection(quizQnCollection).doc(quizQnId).delete();
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
