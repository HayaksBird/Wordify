import 'dart:async';
import 'package:wordify/features/word_tree/domain/entities/dictionary.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';
import 'package:wordify/features/word_tree/domain/use_cases/word_service.dart';

///BLoC class for the main screen. It serves as an intermediary between
///the domain and the presentation.
class DictionaryBloc {
  late Dictionary dictionary;
  final _dictionaryController = StreamController<Dictionary>(); //StreamController for output
  final WordService wordService = WordService();


  void dispose() {
    _dictionaryController.close();
  }


  ///Load the initial words from the database.
  Future<void> loadInitialData() async {
    dictionary =  await wordService.getAllWords();
    _dictionaryController.sink.add(dictionary);
  }


  ///Add a new word to the dictionary.
  ///The updated dictionary is added to the sink, which
  ///will notify and update the widgets that are dependent on it. 
  Future<void> createWord(Word? word) async {
    if (word == null) return;

    final Word indexedWord = await wordService.addWord(word);

    dictionary = Dictionary(
      words: List<Word>.from(dictionary.words)
        ..add(indexedWord)
    );
    _dictionaryController.sink.add(dictionary);
  }


  ///Update the word.
  Future<void> updateWord(Word? word, int index) async {
    if (word == null) return;

    wordService.updateWord(word);

    dictionary = Dictionary(
      words: List<Word>.from(dictionary.words)
        ..[index] = word
    );
    _dictionaryController.sink.add(dictionary);
  }


  ///Get the output stream
  Stream<Dictionary> get dictionaryStream => _dictionaryController.stream;
}