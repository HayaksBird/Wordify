import 'dart:async';

import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/entities/dictionary.dart';
import 'package:wordify/features/word_tree/domain/use_cases/folder_service.dart';
import 'package:wordify/features/word_tree/domain/use_cases/word_service.dart';


final Dictionary _dictionary = Dictionary();
final WordService _wordService = WordService();
final FolderService _folderService = FolderService();


///
String fullPath(Folder folder) {
  return _dictionary.foldersInView.getPathToItem(folder, (f) => f.name);
}


///Manages the dictionary of the app. The management is split between state management of the
///dictionary (how is the dictionary presented) and content management (what exists within the
///dictionary).
class DictionaryManager {
  static final DictionaryManager _instance = DictionaryManager._internal();
  late final DictionaryStateManager state;
  late final DictionaryWordsManager words;
  late final DictionaryFoldersManager folders;


  factory DictionaryManager() {
    return _instance;
  }


  DictionaryManager._internal() {
    state = DictionaryStateManager();
    words = DictionaryWordsManager();
    folders = DictionaryFoldersManager();
  }
}



///The class that manages the dictionary of the app.
class DictionaryStateManager {

  ///Update the list of currently active folders.
  ///If the folder is present in cache (has been activated before)
  ///then simply make a reference to it and add to the active folder list.
  ///If it is not in cache, then extract it from the db, store it in cache and in active
  ///folder list.
  ///
  ///If the folder has been activated return true; else false.
  Future<bool> activateFolder(Folder folder) async {
    String path = fullPath(folder);
    
    if (!_dictionary.activeFolders.containsKey(path)) {
      if (!_dictionary.cachedFolders.containsKey(path)) { //If the folder is first clicked
        FolderWords expandedFolder = FolderWords(folder, await _wordService.getWordsOfFolder(folder));
        
        _dictionary.activeFolders.insert(path, expandedFolder);
        _dictionary.cachedFolders[path] = expandedFolder;
      } else {  //If it has been clicked before
        FolderWords expandedFolder = _dictionary.cachedFolders[path]!;

        _dictionary.activeFolders.insert(path, expandedFolder);
      }

      return true;
    } else { return false; }
  }


  ///Remove the folder from the active folder list.
  ///
  ///If the folder has been deactivated return true; else false.
  bool deactivateFolder(FolderWords expandedFolder) {
    String path = fullPath(expandedFolder.folder);
    
    if (_dictionary.activeFolders.containsKey(path)) { //If the folder is active
      _dictionary.activeFolders.remove(path);

      return true;
    } else { return false; }
  }


  ///
  bool isFolderActive(Folder folder) {
    String path = fullPath(folder);
    bool val = _dictionary.activeFolders.containsKey(path);

    return val;
  }


  ///
  bool expandFolder(Folder folder) {
    if (!_dictionary.foldersInView.getActivityStatus(folder)) { //Folder is not expanded
      _dictionary.foldersInView.changeActivityStatus(folder, true);

      return true;
    } else { return false; }
  }


  ///
  bool collapseFolder(Folder folder) {
    if (_dictionary.foldersInView.getActivityStatus(folder)) {  //Folder is expanded
      _dictionary.foldersInView.changeActivityStatus(folder, false);

      return true;
    } else { return false; }
  }


  ///Initialize the dictionary with the folder tree.
  Future<NTree<Folder>> setFolderTree() async {
    List<Folder> rootFolders = await _folderService.getRootFolders();

    _dictionary.foldersInView = NTree<Folder>()..setRoot(rootFolders);

    for (Folder rootFolder in rootFolders) {
      await _setFolderSubtree(rootFolder);
    }

    return _dictionary.foldersInView;
  }


  ///Set all the subfolders of a certain folder.
  Future<void> _setFolderSubtree(Folder folder) async {
    List<Folder> subfolders = await _folderService.getChildFolders(folder);

    if (subfolders.isNotEmpty) {
      _dictionary.foldersInView.insert(folder, subfolders);

      for (Folder subfolder in subfolders) {
        _setFolderSubtree(subfolder);
      }
    }
  }
  

  //GETTERS
  ///
  NTree<Folder> get foldersInView => _dictionary.foldersInView; 

  ///
  List<FolderWords> get activeFolders => _dictionary.activeFolders.getList(); 
}



///WORDS OPERATION MANAGER FOR DICTIONARY
class DictionaryWordsManager {

  ///If the folder of the word you are adding is not in cache, then just add in to db
  ///(we don't want to perform unnecessary caching).
  ///If the folder is in cache, then update the folder of the new word and store it in cache.
  ///If necessary, then also update the active folder list.
  Future<void> addNewWord(Folder folder, Word word) async {
    String path = fullPath(folder);

    if (_dictionary.cachedFolders.containsKey(path)) {
      FolderWords expandedFolder = _dictionary.cachedFolders[path]!;
      expandedFolder.words.add(await _wordService.addWord(folder, word));
    } else {
      _wordService.addWord(folder, word);
    }
  }


  ///Update the folder with the updated word.
  ///Update the cache and the active folder list with the new folder.
  Future<void> updateWord(Folder folder, Word oldWord, Word newWord) async {
    String path = fullPath(folder);
    Word updatedWord = await _wordService.updateWord(folder, oldWord, newWord);
    FolderWords expandedFolder = _dictionary.cachedFolders[path]!;

    expandedFolder.updateWord(oldWord, updatedWord);
  }


  ///
  Future<void> deleteWord(Folder folder, Word word) async {
    String path = fullPath(folder);
    FolderWords expandedFolder = _dictionary.cachedFolders[path]!;

    expandedFolder.words.remove(word);
    await _wordService.deleteWord(word);
  }
}



///FOLDERS OPERATION MANAGER FOR DICTIONARY
class DictionaryFoldersManager {

  ///
  Future<void> createFolder(Folder? parentFolder, Folder folder) async {
    Folder newFolder = await _folderService.addFolder(parentFolder, folder);

    _dictionary.foldersInView.insertOne(parentFolder, newFolder);
  }


  ///
  Future<void> updateFolder(Folder oldFolder, Folder newFolder) async {
    Folder updatedFolder = await _folderService.updateFolder(oldFolder, newFolder);
    List<Folder> subfolders = _dictionary.foldersInView.getSubitems(oldFolder);

    for (Folder subfolder in subfolders) {
      String path = fullPath(subfolder);

      _dictionary.activeFolders.remove(path);
      _dictionary.cachedFolders.remove(path);
    }

    _dictionary.foldersInView.update(oldFolder, updatedFolder);
  }


  ///Delete a folder with its subfolders.
  ///Remove them from the cache and/or active folder list
  ///if they are present there.
  Future<void> deleteFolder(Folder folder) async {
    List<Folder> subfolders = _dictionary.foldersInView.getSubitems(folder);

    for (Folder subfolder in subfolders) {
      String path = fullPath(subfolder);

      await _folderService.deleteFolder(subfolder);

      _dictionary.activeFolders.remove(path);
      _dictionary.cachedFolders.remove(path);
    }

    _dictionary.foldersInView.delete(folder);
  }
}