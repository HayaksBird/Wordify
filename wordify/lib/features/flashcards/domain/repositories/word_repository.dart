import 'package:wordify/features/flashcards/domain/entities/word.dart';

///A source-ambiguous storage access point interface.
abstract class WordRepository {
  Future<WordContentStats> storeNewAttempt(WordContentStats currentWord, int rating);

  Future<WordContentStats> updateNewestAttempt(WordContentStats currentWord, int rating);
}