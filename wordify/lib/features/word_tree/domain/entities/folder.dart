import 'package:wordify/features/word_tree/domain/entities/word.dart';

///A word interface that will be used to reference an actual folder object
///received from the data layer.
abstract class FolderContent {
  String get name;
}



///A DTo object for the folder.
class TempFolderContainer {
  final String name;

  const TempFolderContainer({
    required this.name
  });
}



///Will be used to establish a connection between a folder in the folder view and
///a list of words in the word view for the corresponding folder.
class FolderWords {
  FolderContent folder;
  List<WordContent> words;


  FolderWords(this.folder, this.words);


  ///
  void updateWord(WordContent oldWord, WordContent newWord) {
    int index = words.indexOf(oldWord);

    words[index] = newWord;
  }
}