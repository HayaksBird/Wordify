import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';

///A source-ambiguous storage access point interface.
abstract class WordRepository {
  ///Create a new word in a folder.
  Future<Word> addWord(Folder folder, Word word);
  ///Update a word within a folder.
  Future<Word> updateWord(Folder folder, Word oldWord, Word newWord);
  ///Delete a word from a folder.
  Future<void> deleteWord(Word word);
  ///Get all words from a certain folder
  Future<List<Word>> getWordsOfFolder(Folder folder);
}