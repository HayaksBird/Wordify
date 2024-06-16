import 'package:wordify/features/word_tree/data/model/folder_model.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/data/model/word_model.dart';
import 'package:wordify/features/word_tree/domain/repositories/word_repository.dart';
import 'package:wordify/features/word_tree/data/data_sources/word_persistence.dart';

///An implementation of the storage access point which utilizes the 
///database operations.
class WordRepositoryImpl implements WordRepository {
  //Singleton
  static final WordRepositoryImpl _instance = WordRepositoryImpl._internal();


  factory WordRepositoryImpl() {
    return _instance;
  }


  WordRepositoryImpl._internal();


  @override
  Future<void> addWord(Folder folder, Word word) async {
    FolderModel folderModel = folder as FolderModel;
    await WordPersistence.insert(WordModel.fromWord(word), folderModel.id);
  }
  

  @override
  Future<void> deleteWord(Word word) async{
    WordPersistence.delete((word as WordModel).id);
  }
}