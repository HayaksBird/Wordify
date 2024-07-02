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
  Future<void> deleteFolder(Folder folder) async {
    await FolderPersistence.delete(folder as FolderModel);
  }


  ///
  @override
  Future<List<Folder>> getRootFolders() async {
    return FolderPersistence.getRootFolders();
  }
  

  @override
  Future<List<Folder>> getChildFolders(Folder folder) {
    FolderModel folderModel = folder as FolderModel;

    return FolderPersistence.getFolders(folderModel.id);
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
  Future<Folder> updateInFolder(Folder folder, Word oldWord, Word newWord) async {
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
  

  @override
  Future<Folder> deleteFromFolder(Folder folder, Word word) async {
    WordModel wordModel = word as WordModel;
    FolderModel folderModel = folder as FolderModel;

    await WordPersistence.delete(wordModel.id);

    FolderModel newFolder = folderModel.copyWith(
      words: List<Word>.from(folderModel.words)
        ..remove(wordModel)
    );

    return newFolder;
  }

  
  ///
  @override
  Future<Folder> updateFolder(Folder oldFolder, Folder newFolder) async {
    FolderModel oldFolderModel = oldFolder as FolderModel;

    FolderModel newFolderModel = oldFolderModel.copyWith(
      name: newFolder.name
    );

    await FolderPersistence.update(newFolderModel);

    return newFolderModel;
  }
}