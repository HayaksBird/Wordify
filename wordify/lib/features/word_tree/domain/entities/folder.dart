import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/entities/word.dart';

///A DTO object for the folder.
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
}