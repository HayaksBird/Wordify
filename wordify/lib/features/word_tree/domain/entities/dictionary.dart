import 'package:wordify/core/util/cache_list.dart';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/core/util/stack_linked_hash_map.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///A dictionary of the app. It contains a:
///tree folders that are in view (could be/are opened)
///list of active folders (the folders that have been opened and are in view)
///set of all folders which have ever been opened (a caching mechanism)
class Dictionary {
  static final Dictionary _instance = Dictionary._internal();

  late NTree<FolderContent> foldersInView;
  late StackLinkedHashMap<FolderContent, FolderWords> activeFolders; //Folders that are currently active
  late CacheList<FolderContent, FolderWords> cachedFolders;
  FolderWords? buffer;


  factory Dictionary() {
    return _instance;
  }


  Dictionary._internal() {
    foldersInView = NTree<FolderContent>();
    activeFolders = StackLinkedHashMap<FolderContent, FolderWords>();
    cachedFolders = CacheList(5); //give cache list size
  }
}