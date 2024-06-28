import 'dart:async';

import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/entities/dictionary.dart';
import 'package:wordify/features/word_tree/domain/use_cases/folder_service.dart';
import 'package:wordify/features/word_tree/domain/use_cases/word_service.dart';

///The class that manages the dictionary of the app.
class DictionaryManager {
  static final DictionaryManager _instance = DictionaryManager._internal();
  late final Dictionary _dictionary;
  final FolderService _folderService = FolderService();
  final WordService _wordService = WordService();
  final Completer<void> _initializationCompleter = Completer<void>();


  factory DictionaryManager() {
    return _instance;
  }


  DictionaryManager._internal() { 
    _setFolderList(); 
  }


  ///Update the list of currently active folders.
  ///If the folder is present in cache (has been activated before)
  ///then simply make a reference to it and add to the active folder list.
  ///If it is not in cache, then extract it from the db, store it in cache and in active
  ///folder list.
  ///
  ///If the folder has been activated return true; else false.
  Future<bool> activateFolder(Folder folder) async {
    await _initializationDone;
    
    if (!_dictionary.activeFolders.containsKey(folder.name)) {
      if (!_dictionary.cachedFolders.containsKey(folder.name)) { //If the folder is first clicked
        Folder expandedFolder = await _folderService.getAllWords(folder);
        
        _dictionary.activeFolders.insert(expandedFolder.name, expandedFolder);
        _dictionary.cachedFolders[folder.name] = expandedFolder;
      } else {  //If it has been clicked before
        Folder expandedFolder = _dictionary.cachedFolders[folder.name]!;

        _dictionary.activeFolders.insert(expandedFolder.name, expandedFolder);
      }

      return true;
    } else { return false; }
  }


  ///Remove the folder from the active folder list.
  ///
  ///If the folder has been deactivated return true; else false.
  Future<bool> deactivateFolder(Folder folder) async {
    await _initializationDone;
    
    if (_dictionary.activeFolders.containsKey(folder.name)) { //If the folder is active
      
      _dictionary.activeFolders.remove(folder.name);

      return true;
    } else { return false; }
  }


  ///If the folder of the word you are adding is not in cache, then just add in to db
  ///(we don't want to perform unnecessary caching).
  ///If the folder is in cache, then update the folder of the new word and store it in cache.
  ///If necessary, then also update the active folder list.
  Future<void> addNewWord(Folder folder, Word word) async {
    await _initializationDone;

    if (_dictionary.cachedFolders.containsKey(folder.name)) {
      Folder folderToUpdate = _dictionary.cachedFolders[folder.name]!;
      Folder updatedFolder = await _folderService.addToFolder(folderToUpdate, word);

      _dictionary.cachedFolders[folder.name] = updatedFolder;
      _dictionary.activeFolders.update(folder.name, updatedFolder);
    } else {
      _wordService.addWord(folder, word);
    }
  }


  ///Update the folder with the updated word.
  ///Update the cache and the active folder list with the new folder.
  Future<void> updateWord(Folder folder, Word oldWord, Word newWord) async {
    Folder updatedFolder = await _folderService.updateInFolder(folder, oldWord, newWord);

    _dictionary.cachedFolders[folder.name] = updatedFolder;
    _dictionary.activeFolders.update(folder.name, updatedFolder);
  }


  ///
  Future<void> deleteWord(Folder folder, Word word) async {
    Folder updatedFolder = await _folderService.deleteFromFolder(folder, word);

    _dictionary.cachedFolders[folder.name] = updatedFolder;
    _dictionary.activeFolders.update(folder.name, updatedFolder);
  }


  ///
  Future<void> updateFolder(Folder oldFolder, Folder newFolder) async {
    Folder updatedFolder = await _folderService.updateFolder(oldFolder, newFolder);

    _dictionary.updateFolderInView(oldFolder.name, updatedFolder);
    _dictionary.activeFolders.remove(oldFolder.name);
    _dictionary.cachedFolders.remove(oldFolder.name);
  }


  ///
  Future<void> deleteFolder(Folder folder) async {
    _folderService.deleteFolder(folder);

    _dictionary.foldersInView.removeWhere((obj) => obj.name == folder.name);
    _dictionary.activeFolders.remove(folder.name);
    _dictionary.cachedFolders.remove(folder.name);
  }


  ///
  Future<void> createFolder(Folder folder) async {
    Folder newFolder = await _folderService.addFolder(folder);

    _dictionary.foldersInView.add(newFolder);
  }


  ///
  bool isFolderInView(String name) {
    for (Folder folder in _dictionary.foldersInView) {
      if (folder.name == name) { return true; }
    }

    return false;
  }


  ///Initialize the dictionary with the folder list.
  Future<void> _setFolderList() async {
    List<Folder> folders = await _folderService.getAllFolders();

    _dictionary = Dictionary(foldersInView: folders);
    _initializationCompleter.complete();
  }


  ///
  bool isFolderActive(String name) {
    return _dictionary.activeFolders.containsKey(name);
  }


  //GETTERS
  ///
  Future<List<Folder>> get foldersInView async { 
    await _initializationDone;
    return _dictionary.foldersInView; 
  }


  ///
  Future<List<Folder>> get activeFolders async {
    await _initializationDone;
    return _dictionary.activeFolders.getList(); 
  }


  ///Wait until the folder list is initialized
  Future<void> get _initializationDone => _initializationCompleter.future;
}