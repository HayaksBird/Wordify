import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/data/model/word_model.dart';
import 'package:wordify/core/domain/entities/dictionary.dart';
import 'package:wordify/core/domain/entities/folder_words_container.dart';

///
class WordsContent {
  final Dictionary _dictionary = Dictionary();


  ///
  void addNewWord(FolderModel folder, WordModel word) {
    if (folder == _dictionary.buffer?.folder) {
      _dictionary.buffer?.words.add(word);
      return;
    }

    FolderWordsContainer? fromCache = _dictionary.cachedFolders.get(folder);
    FolderWordsContainer? activeFolder = _dictionary.activeFolders.get(folder);

    if (fromCache != null || activeFolder != null) {
      FolderWordsContainer expandedFolder = fromCache ?? activeFolder!;
      expandedFolder.words.add(word);
    }
  }


  ///
  void updateWord(FolderModel folder, WordModel oldWord, WordModel newWord) {
    FolderWordsContainer activeFolder = _dictionary.activeFolders.get(folder)!;

    activeFolder.updateWord(oldWord, newWord);
  }


  ///
  void deleteWord(FolderModel folder, WordModel word) {
    FolderWordsContainer activeFolder = _dictionary.activeFolders.get(folder)!;
    activeFolder.words.remove(word);
  }
}