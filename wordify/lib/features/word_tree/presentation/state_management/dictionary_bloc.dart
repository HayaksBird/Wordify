import 'dart:async';
import 'dart:collection';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_service.dart';


final _foldersInViewController = StreamController<List<FolderContent>>(); //StreamController for output
final _activeFoldersController = StreamController<FolderWords?>(); //StreamController for output 
final DictionaryService _dictionaryService = DictionaryService();
final HashSet<FolderContent> _expandedFolders = HashSet<FolderContent>();
final HashSet<WordContent> _activeSentences = HashSet<WordContent>();


///
void _updateWordView() {
  _activeFoldersController.sink.add(_dictionaryService.activeFoldersState.currentActiveFolder);
}


///
void _updateFolderView() {
  _foldersInViewController.sink.add(_dictionaryService.foldersInViewState.foldersInView.getRootItems);
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
  bool _showBuffer = true;
  FolderContent? _selectedFolder;  //The folder selected by the right click
  

  ///Set the folder tree and the buffer folder.
  Future<void> loadFolders() async {
    await _dictionaryService.foldersInViewState.setFolderTree();
    await _dictionaryService.activeFoldersState.setBufferFolder();
    _updateFolderView();
  }


  ///Expand the folder if it is not expanded, or shrink it if it is expanded.
  void toggleFolder(FolderContent folder) {
    if (_folderTree.containsChildren(folder)) {
      if (!_expandedFolders.contains(folder)) {
        _expandedFolders.add(folder);
      } else { _expandedFolders.remove(folder); }

      _updateFolderView();
    }
  }


  ///Get full path of the folder from root
  String getFullPath(FolderContent folder) {
    if (folder.name != bufferFolder.name) {
      return _dictionaryService.foldersInViewState.fullPath(folder);
    } else { return ''; } //buffer folder
  }


  ///Can show child folders?
  bool isToExpand(FolderContent folder) {
    return _expandedFolders.contains(folder) && _folderTree.containsChildren(folder);
  }


  ///Show the subfolders of the given folder.
  ///Note that if passed the buffer folder will return the root folders, since it is
  ///not part of the tree.
  List<FolderContent> getSubfolders(FolderContent folder) {
    if (folder.name == bufferFolder.name) {  //if buffer folder then show the root folders
      return _folderTree.getRootItems;
    } else { return _folderTree.getChildren(folder); }
  }


  ///Get's the parent folder of the given folder.
  ///If the folder is one of the root folders or if it's a buffer
  ///folder then the buffer folder is returned.
  FolderContent getParentFolder(FolderContent folder) {
    if (folder == bufferFolder) { return bufferFolder; }
    else {
      FolderContent? parentFolder = _folderTree.getParent(folder);

      if (parentFolder == null) { return bufferFolder; }
      else { return parentFolder; }
    }
  }


  ///To prevent the slowdown of onTap due to GestureDetector's onDoubleTap
  ///we nullify the onDoubleTap when the IconButton of the folder tile
  ///is hovered.
  void allowBufferView(bool permission) {
    _showBuffer = permission;
    _updateFolderView();
  }


  ///The folder that is currently selected with the right click of the
  ///mouse.
  void setSelectedFolder(FolderContent? folder) {
    _selectedFolder = folder;
    _updateFolderView();
  }


  //GETTERS
  Stream<List<FolderContent>> get foldersInView => _foldersInViewController.stream;

  NTree<FolderContent> get _folderTree => _dictionaryService.foldersInViewState.foldersInView;

  FolderContent get bufferFolder => _dictionaryService.foldersInViewState.bufferFolder!;

  bool get canShowBuffer => _showBuffer;

  FolderContent? get getSelectedFolder => _selectedFolder;
}



///
class DictionaryWordViewStateBloc {
  WordContent? _selectedWord;  //The word selected by the right click


  ///If the folder is not activated, activate it; else ignore.
  ///Activate the state of words list and folders list.
  Future<void> accessFolder(FolderContent folder) async {
    bool wasActivated = await _dictionaryService.activeFoldersState.activateFolder(folder);

    if (wasActivated) {
      _updateWordView();
      _updateFolderView();
    }
  }


  ///Show the content of the buffer folder.
  Future<void> accessBufferFolder() async {
    bool wasActivated = await _dictionaryService.activeFoldersState.activateBufferFolder();

    if (wasActivated) {
      _updateWordView();
      _updateFolderView();
    }
  }


