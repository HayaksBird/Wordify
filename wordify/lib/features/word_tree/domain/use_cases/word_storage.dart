import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/core/domain/mapper/folder_mapper.dart';
import 'package:wordify/core/domain/mapper/word_mapper.dart';
import 'package:wordify/core/domain/use_cases/dictionary_manager.dart';
import 'package:wordify/features/word_tree/data/word_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';
import 'package:wordify/features/word_tree/domain/repositories/word_repository.dart';

///WORDS OPERATION MANAGER FOR DICTIONARY
class WordStorage {  
  final WordRepository _wordRepo = WordRepositoryImpl();
  final _wordsContent = DictionaryManager().wordsContent;


  ///If the folder of the word you are adding is not in cache, then just add in to db
  ///(we don't want to perform unnecessary caching).
  ///If the folder is in cache, then update the folder of the new word and store it in cache.
  ///If necessary, then also update the active folder list.
  Future<void> addNewWord(FolderContent folder, TempWordContainer word) async {
    WordContent newWord = await _wordRepo.addWord(folder, word);

    _wordsContent.addNewWord(
      FolderMapper.toFolderModel(folder),
      WordMapper.toWordModel(newWord)
    );
  }


  ///Update the folder with the updated word.
  ///Update the cache and the active folder list with the new folder.
  Future<WordContent> updateWord(FolderContent folder, WordContent oldWord, TempWordContainer newWord) async {
    WordContent updatedWord = await _wordRepo.updateWord(folder, oldWord, newWord);
   
    _wordsContent.updateWord(
      FolderMapper.toFolderModel(folder),
      WordMapper.toWordModel(oldWord),
      WordMapper.toWordModel(updatedWord)
    );

    return updatedWord;
  }


  ///
  Future<void> deleteWord(FolderContent folder, WordContent word) async {
    _wordsContent.deleteWord(
      FolderMapper.toFolderModel(folder),
      WordMapper.toWordModel(word)
    );

    _wordRepo.deleteWord(word);
  }
}