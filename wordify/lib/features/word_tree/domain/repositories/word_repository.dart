import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';

///A source-ambiguous storage access point interface.
abstract class WordRepository {
  Future<Word> addWord(Folder folder, Word word);
  Future<Word> updateWord(Word oldWord, Word newWord);
  Future<void> deleteWord(Word word);
}