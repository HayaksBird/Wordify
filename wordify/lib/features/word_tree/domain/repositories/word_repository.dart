import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';

///A source-ambiguous storage access point interface.
abstract class WordRepository {
  ///Create a new word in a folder.
  Future<WordContent> addWord(FolderContent folder, TempWordContainer word);
  ///Update a word within a folder.
  Future<WordContent> updateWord(FolderContent folder, WordContent oldWord, TempWordContainer newWord);
  ///Delete a word from a folder.
  Future<void> deleteWord(WordContent word);
  ///Get all words from a certain folder
  Future<List<WordContent>> getWordsOfFolder(FolderContent folder);
}