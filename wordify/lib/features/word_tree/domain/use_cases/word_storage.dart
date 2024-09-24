import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/core/domain/mapper/folder_mapper.dart';
import 'package:wordify/core/domain/mapper/word_mapper.dart';
import 'package:wordify/core/domain/use_cases/dictionary_manager.dart';
import 'package:wordify/features/word_tree/data/word_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';
import 'package:wordify/features/word_tree/domain/repositories/word_repository.dart';

///Stores the changed content of the words to the dictionary and to the DB.
class WordStorage {  
  final WordRepository _wordRepo = WordRepositoryImpl();
  final _wordsContent = DictionaryManager().wordsContent;


  ///Add a new word.
  Future<void> addNewWord(FolderContent folder, TempWordContainer word) async {
    WordContent newWord = await _wordRepo.addWord(folder, word);

    _wordsContent.addNewWord(
      FolderMapper.toFolderModel(folder),
      WordMapper.toWordModel(newWord)
    );
  }


  ///Update the folder.
  Future<WordContent> updateWord(FolderContent folder, WordContent oldWord, TempWordContainer newWord) async {
    WordContent updatedWord = await _wordRepo.updateWord(folder, oldWord, newWord);
   
    _wordsContent.updateWord(
      FolderMapper.toFolderModel(folder),
      WordMapper.toWordModel(oldWord),
      WordMapper.toWordModel(updatedWord)
    );

    return updatedWord;
  }


  ///Change the folder of a word.
  Future<void> changeWordsFolder(FolderContent oldFolder, FolderContent newFolder, WordContent word) async {
    WordContent updatedWord = await _wordRepo.changeFolder(newFolder, word);

    _wordsContent.deleteWord(
      FolderMapper.toFolderModel(oldFolder),
      WordMapper.toWordModel(word)
    );

    _wordsContent.addNewWord(
      FolderMapper.toFolderModel(newFolder),
      WordMapper.toWordModel(updatedWord)
    );
  }


  ///Delete a word.
  Future<void> deleteWord(FolderContent folder, WordContent word) async {
    _wordsContent.deleteWord(
      FolderMapper.toFolderModel(folder),
      WordMapper.toWordModel(word)
    );

    _wordRepo.deleteWord(word);
  }
}