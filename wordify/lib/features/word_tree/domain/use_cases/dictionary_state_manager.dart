import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/data/repositories/folder_repository.dart';
import 'package:wordify/features/word_tree/data/repositories/word_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/dictionary.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';
import 'package:wordify/features/word_tree/domain/repositories/word_repository.dart';

final Dictionary _dictionary = Dictionary();
final WordRepository _wordRepo = WordRepositoryImpl();
final FolderRepository _folderRepo = FolderRepositoryImpl();



///The class that manages the dictionary of the app.
class DictionaryFoldersInViewStateManager {
  ///Initialize the dictionary with the folder tree.
  Future<void> setFolderTree() async {
    List<Folder> rootFolders = await _folderRepo.getRootFolders();

    _dictionary.foldersInView = NTree<Folder>()..setRoot(rootFolders);

    for (Folder rootFolder in rootFolders) {
      await _setFolderSubtree(rootFolder);
    }
  }


  ///Set all the subfolders of a certain folder.
  Future<void> _setFolderSubtree(Folder folder) async {
    List<Folder> subfolders = await _folderRepo.getChildFolders(folder);

    if (subfolders.isNotEmpty) {
      _dictionary.foldersInView.insert(folder, subfolders);

      for (Folder subfolder in subfolders) {
        _setFolderSubtree(subfolder);
      }
    }
  }


  ///
  String fullPath(Folder folder) {
    return _dictionary.foldersInView.getPathToItem(folder, (f) => f.name);
  }


  //GETTERS
  ///
  NTree<Folder> get foldersInView => _dictionary.foldersInView; 

  Folder? get bufferFolder => _dictionary.buffer?.folder;
}



///
class DictionaryActiveFolderStateManager {
  FolderWords? _currentInView;


  ///Update the list of currently active folders.
  ///If the folder is present in cache (has been activated before)
  ///then simply make a reference to it and add to the active folder list.
  ///If it is not in cache, then extract it from the db, store it in cache and in active
  ///folder list.
  ///
  ///If the folder has been activated return true; else false.
  Future<bool> activateFolder(Folder folder) async {
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

      if (below == null) { _currentInView = _dictionary.activeFolders.getAbove(expandedFolder.folder); }
      else { _currentInView = below; }

      _dictionary.activeFolders.remove(expandedFolder.folder);

      return true;
    } else { return false; }
  }


  ///Extarct the buffer folder from the DB.
  Future<void> setBufferFolder() async {
    Folder bufferFolder = await _folderRepo.getBuffer();
    _dictionary.buffer = FolderWords(bufferFolder, await _wordRepo.getWordsOfFolder(bufferFolder));
  }


  ///Is folder in the active folders list?
  bool isFolderActive(Folder folder) {
    bool val = _dictionary.activeFolders.containsKey(folder);

    return val;
  }


  ///Try to shift the view to the active folder above.
  ///Shift only if there is a folder above.
  bool shiftCurrentActiveFolderUp(Folder folder) {
    FolderWords? above = _dictionary.activeFolders.getAbove(folder);

    if (above != null) {
      _currentInView = above;
      return true;
    }

    return false;
  }


  ///Try to shift the view to the active folder below.
  ///Shift only if there is a folder below.
  bool shiftCurrentActiveFolderDown(Folder folder) {
    FolderWords? below = _dictionary.activeFolders.getBelow(folder);
    
    if (below != null) {
      _currentInView = below;
      return true;
    }

    return false;
  }

  
  //Getters
  FolderWords? get currentActiveFolder {
    if (_currentInView != null && !isFolderActive(_currentInView!.folder)) {
      _currentInView = _dictionary.activeFolders.getFirst;
    }

    return _currentInView;
  }
}