import 'dart:async';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_manager.dart';

///BLoC class for the main screen. It serves as an intermediary between
///the domain and the presentation.
class DictionaryBloc {
  static final DictionaryBloc _instance = DictionaryBloc._internal();
  final _foldersInViewController = StreamController<List<Folder>>(); //StreamController for output
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
    _foldersInViewController.sink.add(await _dictionaryManager.getFolderList());
  }


  ///If the folder is not activated, activate it; else ignore.
  ///Activate the state of words list and folders list.
  ///The state for folders list must also be updated since the
  //array itlsef is updated.
  Future<void> accessFolder(Folder folder) async {
    bool wasActivated = await _dictionaryManager.activateFolder(folder);

    if (wasActivated) {
      _activeFoldersController.sink.add(_dictionaryManager.activeFolders);
      _foldersInViewController.sink.add(_dictionaryManager.foldersInView);
    }
  }


  Future<void> closeFolder(Folder folder) async {
    bool wasClosed = await _dictionaryManager.deactivateFolder(folder);

    if (wasClosed) {
      _activeFoldersController.sink.add(_dictionaryManager.activeFolders);
    }
  }


  ///Get the output stream
  Stream<List<Folder>> get foldersInView => _foldersInViewController.stream;


  Stream<List<Folder>> get activeFolders => _activeFoldersController.stream;
}