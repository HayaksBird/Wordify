import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/dictionary_bloc.dart';

///
class WordViewStateBloc {
  WordContent? _selectedWord;  //The word selected by the right click


  ///If the folder is not activated, activate it; else ignore.
  ///Activate the state of words list and folders list.
  Future<void> accessFolder(FolderContent folder) async {
    bool wasActivated = await dictionaryService.activeFoldersState.activateFolder(folder);

    if (wasActivated) {
      updateWordView();
      updateFolderView();
    }
  }


  ///Show the content of the buffer folder.
  Future<void> accessBufferFolder() async {
    bool wasActivated = await dictionaryService.activeFoldersState.activateBufferFolder();

    if (wasActivated) {
      updateWordView();
      updateFolderView();
    }
  }


  ///Deactivate the folder that is activated.
  void closeFolder(FolderWords expandedFolder) {
    bool wasClosed = dictionaryService.activeFoldersState.deactivateFolder(expandedFolder.folder);

    if (wasClosed) {
      activeSentences.clear();
      updateWordView();
      updateFolderView();
    }
  }


  ///Attempt to scroll down to see the active folder below. If there is no folder bellow
  ///then the view does not get updated.
  void showActiveFolderBelow(FolderWords expandedFolder) {
    bool didGoBelow = dictionaryService.activeFoldersState.shiftCurrentActiveFolderDown(expandedFolder.folder);
    if (didGoBelow) {
      activeSentences.clear();
      updateWordView();
    }
  }


  ///Attempt to scroll up to see the active folder above. If there is no folder above
  ///then the view does not get updated.
  void showActiveFolderAbove(FolderWords expandedFolder) {
    bool didGoUp = dictionaryService.activeFoldersState.shiftCurrentActiveFolderUp(expandedFolder.folder);
    if (didGoUp) {
      activeSentences.clear();
      updateWordView();
    }
  }


  ///Either show or hide the sentence.
  void toggleSentence(WordContent word) {
    if (!activeSentences.contains(word)) { activeSentences.add(word); }
    else { activeSentences.remove(word); }

    updateWordView();
  }


  ///Is the word expanded?
  bool doShowSentence(WordContent word) {
    return activeSentences.contains(word);
  }


  ///The word that is currently selected with the right click of the
  ///mouse.
  void setSelectedWord(WordContent? word) {
    _selectedWord = word;
    updateWordView();
  }


  ///Is the folder double clicked to show its content?
  bool isActivated(FolderContent folder) {
    return dictionaryService.activeFoldersState.isFolderActive(folder);
  }


  //GETTERS
  Stream<FolderWords?> get activeFolders => activeFoldersController.stream;

  WordContent? get getSelectedWord => _selectedWord;

  bool get didGoBelow => dictionaryService.activeFoldersState.didGoBelow;
}