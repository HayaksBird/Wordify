import 'package:wordify/core/util/wordify_data_structures.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///A dictionary of the app. It contains a:
///list of folders that are in view (could be opened)
///list of active folders (the folders that have been opened and are in view)
///set of all folders which have ever been opened (a caching mechanism)
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