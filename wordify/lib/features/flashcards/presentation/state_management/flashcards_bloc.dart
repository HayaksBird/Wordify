import 'dart:async';

import 'package:wordify/features/flashcards/domain/entities/word.dart';
import 'package:wordify/features/flashcards/domain/use_cases/flashcards_manager.dart';

class FlashcardsBloc {
  static final FlashcardsBloc _instance = FlashcardsBloc._internal();
  final _wordInViewController = StreamController<WordContentStats>();
  final _flashcardsManager = FlashcardsManager();


  void dispose() {
    _wordInViewController.close();
  }


  factory FlashcardsBloc() {
    return _instance;
  }


  FlashcardsBloc._internal();


  ///
  void _updateWordInView(WordContentStats newWord) {
    _wordInViewController.sink.add(newWord);
  }


  ///
  void flashcardsSetup(List<WordContentStats> words) {
    _flashcardsManager.setPerformanceLists(words);

    WordContentStats? word = _flashcardsManager.getNextWord;
    if (word != null) { _updateWordInView(word); }
  }


  ///
  void setNextWord() {
    WordContentStats? word = _flashcardsManager.getNextWord;
    if (word != null) { _updateWordInView(word); }
  }


  //GETTERS
  Stream<WordContentStats> get wordInView => _wordInViewController.stream;
}