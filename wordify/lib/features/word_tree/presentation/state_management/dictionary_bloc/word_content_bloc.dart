import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/dictionary_bloc.dart';

///BLoC class that maintains the content of words.
class WordContentBloc {

  ///Add new word to a folder.
  ///If the folder we are adding to is currently in view then update the state.
  Future<void> createWord(FolderContent? folder, TempWordContainer word) async {
    folder = folder ?? dictionaryService.activeFoldersState.bufferFolder!;

    await dictionaryService.wordStorage.addNewWord(folder, word);
    FolderWords? currentActiveFolder = dictionaryService.activeFoldersState.currentActiveFolder;

    if (folder == currentActiveFolder?.folder) { 
      updateWordView(); 
    }
  }


  ///Update the word in a folder.
  ///If the user moves the word to another folder then update the corresponding folder of
  ///a word.
  Future<void> updateWord(FolderWords expandedFolder, FolderContent? newStorage, WordContent oldWord, TempWordContainer newWord) async {
    newStorage = newStorage ?? dictionaryService.activeFoldersState.bufferFolder!;

    WordContent updatedWord = await dictionaryService.wordStorage.updateWord(expandedFolder.folder, oldWord, newWord);

    if (expandedFolder.folder != newStorage) {
      await dictionaryService.wordStorage.changeWordsFolder(
        expandedFolder.folder,
        newStorage,
        updatedWord
      );

      activeSentences.remove(oldWord);
    } else {
      if (activeSentences.contains(oldWord)) { //So the sentence view remains
        activeSentences.remove(oldWord);
        activeSentences.add(updatedWord);
      }
    }

    updateWordView();
  }


  ///Delete the word.
  Future<void> deleteWord(FolderWords expandedFolder, WordContent word) async {
    await dictionaryService.wordStorage.deleteWord(expandedFolder.folder, word);
    activeSentences.remove(word);

    updateWordView();
  }
}