import 'package:wordify/features/word_tree/data/repositories/folder_repository.dart';
import 'package:wordify/features/word_tree/data/repositories/word_repository.dart';
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
  Future<void> addNewWord(Folder folder, Word word) async {
    if (_dictionary.cachedFolders.containsKey(folder)) {
      FolderWords expandedFolder = _dictionary.cachedFolders[folder]!;
      expandedFolder.words.add(await _wordRepo.addWord(folder, word));
    } else {
      _wordRepo.addWord(folder, word);
    }
  }


  ///Update the folder with the updated word.
  ///Update the cache and the active folder list with the new folder.
  Future<void> updateWord(Folder folder, Word oldWord, Word newWord) async {
    Word updatedWord = await _wordRepo.updateWord(folder, oldWord, newWord);
    FolderWords expandedFolder = _dictionary.cachedFolders[folder]!;

    expandedFolder.updateWord(oldWord, updatedWord);
  }


  ///
  Future<void> deleteWord(Folder folder, Word word) async {
    FolderWords expandedFolder = _dictionary.cachedFolders[folder]!;

    expandedFolder.words.remove(word);
    await _wordRepo.deleteWord(word);
  }
}


///FOLDERS OPERATION MANAGER FOR DICTIONARY
class DictionaryFoldersManager {

  ///
  Future<void> createFolder(Folder? parentFolder, Folder folder) async {
    Folder newFolder = await _folderRepo.addFolder(parentFolder, folder);

    _dictionary.foldersInView.insertOne(parentFolder, newFolder);
  }


  ///
  Future<void> updateFolder(Folder oldFolder, Folder newFolder) async {
    Folder updatedFolder = await _folderRepo.updateFolder(oldFolder, newFolder);
    List<Folder> subfolders = _dictionary.foldersInView.getSubitems(oldFolder);

    for (Folder subfolder in subfolders) {
      _dictionary.activeFolders.remove(subfolder);
      _dictionary.cachedFolders.remove(subfolder);
    }

    _dictionary.foldersInView.update(oldFolder, updatedFolder);
  }


  ///Delete a folder with its subfolders.
  ///Remove them from the cache and/or active folder list
  ///if they are present there.
  Future<void> deleteFolder(Folder folder) async {
    List<Folder> subfolders = _dictionary.foldersInView.getSubitems(folder);

    for (Folder subfolder in subfolders) {
      await _folderRepo.deleteFolder(subfolder);

      _dictionary.activeFolders.remove(subfolder);
      _dictionary.cachedFolders.remove(subfolder);
    }

    _dictionary.foldersInView.delete(folder);
  }
}