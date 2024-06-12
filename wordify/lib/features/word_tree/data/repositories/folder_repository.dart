import 'package:wordify/features/word_tree/data/data_sources/folder_persistence.dart';
import 'package:wordify/features/word_tree/data/data_sources/word_persistence.dart';
import 'package:wordify/features/word_tree/data/model/folder_model.dart';
import 'package:wordify/features/word_tree/data/model/word_model.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
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
}