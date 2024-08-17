import 'package:wordify/features/word_tree/domain/entities/word.dart';

///Represents a folder.
abstract class FolderContent {
  String get name;
}


///
class TempFolderContainer {
  final String name;

  const TempFolderContainer({
    required this.name
  });
}


///
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