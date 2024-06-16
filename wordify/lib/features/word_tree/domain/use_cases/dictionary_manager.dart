import 'dart:async';

import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/entities/dictionary.dart';
import 'package:wordify/features/word_tree/domain/use_cases/folder_service.dart';
import 'package:wordify/features/word_tree/domain/use_cases/word_service.dart';

class DictionaryManager {
  late Dictionary _dictionary;
  final FolderService _folderService = FolderService();
  final WordService _wordService = WordService();
  final Completer<void> _initializationCompleter = Completer<void>();


  DictionaryManager() {
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
    
    if (!_dictionary.activeFolders.contains(folder)) {
      if (!_dictionary.cachedFolders.containsKey(folder.name)) { //If the folder is first clicked
        ExpandedFolder expandedFolder = await _folderService.getAllWords(folder);
        
        _dictionary.activeFolders.insert(0, expandedFolder);
        _dictionary.cachedFolders[folder.name] = expandedFolder;
      } else {  //If it has been clicked before
        ExpandedFolder expandedFolder = _dictionary.cachedFolders[folder.name]!;

        _dictionary.activeFolders.insert(0, expandedFolder);
      }

      return true;
    } else { return false; }
  }


  ///Remove the folder from the active folder list.
  ///
  ///If the folder has been deactivated return true; else false.
  Future<bool> deactivateFolder(ExpandedFolder folder) async {
    await _initializationDone;
    
    if (_dictionary.activeFolders.contains(folder)) { //If the folder is active
      
      _dictionary.activeFolders.remove(folder);

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
      ExpandedFolder folderToUpdate = _dictionary.cachedFolders[folder.name]!;
      ExpandedFolder updatedFolder = await _folderService.addToFolder(folderToUpdate, word);

      _dictionary.cachedFolders[folder.name] = updatedFolder;
      _dictionary.updateActiveFolderList(updatedFolder);
    } else {
      _wordService.addWord(folder, word);
    }
  }


  ///Update the folder with the updated word.
  ///Update the cache and the active folder list with the new folder.
  Future<void> updateWord(ExpandedFolder folder, Word oldWord, Word newWord) async {
    ExpandedFolder updatedFolder = await _folderService.updateFolder(folder, oldWord, newWord);

    _dictionary.cachedFolders[folder.name] = updatedFolder;
    _dictionary.updateActiveFolderList(updatedFolder);
  }


  ///Initialize the dictionary with the folder list.
  Future<void> _setFolderList() async {
    List<Folder> folders = await _folderService.getAllFolders();
    _dictionary = Dictionary(foldersInView: folders);
    _initializationCompleter.complete();
  }


  ///
  Future<List<Folder>> get foldersInView async { 
    await _initializationDone;
    return _dictionary.foldersInView; 
  }


  ///
  Future<List<ExpandedFolder>> get activeFolders async {
    await _initializationDone;
    return _dictionary.activeFolders; 
  }


  ///Wait until the folder list is initialized
  Future<void> get _initializationDone => _initializationCompleter.future;
}