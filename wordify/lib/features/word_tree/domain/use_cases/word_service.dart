import 'package:wordify/features/word_tree/data/repositories/word_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/repositories/word_repository.dart';

class WordService {
  final WordRepository wordRepo = WordRepositoryImpl();


  Future<Word> addWord(Folder folder, Word word) async {
    return wordRepo.addWord(folder, word);
  }


  Future<Word> updateWord(Folder folder, Word oldWord, Word newWord) async {
    return wordRepo.updateWord(folder, oldWord, newWord);
  }


  Future<void> deleteWord(Word word) async {
    return wordRepo.deleteWord(word);
  }


  Future<List<Word>> getWordsOfFolder(Folder folder) async {
    return wordRepo.getWordsOfFolder(folder);
  }
}