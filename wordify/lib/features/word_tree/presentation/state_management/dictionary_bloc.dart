import 'dart:async';
import 'dart:collection';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_manager.dart';


final _foldersInViewController = StreamController<List<Folder>>(); //StreamController for output
final _activeFoldersController = StreamController<FolderWords?>(); //StreamController for output 
final DictionaryManager _dictionaryManager = DictionaryManager();
final HashSet<Folder> _expandedFolders = HashSet<Folder>();
final HashSet<Word> _activeSentences = HashSet<Word>();


///
void _updateWordView(FolderWords? activeFolder) {
  _activeFoldersController.sink.add(activeFolder);
}


///
void _updateFolderView() {
  _foldersInViewController.sink.add(_dictionaryManager.foldersInViewState.foldersInView.getRootItems);
}



///
class DictionaryBloc {
  static final DictionaryBloc _instance = DictionaryBloc._internal();
  late final DictionaryWordViewStateBloc wordView;
  late final DictionaryFolderViewStateBloc folderView;
  late final DictionaryContentBloc content;


  void dispose() {
    _foldersInViewController.close();
    _activeFoldersController.close();
  }


  factory DictionaryBloc() {
    return _instance;
  }


  DictionaryBloc._internal() {
    wordView = DictionaryWordViewStateBloc();
    folderView = DictionaryFolderViewStateBloc();
    content = DictionaryContentBloc();
  }
}



///BLoC class to work with the dictionary. It serves as an intermediary between
///the domain and the UI.
class DictionaryFolderViewStateBloc {
  bool showBuffer = true;
  

  ///
  Future<void> loadFolders() async {
    await _dictionaryManager.foldersInViewState.setFolderTree();
    await _dictionaryManager.activeFolderState.setBufferFolder();
    _updateFolderView();
  }


  ///
  void toggleFolder(Folder folder) {
    if (_folderTree.containsChildren(folder)) {
      if (!_expandedFolders.contains(folder)) {
        _expandedFolders.add(folder);
      } else { _expandedFolders.remove(folder); }

      _updateFolderView();
    }
  }


  //
  String getFullPath(Folder folder) {
    if (folder.name != bufferFolder.name) {
      return _dictionaryManager.foldersInViewState.fullPath(folder);
    } else { return ''; } //buffer folder
  }


  ///
  bool isToExpand(Folder folder) {
    return _expandedFolders.contains(folder) && _folderTree.containsChildren(folder);
  }


  ///
  List<Folder> getSubfolders(Folder folder) {
    if (folder.name == bufferFolder.name) {  //if buffer folder then show the root folders
      return _folderTree.getRootItems;
    } else { return _folderTree.getChildren(folder); }
  }


  ///Get's the parent folder of the given folder.
  ///If the folder is one of the root folders or if it's a buffer
  ///folder then the buffer folder is returned.
  Folder getParentFolder(Folder folder) {
    if (folder == bufferFolder) { return bufferFolder; }
    else {
      Folder? parentFolder = _folderTree.getParent(folder);

      if (parentFolder == null) { return bufferFolder; }
      else { return parentFolder; }
    }
  }


  ///To prevent the slowdown of onTap due to GestureDetector's onDoubleTap
  ///we nullify the onDoubleTap when the IconButton of the folder tile
  ///is hovered.
  void allowBufferView(bool permission) {
    showBuffer = permission;
    _updateFolderView();
  }


  //GETTERS
  Stream<List<Folder>> get foldersInView => _foldersInViewController.stream;

  NTree<Folder> get _folderTree => _dictionaryManager.foldersInViewState.foldersInView;

  Folder get bufferFolder => _dictionaryManager.foldersInViewState.bufferFolder!;

  bool get canShowBuffer => showBuffer;
}



///
class DictionaryWordViewStateBloc {

