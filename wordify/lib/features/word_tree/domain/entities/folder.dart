import 'package:wordify/features/word_tree/domain/entities/word.dart';


///Represents a folder.
class Folder {
  final String name;


  const Folder({
    required this.name,
  }); 
}


///
class FolderWords {
  Folder folder;
  List<Word> words;


  FolderWords(this.folder, this.words);


  ///
  void updateWord(Word oldWord, Word newWord) {
    int index = words.indexOf(oldWord);

    words[index] = newWord;
  }
}