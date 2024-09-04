import 'dart:async';

import 'package:wordify/features/flashcards/domain/entities/word.dart';
import 'package:wordify/features/flashcards/domain/use_cases/flashcards_manager.dart';
import 'package:wordify/features/flashcards/domain/use_cases/word_storage.dart';

///BLoC class to work with the flashcards and store user's attempts.
class FlashcardsBloc {
  static final FlashcardsBloc _instance = FlashcardsBloc._internal();
  final _wordInViewController = StreamController<WordWithRating>();
  final _flashcardsManager = FlashcardsManager();
  final List<WordWithRating> _visitedWords = [];
  int _visitedWordIndx = -1;
  int _totalWordCount = 0;


  void dispose() {
    _wordInViewController.close();
  }


  factory FlashcardsBloc() {
    return _instance;
  }


  FlashcardsBloc._internal();


  ///Send the new word to the user.
  void _updateWordInView(WordWithRating newWord) {
    _wordInViewController.sink.add(newWord);
  }


  ///Set up the flashcards manager and give the first word to the user.
  void flashcardsSetup(List<WordContentStats> words) {
    _flashcardsManager.setFlashcards(words);

    WordContentStats? word = _flashcardsManager.getNextWord;

    if (word != null) {
      _visitedWords.add(WordWithRating(word));
      _visitedWordIndx++;
      _updateWordInView(_visitedWords[_visitedWordIndx]);
    }

    _totalWordCount = words.length;
  }


  ///Update the data on the current word and give the user the next word.
  ///If the current word is the last in the list, then get a new word from the
  ///flashcards manager. Else just give the next word from the list.
  Future<void> setNextWord(WordContentStats currentWord, int rating) async {
    await _updateCurrentWord(currentWord, rating);

    if (_visitedWordIndx == _visitedWords.length - 1) { //Get new word
      WordContentStats? word = _flashcardsManager.getNextWord;

      if (word != null) {
        _visitedWords.add(WordWithRating(word));
        _visitedWordIndx++;
      }
    } else {  //Get next word from the list (already generated)
      _visitedWordIndx++;
    }

    
    _updateWordInView(_visitedWords[_visitedWordIndx]);
  }


  ///Update the data on the current word and give the user the previous word.
  Future<void> setPreviousWord(WordContentStats currentWord, int rating) async {
    await _updateCurrentWord(currentWord, rating);

    if (_visitedWordIndx > 0) { _visitedWordIndx--; }

    _updateWordInView(_visitedWords[_visitedWordIndx]);
  }


  ///Update the word's rating in the database. If the user is given the current word
  ///for the first time (there is no stored rating) then store the rating as a new attempt.
  ///If the user has been given the word before (there is stored rating) then simply update
  ///(rewrite) the neweset attempt.
  Future<void> _updateCurrentWord(WordContentStats currentWord, int rating) async {
    WordContentStats updatedWord;

    rating = rating != 0 ? rating : 2;  //default (if no rating was given)

    //The current word is first time rated
    if (_visitedWords[_visitedWordIndx].givenRating == 0) {
      updatedWord = await WordStorage.addNewAttempt(currentWord, rating);
    } else {  //The current word has been seen and rated before
      updatedWord = await WordStorage.updateNewestAttempt(currentWord, rating);
    }

    //Update the word after it received a new rating
    _visitedWords[_visitedWordIndx] = WordWithRating(updatedWord, rating);
  }


  //GETTERS
  Stream<WordWithRating> get wordInView => _wordInViewController.stream;

  int get wordsInTotal => _totalWordCount;

  int get currentWordPos => _visitedWordIndx + 1;
}



///A container with the word that was given to the user with the rating for this word
class WordWithRating {
  final WordContentStats word;
  final int givenRating;


  const WordWithRating(this.word, [this.givenRating = 0]);
}