import 'package:wordify/features/word_tree/data/repositories/word_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/repositories/word_repository.dart';

class WordService {
  final WordRepository wordRepo = WordRepositoryImpl();


  Future<void> addWord(Folder folder, Word word) async {
    return wordRepo.addWord(folder, word);
  }
}