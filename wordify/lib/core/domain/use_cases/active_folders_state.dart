import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/data/model/word_model.dart';
import 'package:wordify/core/domain/entities/dictionary.dart';
import 'package:wordify/core/domain/entities/folder_words_container.dart';

///Manage the active folders list.
class ActiveFoldersState {
  final Dictionary _dictionary = Dictionary();


  ////Update the list of currently active folders.
  ///If the folder is present in cache (has been activated before)
  ///then simply make a reference to it and add to the active folder list.
  ///If it is not in cache, then use the list of words from input (assuming that it is
  ///provided else it will be an empty list), store it in cache and in active
  ///folder list.
  ///
  ///If the folder has been activated return true; else false.
  bool activateFolder(FolderModel folder, [List<WordModel> words = const []]) {
    FolderWordsContainer expandedFolder;
    FolderWordsContainer? fromCache = _dictionary.cachedFolders.get(folder);
    
    if (!_dictionary.activeFolders.containsKey(folder)) {
      if (fromCache == null) { //If the folder is first clicked
        expandedFolder = FolderWordsContainer(folder, words);
        
        _dictionary.activeFolders.insert(folder, expandedFolder);
        _dictionary.cachedFolders.add(folder, expandedFolder);
      } else {  //If it has been clicked before
        expandedFolder = fromCache;

        _dictionary.activeFolders.insert(folder, expandedFolder);
      }

      return true;
    } else { return false; }
  }


  ///Activate the buffer folder for its content view.
  bool activateBufferFolder() {
    if (_dictionary.buffer != null) {
      FolderWordsContainer expandedFolder = _dictionary.buffer!;

      if (!_dictionary.activeFolders.containsKey(expandedFolder.folder)) {
        _dictionary.activeFolders.insert(expandedFolder.folder, expandedFolder);

        return true;
      } else { return false; }
    } else { return false; }
  }


  ///Remove the folder from the active folder list.
  ///
  ///If the folder has been deactivated return true; else false.
  bool deactivateFolder(FolderModel folder) {
    if (_dictionary.activeFolders.containsKey(folder)) { //If the folder is active

      _dictionary.activeFolders.remove(folder);

      return true;
    } else { return false; }
  }


  ///Set the buffer folder for the dictionary.
  void setBufferFolder(FolderModel buffer, List<WordModel> words) {
    FolderModel bufferFolder = buffer;
    _dictionary.buffer = FolderWordsContainer(bufferFolder, words);
  }


  ///Is folder in the active folders list?
  bool isFolderActive(FolderModel folder) { return _dictionary.activeFolders.containsKey(folder); }


  ///
  bool isFolderInCache(FolderModel folder) { return _dictionary.cachedFolders.contains(folder); }


  ///
  List<WordModel>? getActiveFolder(FolderModel folder) { return _dictionary.activeFolders.get(folder)?.words; }


  ///
  FolderModel? getFolderBelow(FolderModel folder) { return _dictionary.activeFolders.getBelow(folder)?.folder; }


  ///
  FolderModel? getFolderAbove(FolderModel folder) { return _dictionary.activeFolders.getAbove(folder)?.folder; }


  ///
  FolderModel? get getBufferFolder { return _dictionary.buffer?.folder; }


  ///
  FolderModel? get getTopFolder { return _dictionary.activeFolders.getFirst?.folder; }


  ///
  List<WordModel>? get getBufferActiveFolder { return _dictionary.buffer?.words; }
}