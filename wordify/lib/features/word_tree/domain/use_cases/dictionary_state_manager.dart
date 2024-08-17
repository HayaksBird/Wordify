import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/data/folder_repository.dart';
import 'package:wordify/features/word_tree/data/word_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/dictionary.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';
import 'package:wordify/features/word_tree/domain/repositories/word_repository.dart';

final Dictionary _dictionary = Dictionary();
final WordRepository _wordRepo = WordRepositoryImpl();
final FolderRepository _folderRepo = FolderRepositoryImpl();



///Manages the state of the folders in view of the dictionary.
///Handles all the operations that have to do with the state of the
///folders in view.
class DictionaryFoldersInViewStateManager {

  ///Initialize the dictionary with the folder tree.
  Future<void> setFolderTree() async {
    List<FolderContent> rootFolders = await _folderRepo.getRootFolders();

    _dictionary.foldersInView = NTree<FolderContent>()..setRoot(rootFolders);

    for (FolderContent rootFolder in rootFolders) {
      await _setFolderSubtree(rootFolder);
    }
  }


  ///Set all the subfolders of a certain folder.
  Future<void> _setFolderSubtree(FolderContent folder) async {
    List<FolderContent> subfolders = await _folderRepo.getChildFolders(folder);

    if (subfolders.isNotEmpty) {
      _dictionary.foldersInView.insert(folder, subfolders);

      for (FolderContent subfolder in subfolders) {
        _setFolderSubtree(subfolder);
      }
    }
  }


  ///
  String fullPath(FolderContent folder) {
    return _dictionary.foldersInView.getPathToItem(folder, (f) => f.name);
  }


  //GETTERS
  ///
  NTree<FolderContent> get foldersInView => _dictionary.foldersInView; 

  FolderContent? get bufferFolder => _dictionary.buffer?.folder;
}



///Manages the state of the active folders of the dictionary.
///Handles all the operations that have to do with the state of the
///active folder.
class DictionaryActiveFolderStateManager {
  FolderWords? _currentInView;  //current active folder
  bool didGoBelow = false;


  ///Update the list of currently active folders.
  ///If the folder is present in cache (has been activated before)
  ///then simply make a reference to it and add to the active folder list.
  ///If it is not in cache, then extract it from the db, store it in cache and in active
  ///folder list.
  ///
  ///If the folder has been activated return true; else false.
  Future<bool> activateFolder(FolderContent folder) async {
    FolderWords expandedFolder;
    FolderWords? fromCache = _dictionary.cachedFolders.get(folder);
    
    if (!_dictionary.activeFolders.containsKey(folder)) {
      if (fromCache == null) { //If the folder is first clicked
        expandedFolder = FolderWords(folder, await _wordRepo.getWordsOfFolder(folder));
        
        _dictionary.activeFolders.insert(folder, expandedFolder);
        _dictionary.cachedFolders.add(folder, expandedFolder);
      } else {  //If it has been clicked before
        expandedFolder = fromCache;

        _dictionary.activeFolders.insert(folder, expandedFolder);
      }

      didGoBelow = false;
      _currentInView = expandedFolder;

      return true;
    } else { return false; }
  }


  ///Activate the buffer folder for its content view.
  Future<bool> activateBufferFolder() async {
    if (_dictionary.buffer != null) {
      FolderWords expandedFolder = _dictionary.buffer!;

      if (!_dictionary.activeFolders.containsKey(expandedFolder.folder)) {
        _dictionary.activeFolders.insert(expandedFolder.folder, expandedFolder);

        didGoBelow = false;
        _currentInView = expandedFolder;

        return true;
      } else { return false; }
    } else { return false; }
  }


  ///Remove the folder from the active folder list.
  ///
  ///If the folder has been deactivated return true; else false.
  bool deactivateFolder(FolderWords expandedFolder) {
    if (_dictionary.activeFolders.containsKey(expandedFolder.folder)) { //If the folder is active
      FolderWords? below = _dictionary.activeFolders.getBelow(expandedFolder.folder);

      if (below == null) {
        didGoBelow = false;
        _currentInView = _dictionary.activeFolders.getAbove(expandedFolder.folder);
      }
      else {
        didGoBelow = true;
        _currentInView = below;
      }

      _dictionary.activeFolders.remove(expandedFolder.folder);

      return true;
    } else { return false; }
  }


  ///Extarct the buffer folder from the DB.
  Future<void> setBufferFolder() async {
    FolderContent bufferFolder = await _folderRepo.getBuffer();
    _dictionary.buffer = FolderWords(bufferFolder, await _wordRepo.getWordsOfFolder(bufferFolder));
  }


  ///Is folder in the active folders list?
  bool isFolderActive(FolderContent folder) {
    bool val = _dictionary.activeFolders.containsKey(folder);

    return val;
  }


  ///Try to shift the view to the active folder above.
  ///Shift only if there is a folder above.
  bool shiftCurrentActiveFolderUp(FolderContent folder) {
    FolderWords? above = _dictionary.activeFolders.getAbove(folder);

    if (above != null) {
      didGoBelow = false;
      _currentInView = above;
      return true;
    }

    return false;
  }


  ///Try to shift the view to the active folder below.
  ///Shift only if there is a folder below.
  bool shiftCurrentActiveFolderDown(FolderContent folder) {
    FolderWords? below = _dictionary.activeFolders.getBelow(folder);
    
    if (below != null) {
      didGoBelow = true;
      _currentInView = below;
      return true;
    }

    return false;
  }

  
  //Getters
  ///Get the currently active folder.
  ///If the last tracked folder is no longer active (due to delete perhaps)
  ///then return the active folder at the top of the stack.
  ///Else return the last trackeed active folder.
  FolderWords? get currentActiveFolder {
    if (_currentInView != null && !isFolderActive(_currentInView!.folder)) {
      _currentInView = _dictionary.activeFolders.getFirst;
    }

    return _currentInView;
  }
}