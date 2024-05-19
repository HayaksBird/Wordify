import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';

///A source-ambiguous storage access point interface.
abstract class WordRepository {
  Future<Word> addWord(Word word);
  Future<Word> getWord(int id);
  Future<Dictionary> getAllWords();
  Future<void> updateWord(Word word);
  Future<void> deleteWord(int id);
}