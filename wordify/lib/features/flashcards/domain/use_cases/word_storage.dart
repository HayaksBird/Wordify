import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/core/domain/mapper/folder_mapper.dart';
import 'package:wordify/core/domain/mapper/word_mapper.dart';
import 'package:wordify/core/domain/use_cases/dictionary_manager.dart';
import 'package:wordify/features/flashcards/data/word_repository.dart';
import 'package:wordify/features/flashcards/domain/repositories/word_repository.dart';


///Update word's data
class WordStorage {
  final WordRepository _wordRepo = WordRepositoryImpl();
  final _wordsContent = DictionaryManager().wordsContent;

  
  ///Store the new attempt to the db and update the dictionary.
  Future<WordContentStats> addNewAttempt(
    WordContentStats oldword,
    WordContentStats currentWord,
    int rating
  ) async {
    WordContentStats updatedWord = await _wordRepo.storeNewAttempt(currentWord, rating);

    _wordsContent.updateWord(
      FolderMapper.toFolderModel(oldword.folder),
      WordMapper.toWordModel(oldword),
      WordMapper.toWordModel(updatedWord)
    );

    return updatedWord;
  }


  ///Update the newest attempt's value (does not add a new attempt)
  ///and update the dictionary.
  Future<WordContentStats> updateNewestAttempt(
    WordContentStats oldword,
    WordContentStats currentWord,
    int rating
  ) async {
    WordContentStats updatedWord = await _wordRepo.updateNewestAttempt(currentWord, rating);

    _wordsContent.updateWord(
      FolderMapper.toFolderModel(oldword.folder),
      WordMapper.toWordModel(oldword),
      WordMapper.toWordModel(updatedWord)
    );

    return updatedWord;
  }
}