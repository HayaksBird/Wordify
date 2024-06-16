import 'dart:async';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_manager.dart';

///BLoC class to work with the dictionary. It serves as an intermediary between
///the domain and the UI.
class DictionaryBloc {
  static final DictionaryBloc _instance = DictionaryBloc._internal();
  final _foldersInViewController = StreamController<List<Folder>>.broadcast(); //StreamController for output
  final _activeFoldersController = StreamController<List<ExpandedFolder>>(); //StreamController for output 
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
    _foldersInViewController.sink.add(await _dictionaryManager.foldersInView);
  }


  ///If the folder is not activated, activate it; else ignore.
  ///Activate the state of words list and folders list.
  ///The state for folders list must also be updated since the
  //array itlsef is updated.
  Future<void> accessFolder(Folder folder) async {
    bool wasActivated = await _dictionaryManager.activateFolder(folder);

    if (wasActivated) {
      _activeFoldersController.sink.add(await _dictionaryManager.activeFolders);
    }
  }


  ///Deactivate the folder that is activated.
  Future<void> closeFolder(ExpandedFolder folder) async {
    bool wasClosed = await _dictionaryManager.deactivateFolder(folder);

    if (wasClosed) {
      _activeFoldersController.sink.add(await _dictionaryManager.activeFolders);
    }
  }


  ///Add new word to a folder.
  Future<void> addNewWord(Folder folder, Word word) async {
    await _dictionaryManager.addNewWord(folder, word);

    _activeFoldersController.sink.add(await _dictionaryManager.activeFolders);
  }


  ///Update the word in a folder.
  Future<void> updateWord(ExpandedFolder folder, Word oldWord, Word newWord) async {
    await _dictionaryManager.updateWord(folder, oldWord, newWord);

    _activeFoldersController.sink.add(await _dictionaryManager.activeFolders);
  }


  ///Get the output stream
  Stream<List<Folder>> get foldersInView => _foldersInViewController.stream;


  Stream<List<ExpandedFolder>> get activeFolders => _activeFoldersController.stream;
}