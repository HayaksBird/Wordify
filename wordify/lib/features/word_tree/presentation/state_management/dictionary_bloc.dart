import 'dart:async';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_manager.dart';


final _foldersInViewController = StreamController<NTree<Folder>>(); //StreamController for output
final _activeFoldersController = StreamController<List<FolderWords>>(); //StreamController for output 
final DictionaryManager _dictionaryManager = DictionaryManager();


///
void _updateWordView() {
  _activeFoldersController.sink.add(_dictionaryManager.state.activeFolders);
}


///
void _updateFolderView() {
  _foldersInViewController.sink.add(_dictionaryManager.state.foldersInView);
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
    _foldersInViewController.sink.add(await _dictionaryManager.state.setFolderTree());
  }


  ///If the folder is not activated, activate it; else ignore.
  ///Activate the state of words list and folders list.
  ///The state for folders list must also be updated since the
  ///array itlsef is updated.
  Future<void> accessFolder(Folder folder) async {
    bool wasActivated = await _dictionaryManager.state.activateFolder(folder);

    if (wasActivated) {
      _updateWordView();
      _updateFolderView();
    }
  }


  ///Deactivate the folder that is activated.
  void closeFolder(FolderWords expandedFolder) {
    bool wasClosed = _dictionaryManager.state.deactivateFolder(expandedFolder);

    if (wasClosed) {
      _updateWordView();
      _updateFolderView();
    }
  }


  ///
  void toggleFolder(Folder folder) {
    bool didExpand = _dictionaryManager.state.expandFolder(folder);

    if (!didExpand) { _dictionaryManager.state.collapseFolder(folder); }

    _updateFolderView();
  }


  //
  String getFullPath(Folder folder) {
    return fullPath(folder);
  }


  ///
  bool isActivated(Folder folder) {
    return _dictionaryManager.state.isFolderActive(folder);
  }


  ///
  bool isToExpand(Folder folder) {
    NTree<Folder> folderTree = _dictionaryManager.state.foldersInView;
    
    return folderTree.getActivityStatus(folder) && folderTree.containsChildren(folder);
  }


  ///
  List<Folder> getSubfolders(Folder? folder) {
    if (folder == null) {
      return folderTree.getRootItems;
    } else { return folderTree.getChildren(folder); }
  }


  ///
  Folder? getParentFolder(Folder folder) {
    return folderTree.getParent(folder);
  }


  //GETTERS
  Stream<NTree<Folder>> get foldersInView => _foldersInViewController.stream;

  Stream<List<FolderWords>> get activeFolders => _activeFoldersController.stream;

  NTree<Folder> get folderTree => _dictionaryManager.state.foldersInView;
}



///
class DictionaryContentBloc {

  ///Add new word to a folder.
  Future<void> createWord(Folder folder, Word word) async {
    await _dictionaryManager.words.addNewWord(folder, word);

    _updateWordView();
  }


  ///Update the word in a folder.
  Future<void> updateWord(FolderWords expandedFolder, Word oldWord, Word newWord) async {
    await _dictionaryManager.words.updateWord(expandedFolder.folder, oldWord, newWord);

    _updateWordView();
  }


  ///
  Future<void> deleteWord(FolderWords expandedFolder, Word word) async {
    await _dictionaryManager.words.deleteWord(expandedFolder.folder, word);

    _updateWordView();
  }


  ///
  Future<void> deleteFolder(Folder folder) async {
    await _dictionaryManager.folders.deleteFolder(folder);

    _updateWordView();
    _updateFolderView();
  }


  ///
  Future<void> updateFolder(Folder oldFolder, Folder newFolder) async {
    await _dictionaryManager.folders.updateFolder(oldFolder, newFolder);

    _updateFolderView();
    _updateWordView();
  }


  ///
  Future<void> createFolder(Folder? parentFolder, Folder folder) async {
    await _dictionaryManager.folders.createFolder(parentFolder, folder);

    _updateFolderView();
  }
}