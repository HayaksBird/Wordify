import 'package:wordify/core/data/data_sources/word_persistence.dart';
import 'package:wordify/core/data/model/word_model.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/features/flashcards/domain/repositories/word_repository.dart';

///
class WordRepositoryImpl implements WordRepository{

  ///Add the new attempt.
  ///Note that the latest attempt will be eliminated.
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
  

  ///Update the latest attempt's value. Note that no new attempt is added.
  ///Only the value of the newest attempt is updated.
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