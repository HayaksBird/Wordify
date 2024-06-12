import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///Contains all words
class Dictionary {
  final List<Folder> foldersInView;
  final List<Folder> activeFolders; //Folders that are currently active


  ///The List is immutable, so it won't be accidentally updated.
  const Dictionary({
    this.foldersInView = const [],
    this.activeFolders = const []
  });
}