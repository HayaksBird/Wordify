import 'package:wordify/core/data/data_sources/word_persistence.dart';
import 'package:wordify/core/data/model/word_model.dart';
import 'package:wordify/features/flashcards/domain/entities/word.dart';
import 'package:wordify/features/flashcards/domain/repositories/word_repository.dart';

class WordRepositoryImpl implements WordRepository{

  ///Add the new attempt
  @override
  Future<WordContentStats> storeNewAttempt(WordContentStats currentWord, int rating) async {
    WordModel oldModel = currentWord as WordModel;
    WordModel newModel = oldModel.copyWith(
      oldestAttempt: oldModel.middleAttempt,
      middleAttempt: oldModel.newestAttempt,
      newestAttempt: rating
    );

    WordPersistence.update(newModel);

    return newModel;
  }
  

  ///
  @override
  Future<WordContentStats> updateNewestAttempt(WordContentStats currentWord, int rating) async {
    WordModel oldModel = currentWord as WordModel;
    WordModel newModel = oldModel.copyWith(
      newestAttempt: rating
    );

    WordPersistence.update(newModel);

    return newModel;
  }
}