  ///If the folder is not activated, activate it; else ignore.
  ///Activate the state of words list and folders list.
  ///The state for folders list must also be updated since the
  ///array itlsef is updated.
  Future<void> accessFolder(Folder folder) async {
    bool wasActivated = await _dictionaryManager.activeFolderState.activateFolder(folder);

    if (wasActivated) {
      _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder);
      _updateFolderView();
    }
  }


  ///
  Future<void> accessBufferFolder() async {
    bool wasActivated = await _dictionaryManager.activeFolderState.activateBufferFolder();

    if (wasActivated) {
      _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder);
      _updateFolderView();
    }
  }


  ///Deactivate the folder that is activated.
  void closeFolder(FolderWords expandedFolder) {
    bool wasClosed = _dictionaryManager.activeFolderState.deactivateFolder(expandedFolder);

    if (wasClosed) {
      _activeSentences.clear();
      _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder);
      _updateFolderView();
    }
  }


  ///
  void showActiveFolderBelow(FolderWords expandedFolder) {
    bool didGoBelow = _dictionaryManager.activeFolderState.shiftCurrentActiveFolderDown(expandedFolder.folder);
    if (didGoBelow) {
      _activeSentences.clear();
      _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder);
    }
  }


  ///
  void showActiveFolderAbove(FolderWords expandedFolder) {
    bool didGoUp = _dictionaryManager.activeFolderState.shiftCurrentActiveFolderUp(expandedFolder.folder);
    if (didGoUp) {
      _activeSentences.clear();
      _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder);
    }
  }


  ///Either show or hide the sentence.
  void toggleSentence(Word word) {
    if (!_activeSentences.contains(word)) { _activeSentences.add(word); }
    else { _activeSentences.remove(word); }
    _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder);
  }


  ///Is the word expanded?
  bool doShowSentence(Word word) {
    return _activeSentences.contains(word);
  }


  ///
  bool isActivated(Folder folder) {
    return _dictionaryManager.activeFolderState.isFolderActive(folder);
  }


  Stream<FolderWords?> get activeFolders => _activeFoldersController.stream;
}



///
class DictionaryContentBloc {

  ///Add new word to a folder.
  Future<void> createWord(Folder folder, Word word) async {
    await _dictionaryManager.words.addNewWord(folder, word);
    FolderWords? currentActiveFolder = _dictionaryManager.activeFolderState.currentActiveFolder;

    if (folder == currentActiveFolder?.folder) { 
      _updateWordView(currentActiveFolder); 
    }
  }


  ///Update the word in a folder.
  Future<void> updateWord(FolderWords expandedFolder, Folder newStorage, Word oldWord, Word newWord) async {
    if (expandedFolder.folder != newStorage) {
      createWord(newStorage, newWord);
      deleteWord(expandedFolder, oldWord);
      _activeSentences.remove(oldWord);
    } else {
      Word updatedWord = await _dictionaryManager.words.updateWord(expandedFolder.folder, oldWord, newWord);
      
      if (_activeSentences.contains(oldWord)) {
        _activeSentences.remove(oldWord);

        if (expandedFolder.folder == newStorage) { _activeSentences.add(updatedWord); }
      }
    }

    _updateWordView(expandedFolder);
  }


  ///
  Future<void> deleteWord(FolderWords expandedFolder, Word word) async {
    await _dictionaryManager.words.deleteWord(expandedFolder.folder, word);
    _activeSentences.remove(word);

    _updateWordView(expandedFolder);
  }


  ///
  Future<void> deleteFolder(Folder folder) async {
    List<Folder> subfolders = await _dictionaryManager.folders.deleteFolder(folder);

    for (var subfolder in subfolders) {
      _expandedFolders.remove(subfolder);
    }

    _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder);
    _updateFolderView();
  }


  ///
  Future<void> updateFolder(Folder oldFolder, Folder newFolder) async {
    Folder updatedFolder = await _dictionaryManager.folders.updateFolder(oldFolder, newFolder);

    _expandedFolders.remove(oldFolder);
    _expandedFolders.add(updatedFolder);

    _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder); 
    _updateFolderView();
  }


  ///
  Future<void> createFolder(Folder? parentFolder, Folder folder) async {
    await _dictionaryManager.folders.createFolder(parentFolder, folder);

    _updateFolderView();
  }
}