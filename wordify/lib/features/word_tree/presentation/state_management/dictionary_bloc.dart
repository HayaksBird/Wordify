import 'dart:async';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_manager.dart';


final _foldersInViewController = StreamController<List<NTreeNode<Folder>>>.broadcast(); //StreamController for output
final _activeFoldersController = StreamController<List<FolderWords>>(); //StreamController for output 
final DictionaryManager _dictionaryManager = DictionaryManager();


///
Future<void> _updateWordView() async {
  _activeFoldersController.sink.add(await _dictionaryManager.state.activeFolders);
}


///
Future<void> _updateFolderView() async {
  _foldersInViewController.sink.add((await _dictionaryManager.state.foldersInView).getRootFolders);
}



///BLoC class to work with the dictionary. It serves as an intermediary between
///the domain and the UI.
class DictionaryStateBloc {
  static final DictionaryStateBloc _instance = DictionaryStateBloc._internal();


  factory DictionaryStateBloc() {
    return _instance;
  }


  DictionaryStateBloc._internal();


  void dispose() {
    _foldersInViewController.close();
    _activeFoldersController.close();
  }


  Future<void> loadFolders() async {
    _updateFolderView();
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
  Future<void> closeFolder(FolderWords expandedFolder) async {
    bool wasClosed = await _dictionaryManager.state.deactivateFolder(expandedFolder);

    if (wasClosed) {
      _updateWordView();
      _updateFolderView();
    }
  }


  ///
  Future<void> updateSubfolderStatus(Folder folder) async {
    bool didExpand = await _dictionaryManager.state.expandFolder(folder);

    if (!didExpand) { _dictionaryManager.state.collapseFolder(folder); }

    _updateFolderView();
  }


  ///
  Future<void> closeSubfolders(Folder folder) async {
    await _dictionaryManager.state.collapseFolder(folder);

    _updateFolderView();
  }


  //
  String getFullPath(FolderWords expandedFolder) {
    return fullPath(expandedFolder.folder);
  }


  ///
  bool isActivated(Folder folder) {
    return _dictionaryManager.state.isFolderActive(folder);
  }


  ///
  bool isToExpand(NTreeNode<Folder> folder) {
    return folder.childrenNodes.isNotEmpty && folder.activity;
  }


  ///Get the output stream
  Stream<List<NTreeNode<Folder>>> get foldersInView => _foldersInViewController.stream;


  Stream<List<FolderWords>> get activeFolders => _activeFoldersController.stream;
}



///
class DictionaryContentBloc {
  static final DictionaryContentBloc _instance = DictionaryContentBloc._internal();


  factory DictionaryContentBloc() {
    return _instance;
  }


  DictionaryContentBloc._internal();


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