  ///Deactivate the folder that is activated.
  void closeFolder(FolderWords expandedFolder) {
    bool wasClosed = _dictionaryService.activeFoldersState.deactivateFolder(expandedFolder.folder);

    if (wasClosed) {
      _activeSentences.clear();
      _updateWordView();
      _updateFolderView();
    }
  }


  ///Attempt to scroll down to see the active folder below. If there is no folder bellow
  ///then the view does not get updated.
  void showActiveFolderBelow(FolderWords expandedFolder) {
    bool didGoBelow = _dictionaryService.activeFoldersState.shiftCurrentActiveFolderDown(expandedFolder.folder);
    if (didGoBelow) {
      _activeSentences.clear();
      _updateWordView();
    }
  }


  ///Attempt to scroll up to see the active folder above. If there is no folder above
  ///then the view does not get updated.
  void showActiveFolderAbove(FolderWords expandedFolder) {
    bool didGoUp = _dictionaryService.activeFoldersState.shiftCurrentActiveFolderUp(expandedFolder.folder);
    if (didGoUp) {
      _activeSentences.clear();
      _updateWordView();
    }
  }


  ///Either show or hide the sentence.
  void toggleSentence(WordContent word) {
    if (!_activeSentences.contains(word)) { _activeSentences.add(word); }
    else { _activeSentences.remove(word); }
    _updateWordView();
  }


  ///Is the word expanded?
  bool doShowSentence(WordContent word) {
    return _activeSentences.contains(word);
  }


  ///The word that is currently selected with the right click of the
  ///mouse.
  void setSelectedWord(WordContent? word) {
    _selectedWord = word;
    _updateWordView();
  }


  ///Is the folder double clicked to show its content?
  bool isActivated(FolderContent folder) {
    return _dictionaryService.activeFoldersState.isFolderActive(folder);
  }


  //GETTERS
  Stream<FolderWords?> get activeFolders => _activeFoldersController.stream;

  WordContent? get getSelectedWord => _selectedWord;

  bool get didGoBelow => _dictionaryService.activeFoldersState.didGoBelow;
}



///Manage the actual content in the dictionary by altering it.
class DictionaryContentBloc {

  ///Add new word to a folder.
  Future<void> createWord(FolderContent folder, TempWordContainer word) async {
    await _dictionaryService.wordStorage.addNewWord(folder, word);
    FolderWords? currentActiveFolder = _dictionaryService.activeFoldersState.currentActiveFolder;

    if (folder == currentActiveFolder?.folder) { 
      _updateWordView(); 
    }
  }


  ///Update the word in a folder.
  ///If the user moves the word to another folder then delete it in the original folder and
  ///create it in a new one.
  ///Else 
  Future<void> updateWord(FolderWords expandedFolder, FolderContent newStorage, WordContent oldWord, TempWordContainer newWord) async {
    if (expandedFolder.folder != newStorage) {  //Move to different folder
      createWord(newStorage, newWord);
      deleteWord(expandedFolder, oldWord);
      _activeSentences.remove(oldWord);
    } else {
      WordContent updatedWord = await _dictionaryService.wordStorage.updateWord(expandedFolder.folder, oldWord, newWord);
      
      if (_activeSentences.contains(oldWord)) { //So the sentence view remains
        _activeSentences.remove(oldWord);
        _activeSentences.add(updatedWord);
      }
    }

    _updateWordView();
  }


  ///Delete the word.
  Future<void> deleteWord(FolderWords expandedFolder, WordContent word) async {
    await _dictionaryService.wordStorage.deleteWord(expandedFolder.folder, word);
    _activeSentences.remove(word);

    _updateWordView();
  }


  ///Remove the folder with all of its subfolders.
  ///Note that the subfolders are also removed from the _expandedFolders
  ///list to not take the space.
  Future<void> deleteFolder(FolderContent folder) async {
    List<FolderContent> subfolders = await _dictionaryService.folderStorage.deleteFolder(folder);

    for (var subfolder in subfolders) {
      _expandedFolders.remove(subfolder);
    }

    _updateWordView();
    _updateFolderView();
  }


  ///Update the folder.
  Future<void> updateFolder(FolderContent oldFolder, TempFolderContainer newFolder) async {
    FolderContent updatedFolder = await _dictionaryService.folderStorage.updateFolder(oldFolder, newFolder);

    _expandedFolders.remove(oldFolder);
    _expandedFolders.add(updatedFolder);

    _updateWordView(); 
    _updateFolderView();
  }


  ///Create folder.
  Future<void> createFolder(FolderContent? parentFolder, TempFolderContainer folder) async {
    await _dictionaryService.folderStorage.createFolder(parentFolder, folder);

    _updateFolderView();
  }
}