import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/data/model/word_model.dart';

///Will be used to establish a connection between a folder in the folder view and
///a list of words in the word view for the corresponding folder.
class FolderWordsContainer {
  FolderModel folder;
  List<WordModel> words;


  FolderWordsContainer(this.folder, this.words);


  ///
  void updateWord(WordModel oldWord, WordModel newWord) {
    int index = words.indexOf(oldWord);

    words[index] = newWord;
  }
}