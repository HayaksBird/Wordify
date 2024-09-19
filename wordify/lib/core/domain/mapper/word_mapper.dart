import 'package:wordify/core/data/model/word_model.dart';
import 'package:wordify/core/domain/entities/word.dart';

///
class WordMapper {
  static WordContentStats extendWord(WordContent word) {
    return word as WordContentStats;
  }


  static WordModel toWordModel(dynamic word) {
    if (word is WordContent) {
      return word as WordModel;
    } else if (word is WordContentStats) {
      return word as WordModel;
    } else {
      throw ArgumentError('Invalid type: ${word.runtimeType}');
    }
  }
}