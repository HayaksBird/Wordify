import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/domain/entities/folder_words_container.dart';
import 'package:wordify/core/util/cache_list.dart';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/core/util/stack_linked_hash_map.dart';

///A dictionary of the app. It contains a:
///tree folders that are in view (could be/are opened)
///list of active folders (the folders that have been opened and are in view)
///set of all folders which have ever been opened (a caching mechanism)
class Dictionary {
  static final Dictionary _instance = Dictionary._internal();

  late NTree<FolderModel> foldersInView;
  late StackLinkedHashMap<FolderModel, FolderWordsContainer> activeFolders; //Folders that are currently active
  late CacheList<FolderModel, FolderWordsContainer> cachedFolders;
  FolderWordsContainer? buffer;


  factory Dictionary() {
    return _instance;
  }


  Dictionary._internal() {
    foldersInView = NTree<FolderModel>();
    activeFolders = StackLinkedHashMap<FolderModel, FolderWordsContainer>();
    cachedFolders = CacheList(5); //give cache list size
  }
}