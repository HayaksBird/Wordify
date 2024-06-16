import 'dart:collection';

import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///Contains all words
class Dictionary {
  List<Folder> foldersInView;
  List<ExpandedFolder> activeFolders; //Folders that are currently active
  HashMap<String, ExpandedFolder> cachedFolders;


  Dictionary({
    List<Folder>? foldersInView,
    List<ExpandedFolder>? activeFolders,
    HashMap<String, ExpandedFolder>? cachedFolders,
  })  : foldersInView = foldersInView ?? [],
        activeFolders = activeFolders ?? [],
        cachedFolders = cachedFolders ?? HashMap<String, ExpandedFolder>();


  ///
  void updateActiveFolderList(ExpandedFolder newFolder) {
    for (int i = 0; i < activeFolders.length; i++) {
      if (activeFolders[i].name == newFolder.name) {
        activeFolders[i] = newFolder; 
      }
    }
  }
}