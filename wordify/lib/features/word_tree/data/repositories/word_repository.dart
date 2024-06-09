import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/data/model/word_model.dart';
import 'package:wordify/features/word_tree/domain/repositories/word_repository.dart';
import 'package:wordify/features/word_tree/data/data_sources/word_persistence.dart';

///An implementation of the storage access point which utilizes the 
///database operations.
class WordRepositoryImpl implements WordRepository {
  //Singleton
  static final WordRepositoryImpl _instance = WordRepositoryImpl._privateConstructor();


  factory WordRepositoryImpl() {
    return _instance;
  }


  WordRepositoryImpl._privateConstructor();


  @override
  Future<Word> addWord(Word word) async {
    return WordPersistence.insert(WordModel.fromWord(word));
  }


  @override
  Future<void> deleteWord(int id) async{
    WordPersistence.delete(id);
  }


  @override
  Future<Dictionary> getAllWords() async{
    List<WordModel> words = await WordPersistence.getAll();
    return Dictionary(words : words);
  }


  @override
  Future<Word> getWord(int id) {
    // TODO: implement getWord
    throw UnimplementedError();
  }
  

  @override
  Future<Word> updateWord(Word oldWord, Word newWord) async {
    WordModel updatedWord = WordModel(
      id: (oldWord as WordModel).id,
      word: newWord.word,
      translation: newWord.translation
    );

    WordPersistence.update(updatedWord);
    return updatedWord;
  }
}