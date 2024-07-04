import 'dart:async';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_manager.dart';

///BLoC class to work with the dictionary. It serves as an intermediary between
///the domain and the UI.
class DictionaryBloc {
  static final DictionaryBloc _instance = DictionaryBloc._internal();
  final _foldersInViewController = StreamController<List<NTreeNode<Folder>>>.broadcast(); //StreamController for output
  final _activeFoldersController = StreamController<List<FolderWords>>(); //StreamController for output 
  
  final DictionaryStateManager _dictionaryStateManager = DictionaryStateManager();
  final DictionaryWordsManager _dictionaryWordsManager = DictionaryWordsManager();
  final DictionaryFoldersManager _dictionaryFoldersManager = DictionaryFoldersManager();


  factory DictionaryBloc() {
    return _instance;
  }


  DictionaryBloc._internal();


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
    bool wasActivated = await _dictionaryStateManager.activateFolder(folder);

    if (wasActivated) {
      _updateWordView();
      _updateFolderView();
    }
  }


  ///Deactivate the folder that is activated.
  Future<void> closeFolder(FolderWords expandedFolder) async {
    bool wasClosed = await _dictionaryStateManager.deactivateFolder(expandedFolder);

    if (wasClosed) {
      _updateWordView();
      _updateFolderView();
    }
  }


  ///
  Future<void> updateSubfolders(Folder folder) async {
    bool didExpand = await _dictionaryStateManager.expandFolder(folder);

    if (!didExpand) { _dictionaryStateManager.collapseFolder(folder); }

    _updateFolderView();
  }


  ///
  Future<void> closeSubfolders(Folder folder) async {
    await _dictionaryStateManager.collapseFolder(folder);

    _updateFolderView();
  }


  //
  String getFullPath(FolderWords expandedFolder) {
    return _dictionaryStateManager.fullPath(expandedFolder.folder);
  }


  ///Add new word to a folder.
  Future<void> addNewWord(Folder folder, Word word) async {
    await _dictionaryWordsManager.addNewWord(folder, word);

    _updateWordView();
  }


  ///Update the word in a folder.
  Future<void> updateWord(FolderWords expandedFolder, Word oldWord, Word newWord) async {
    await _dictionaryWordsManager.updateWord(expandedFolder.folder, oldWord, newWord);

    _updateWordView();
  }


  ///
  Future<void> deleteWord(FolderWords expandedFolder, Word word) async {
    await _dictionaryWordsManager.deleteWord(expandedFolder.folder, word);

    _updateWordView();
  }


  ///
  Future<void> deleteFolder(Folder folder) async {
    await _dictionaryFoldersManager.deleteFolder(folder);

    _updateWordView();
    _updateFolderView();
  }


  ///
  Future<void> updateFolder(Folder oldFolder, Folder newFolder) async {
    await _dictionaryFoldersManager.updateFolder(oldFolder, newFolder);

    _updateFolderView();
    _updateWordView();
  }


  ///
  Future<void> createFolder(Folder folder) async {
    await _dictionaryFoldersManager.createFolder(folder);

    _updateFolderView();
  }


  ///
  bool isActivated(Folder folder) {
    return _dictionaryStateManager.isFolderActive(folder);
  }


  ///
  Future<void> _updateWordView() async {
    _activeFoldersController.sink.add(await _dictionaryStateManager.activeFolders);
  }


  ///
  Future<void> _updateFolderView() async {
    _foldersInViewController.sink.add((await _dictionaryStateManager.foldersInView).getRootFolders);
  }


  ///Get the output stream
  Stream<List<NTreeNode<Folder>>> get foldersInView => _foldersInViewController.stream;


  Stream<List<FolderWords>> get activeFolders => _activeFoldersController.stream;
}