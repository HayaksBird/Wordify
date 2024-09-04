import 'package:wordify/features/flashcards/data/word_repository.dart';
import 'package:wordify/features/flashcards/domain/entities/word.dart';
import 'package:wordify/features/flashcards/domain/repositories/word_repository.dart';


///Update the word's data
class WordStorage {
  static final WordRepository _wordRepo = WordRepositoryImpl(); 

  
  ///Stores the new attempt to the db, while eliminating the latest one.
  static Future<WordContentStats> addNewAttempt(WordContentStats currentWord, int rating) async {
    return _wordRepo.storeNewAttempt(currentWord, rating);
  }


  ///Updates the newest attempt's value (does not add a new attempt)
  static Future<WordContentStats> updateNewestAttempt(WordContentStats currentWord, int rating) async {
    return _wordRepo.updateNewestAttempt(currentWord, rating);
  }
}