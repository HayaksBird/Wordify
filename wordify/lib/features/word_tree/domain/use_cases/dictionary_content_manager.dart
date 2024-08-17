import 'package:wordify/features/word_tree/data/folder_repository.dart';
import 'package:wordify/features/word_tree/data/word_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/entities/dictionary.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';
import 'package:wordify/features/word_tree/domain/repositories/word_repository.dart';

final Dictionary _dictionary = Dictionary();
final WordRepository _wordRepo = WordRepositoryImpl();
final FolderRepository _folderRepo = FolderRepositoryImpl();



///WORDS OPERATION MANAGER FOR DICTIONARY
class DictionaryWordsManager {
  
  ///If the folder of the word you are adding is not in cache, then just add in to db
  ///(we don't want to perform unnecessary caching).
  ///If the folder is in cache, then update the folder of the new word and store it in cache.
  ///If necessary, then also update the active folder list.
  Future<void> addNewWord(FolderContent folder, TempWordContainer word) async {
    //If saving to buffer (because buffer can be absent in active folders list)
    if (folder == _dictionary.buffer?.folder) {
      _dictionary.buffer?.words.add(await _wordRepo.addWord(folder, word));
      return;
    }

    FolderWords? fromCache = _dictionary.cachedFolders.get(folder);
    FolderWords? activeFolder = _dictionary.activeFolders.get(folder);

    if (fromCache != null || activeFolder != null) {
      FolderWords expandedFolder = fromCache ?? activeFolder!;
      expandedFolder.words.add(await _wordRepo.addWord(folder, word));
    } else {
      _wordRepo.addWord(folder, word);
    }
  }


  ///Update the folder with the updated word.
  ///Update the cache and the active folder list with the new folder.
  Future<WordContent> updateWord(FolderContent folder, WordContent oldWord, TempWordContainer newWord) async {
    FolderWords activeFolder = _dictionary.activeFolders.get(folder)!;

    WordContent updatedWord = await _wordRepo.updateWord(folder, oldWord, newWord);
    FolderWords expandedFolder = activeFolder;

    expandedFolder.updateWord(oldWord, updatedWord);

    return updatedWord;
  }


  ///
  Future<void> deleteWord(FolderContent folder, WordContent word) async {
    FolderWords activeFolder = _dictionary.activeFolders.get(folder)!;

    activeFolder.words.remove(word);
    await _wordRepo.deleteWord(word);
  }
}


///FOLDERS OPERATION MANAGER FOR DICTIONARY
class DictionaryFoldersManager {

  ///Add a new folder.
  Future<void> createFolder(FolderContent? parentFolder, TempFolderContainer folder) async {
    FolderContent newFolder = await _folderRepo.addFolder(parentFolder, folder);

    _dictionary.foldersInView.insertOne(parentFolder, newFolder);
  }


  ///
  Future<FolderContent> updateFolder(FolderContent oldFolder, TempFolderContainer newFolder) async {
    FolderContent updatedFolder = await _folderRepo.updateFolder(oldFolder, newFolder);
    List<FolderContent> subfolders = _dictionary.foldersInView.getSubitems(oldFolder);

    for (FolderContent subfolder in subfolders) {
      _dictionary.activeFolders.remove(subfolder);
      _dictionary.cachedFolders.remove(subfolder);
    }

    _dictionary.foldersInView.update(oldFolder, updatedFolder);
    return updatedFolder;
  }


  ///Delete a folder with its subfolders.
  ///Remove them from the cache and/or active folder list
  ///if they are present there.
  Future<List<FolderContent>> deleteFolder(FolderContent folder) async {
    List<FolderContent> subfolders = _dictionary.foldersInView.getSubitems(folder);

    for (FolderContent subfolder in subfolders) {
      await _folderRepo.deleteFolder(subfolder);

      _dictionary.activeFolders.remove(subfolder);
      _dictionary.cachedFolders.remove(subfolder);
    }

    _dictionary.foldersInView.delete(folder);

    return subfolders;
  }
}