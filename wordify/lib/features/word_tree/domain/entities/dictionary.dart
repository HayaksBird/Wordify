import 'package:wordify/core/util/wordify_data_structures.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///Contains all words
class Dictionary {
  List<Folder> foldersInView;
  StackLinkedHashMap<String, Folder> activeFolders; //Folders that are currently active
  Map<String, Folder> cachedFolders;


  Dictionary({
    List<Folder>? foldersInView,
    StackLinkedHashMap<String, Folder>? activeFolders,
    Map<String, Folder>? cachedFolders,
  })  : foldersInView = foldersInView ?? [],
        activeFolders = activeFolders ??  StackLinkedHashMap<String, Folder>(),
        cachedFolders = cachedFolders ?? <String, Folder>{};


  ///
  void updateFolderInView(String name, Folder newFolder) {
    for (int i = 0; i < foldersInView.length; i++) {
      if (foldersInView[i].name == name) {
        foldersInView[i] = newFolder;
      }
    }
  }
}