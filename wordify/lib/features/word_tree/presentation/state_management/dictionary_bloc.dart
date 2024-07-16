import 'dart:async';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_manager.dart';


final _foldersInViewController = StreamController<List<Folder>>(); //StreamController for output
final _activeFoldersController = StreamController<FolderWords?>(); //StreamController for output 
final DictionaryManager _dictionaryManager = DictionaryManager();


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
  late final DictionaryStateBloc state;
  late final DictionaryContentBloc content;



  factory DictionaryBloc() {
    return _instance;
  }


  DictionaryBloc._internal() {
    state = DictionaryStateBloc();
    content = DictionaryContentBloc();
  }
}



///BLoC class to work with the dictionary. It serves as an intermediary between
///the domain and the UI.
class DictionaryStateBloc {

  void dispose() {
    _foldersInViewController.close();
    _activeFoldersController.close();
  }


  ///
  Future<void> loadFolders() async {
    await _dictionaryManager.foldersInViewState.setFolderTree();
    _updateFolderView();
  }


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


  ///Deactivate the folder that is activated.
  void closeFolder(FolderWords expandedFolder) {
    bool wasClosed = _dictionaryManager.activeFolderState.deactivateFolder(expandedFolder);

    if (wasClosed) {
      _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder);
      _updateFolderView();
    }
  }


  ///
  void showActiveFolderBelow(FolderWords expandedFolder) {
    bool didGoBelow = _dictionaryManager.activeFolderState.shiftCurrentActiveFolderDown(expandedFolder.folder);
    if (didGoBelow) _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder);
  }


  ///
  void showActiveFolderAbove(FolderWords expandedFolder) {
    bool didGoUp = _dictionaryManager.activeFolderState.shiftCurrentActiveFolderUp(expandedFolder.folder);
    if (didGoUp) _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder);
  }


  ///
  void toggleFolder(Folder folder) {
    bool didExpand = _dictionaryManager.foldersInViewState.expandFolder(folder);

    if (!didExpand) { _dictionaryManager.foldersInViewState.collapseFolder(folder); }

    _updateFolderView();
  }


  //
  String getFullPath(Folder folder) {
    return _dictionaryManager.foldersInViewState.fullPath(folder);
  }


  ///
  bool isActivated(Folder folder) {
    return _dictionaryManager.activeFolderState.isFolderActive(folder);
  }


  ///
  bool isToExpand(Folder folder) {
    NTree<Folder> folderTree = _dictionaryManager.foldersInViewState.foldersInView;
    
    return folderTree.getActivityStatus(folder) && folderTree.containsChildren(folder);
  }


  ///
  List<Folder> getSubfolders(Folder? folder) {
    if (folder == null) {
      return _folderTree.getRootItems;
    } else { return _folderTree.getChildren(folder); }
  }


  ///
  Folder? getParentFolder(Folder folder) {
    return _folderTree.getParent(folder);
  }


  //GETTERS
  Stream<List<Folder>> get foldersInView => _foldersInViewController.stream;

  Stream<FolderWords?> get activeFolders => _activeFoldersController.stream;

  NTree<Folder> get _folderTree => _dictionaryManager.foldersInViewState.foldersInView;
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
  Future<void> updateWord(FolderWords expandedFolder, Word oldWord, Word newWord) async {
    await _dictionaryManager.words.updateWord(expandedFolder.folder, oldWord, newWord);

    _updateWordView(expandedFolder);
  }


  ///
  Future<void> deleteWord(FolderWords expandedFolder, Word word) async {
    await _dictionaryManager.words.deleteWord(expandedFolder.folder, word);

    _updateWordView(expandedFolder);
  }


  ///
  Future<void> deleteFolder(Folder folder) async {
    await _dictionaryManager.folders.deleteFolder(folder);

    _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder);
    _updateFolderView();
  }


  ///
  Future<void> updateFolder(Folder oldFolder, Folder newFolder) async {
    await _dictionaryManager.folders.updateFolder(oldFolder, newFolder);

    _updateWordView(_dictionaryManager.activeFolderState.currentActiveFolder); 
    _updateFolderView();
  }


  ///
  Future<void> createFolder(Folder? parentFolder, Folder folder) async {
    await _dictionaryManager.folders.createFolder(parentFolder, folder);

    _updateFolderView();
  }
}