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
  Future<Word> addWord(Folder folder, Word word) async {
    return WordPersistence.insert(WordModel.fromWord(word), (folder as FolderModel).id);
  }


  @override
  Future<void> deleteWord(Word word) async{
    WordPersistence.delete((word as WordModel).id);
  }
  

  @override
  Future<Word> updateWord(Word oldWord, Word newWord) async {
    WordModel oldWordModel = oldWord as WordModel;
    
    WordModel updatedWord = oldWordModel.copyWith(
      word: newWord.word,
      translation: newWord.translation
    );

    WordPersistence.update(updatedWord);
    return updatedWord;
  }
}