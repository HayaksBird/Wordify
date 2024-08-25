import 'package:wordify/features/flashcards/domain/entities/word.dart';

///A source-ambiguous storage access point interface.
abstract class WordRepository {
  Future<void> storeNewAttempt(WordContentStats currentWord, int rating);
}