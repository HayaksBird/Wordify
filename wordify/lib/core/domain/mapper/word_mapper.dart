import 'package:wordify/core/data/model/word_model.dart';
import 'package:wordify/features/flashcards/domain/entities/word.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';

///
class WordMapper {
  static List<WordContentStats> toFlashcards(List<WordContent> words) {
    return words.cast<WordContentStats>();
  }


  static WordModel toWordModel(WordContent word) {
    return word as WordModel;
  }
}