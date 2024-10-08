import 'package:wordify/core/data/data_sources/word_persistence.dart';
import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/data/model/word_model.dart';
import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';
import 'package:wordify/features/word_tree/domain/repositories/word_repository.dart';

///An implementation of the storage access point which utilizes the 
///database operations.
class WordRepositoryImpl implements WordRepository {
  static final WordRepositoryImpl _instance = WordRepositoryImpl._internal();


  factory WordRepositoryImpl() {
    return _instance;
  }


  WordRepositoryImpl._internal();


  ///
  @override
  Future<WordContent> addWord(FolderContent folder, TempWordContainer word) async {
    FolderModel folderModel = folder as FolderModel;

    return WordPersistence.insert(
      folder: folderModel,
      word: word.word,
      translation: word.translation,
      sentence: word.sentence
    );
  }
  

  ///
  @override
  Future<void> deleteWord(WordContent word) async{
    WordPersistence.delete((word as WordModel).id);
  }
  

  ///
  @override
  Future<List<WordContent>> getWordsOfFolder(FolderContent folder) async {
    FolderModel folderModel = folder as FolderModel;

    return WordPersistence.getWordsOfFolder(folderModel);
  }


  ///
  @override
  Future<WordContent> updateWord(FolderContent folder, WordContent oldWord, TempWordContainer newWord) async {
    WordModel oldWordModel = oldWord as WordModel;

    WordModel updatedWord = oldWordModel.copyWith(
      word: newWord.word,
      translation: newWord.translation,
      sentence:newWord.sentence
    );

    await WordPersistence.update(updatedWord);

    return updatedWord;
  }
  

  ///
  @override
  Future<WordContent> changeFolder(FolderContent newFolder, WordContent word) async {
    WordModel wordModel = word as WordModel;
    FolderModel newFolderModel = newFolder as FolderModel;

    WordModel updatedWord = wordModel.copyWith(
      folder: newFolderModel,
      folderId: newFolderModel.id
    );

    await WordPersistence.update(updatedWord);

    return updatedWord;
  }
}