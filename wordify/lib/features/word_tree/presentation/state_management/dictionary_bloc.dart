import 'dart:async';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_manager.dart';

///BLoC class to work with the dictionary. It serves as an intermediary between
///the domain and the UI.
class DictionaryBloc {
  static final DictionaryBloc _instance = DictionaryBloc._internal();
  final _foldersInViewController = StreamController<List<Folder>>.broadcast(); //StreamController for output
  final _activeFoldersController = StreamController<List<Folder>>(); //StreamController for output 
  final DictionaryManager _dictionaryManager = DictionaryManager();


  factory DictionaryBloc() {
    return _instance;
  }


  DictionaryBloc._internal();


  void dispose() {
    _foldersInViewController.close();
    _activeFoldersController.close();
  }


  Future<void> loadFolders() async {
    updateFolderView();
  }


  ///If the folder is not activated, activate it; else ignore.
  ///Activate the state of words list and folders list.
  ///The state for folders list must also be updated since the
  ///array itlsef is updated.
  Future<void> accessFolder(Folder folder) async {
    bool wasActivated = await _dictionaryManager.activateFolder(folder);

    if (wasActivated) {
      updateWordView();
      updateFolderView();
    }
  }


  ///Deactivate the folder that is activated.
  Future<void> closeFolder(Folder folder) async {
    bool wasClosed = await _dictionaryManager.deactivateFolder(folder);

    if (wasClosed) {
      updateWordView();
      updateFolderView();
    }
  }


  ///Add new word to a folder.
  Future<void> addNewWord(Folder folder, Word word) async {
    await _dictionaryManager.addNewWord(folder, word);

    updateWordView();
  }


  ///Update the word in a folder.
  Future<void> updateWord(Folder folder, Word oldWord, Word newWord) async {
    await _dictionaryManager.updateWord(folder, oldWord, newWord);

    updateWordView();
  }


  ///
  Future<void> deleteWord(Folder folder, Word word) async {
    await _dictionaryManager.deleteWord(folder, word);

    updateWordView();
  }


  ///
  Future<void> deleteFolder(Folder folder) async {
    await _dictionaryManager.deleteFolder(folder);

    updateWordView();
    updateFolderView();
  }


  ///
  bool isActivated(String name) {
    return _dictionaryManager.isFolderActive(name);
  }


  ///
  Future<void> updateWordView() async {
    _activeFoldersController.sink.add(await _dictionaryManager.activeFolders);
  }


  ///
  Future<void> updateFolderView() async {
    _foldersInViewController.sink.add(await _dictionaryManager.foldersInView);
  }


  ///Get the output stream
  Stream<List<Folder>> get foldersInView => _foldersInViewController.stream;


  Stream<List<Folder>> get activeFolders => _activeFoldersController.stream;
}