import 'package:wordify/features/word_tree/data/data_sources/folder_persistence.dart';
import 'package:wordify/features/word_tree/data/data_sources/word_persistence.dart';
import 'package:wordify/features/word_tree/data/model/folder_model.dart';
import 'package:wordify/features/word_tree/data/model/word_model.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  static final FolderRepositoryImpl _instance = FolderRepositoryImpl._internal();


  factory FolderRepositoryImpl() {
    return _instance;
  }


  FolderRepositoryImpl._internal();


  ///
  @override
  Future<Folder> addFolder(Folder folder) async {
    return FolderPersistence.insert(FolderModel.fromFolder(folder));
  }


  ///
  @override
  Future<List<Folder>> getAllFolders() async {
    return FolderPersistence.getAll();
  }
  

  ///
  @override
  Future<Folder> getAllWords(Folder folder) async {
    FolderModel folderModel = folder as FolderModel;
    List<WordModel> words = await WordPersistence.getWordsOfFolder(folderModel.id);

    return folderModel.copyWith(
      words: words
    );
  }


  @override
  Future<Folder> addToFolder(Folder folder, Word word) async {
    FolderModel oldFolder = folder as FolderModel;
    WordModel addedWord = await WordPersistence.insert(WordModel.fromWord(word), (oldFolder).id);

    FolderModel newFolder = oldFolder.copyWith(
      words: List<Word>.from(oldFolder.words)
        ..add(addedWord)
    );

    return newFolder;
  }


  @override
  Future<Folder> updateFolder(Folder folder, Word oldWord, Word newWord) async {
    FolderModel oldFolder = folder as FolderModel;
    WordModel oldWordModel = oldWord as WordModel;
    int oldWordIndex = folder.words.indexOf(oldWord);
    
    WordModel updatedWord = oldWordModel.copyWith(
      word: newWord.word,
      translation: newWord.translation
    );

    await WordPersistence.update(updatedWord);

    FolderModel newFolder = oldFolder.copyWith(
      words: List<Word>.from(oldFolder.words)
        ..[oldWordIndex] = updatedWord
    );

    return newFolder;
  }
}